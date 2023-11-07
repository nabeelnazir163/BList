//
//  Connect0BaseVc.swift
//  Wamglam
//
//  Created by iOS Dev on 08/12/21.
//

import UIKit
import Starscream

class ConnectSocketViewModel: NSObject,ViewModel{
    
    var brokenRules      : [BrokenRule]    = [BrokenRule]()
    var recevier_Id      : Dynamic<Int> = Dynamic(0)
    var address          : Dynamic<String> = Dynamic("")
    var search           : Dynamic<String> = Dynamic("")
    
    //Accept Or Reject
    var type             : Dynamic<String> = Dynamic("")
    var productId        : Dynamic<Int> = Dynamic(0)
    var quantity         : Dynamic<Int> = Dynamic(0)
    var vendorId         : Dynamic<Int> = Dynamic(0)
    
    var img              : UIImage?
    var imgUrl           = ""
    var index = 0
    var verificationCode = String()
    var bookingID        = ""
    var bookingStatus    = 0
    var isAgree          = false
    var isValid          : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch_UserData: (() -> ())?
    var didFinishFetch: ((ApiType) -> ())?
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    var baseUrl = "ws://shakti.parastechnologies.in:8068?"
    var socket: WebSocket?
    var senderId: String = AppSettings.UserInfo?.id ?? ""
    var receiverId: String = ""
    var senderType = ""
    var receiverType:String{
        get{
            return senderType == "creator" ? "user" : "creator"
        }
    }
    var room_Id:String {
        get{
            if receiverId == ""{
                return "0"
            }
            else if senderId > (receiverId){
                return "\(receiverId)-\(senderId)"
            }
            else{
                return "\(senderId)-\(receiverId)"
            }
        }
    }
    var expID = ""
    var selectedUserIds = ""
    var socketType: SocketType = .recentChatType
    var isConnected = false
    var connectedCloser:(() -> ())?
    var CompletionHandler : ((_ failure:Error) -> Void)?
    
    var showText = "Please Wait..."
    var chatMessages: [MessageDetails]?
    var recentChatList: [ChatDetails]?
    var filteredChatList: [ChatDetails]?
    var bookedUsersList: [BookedUsersResponseModel.ChatDetails]?
    var filterBookedUsers: [BookedUsersResponseModel.ChatDetails]?
    var notificationsList: [GetNotificationsResponseModel.NotificationDetails]?
    var locations: GetUserLocationsResponseModel?
    //var getChat_Info:GetChatListModel?
    
    
    var updateMessages : (()->())?
    
    var modelType               : AccountType
    init(type:AccountType) {
        modelType = type
    }
    
    //MARK: - Used for Socket Connection Creation
    func connectSocket(){
        let baseUrl = baseUrl + "token=\(AppSettings.UserInfo?.chatToken ?? "")&room=\(room_Id)&userID=\(senderId)"
        print("Base URL : \(baseUrl)")
        guard let socketUrl =  URL(string:baseUrl) else {return}
        socket = WebSocket(request:URLRequest(url: socketUrl))
        socket?.delegate = self
        self.establishConnection()
    }
    
    func connectLocationsSocket() {
        let baseUrl = baseUrl + "token=\(AppSettings.UserInfo?.chatToken ?? "")&userID=\(senderId)"
        print("Base URL : \(baseUrl)")
        guard let socketUrl =  URL(string:baseUrl) else {return}
        socket = WebSocket(request:URLRequest(url: socketUrl))
        socket?.delegate = self
        self.establishConnection()
    }
    //MARK: - Used for Get the recent Chat List From Socket
    func getRecentChatList() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isLoading = false
            self.updateMessages?()
        }
        let param = ["user_id": senderType == "creator" ? senderId + "02" : senderId + "01", "serviceType":SocketType.recentChatType.rawValue, "userType":senderType]
        print(param)
        let encodedData = try! JSONEncoder().encode(param)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return  }
        self.socket?.write(string: jsonString)
    }
    
    func getBookedUsers(of expID: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isLoading = false
            self.updateMessages?()
        }
        let param = [
            "experienceID": expID,
            "serviceType":SocketType.getBookedUsers.rawValue
        ]
        print(param)
        let encodedData = try! JSONEncoder().encode(param)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return  }
        self.socket?.write(string: jsonString)
    }
    
    //MARK: - Socket Connection Method
    
    func establishConnection(){
        guard let socket = socket else{return}
        socket.connect()
    }
    
    //MARK: - Remove Socket Connection 
    func removeSocketConnection(){
        guard let socket = socket else{return}
        socket.disconnect()
    }
    
    
    //MARK: - Used For SendMessage to Another User
    func sendMessage(message:String,msgType: MessageType){
        let param = ["userID":senderId + (senderType == "creator" ? "02" : "01"), "recieverID":receiverId + (senderType == "creator" ? "01" : "02"), "serviceType":SocketType.chatType.rawValue, "msg":message, "room":room_Id, "MessageType":msgType.rawValue, "type":SocketType.chatType.rawValue, "senderType":senderType, "recieverType":receiverType]
        print(param)
        let encodedData = try! JSONEncoder().encode(param)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return }
        self.socket?.write(string:jsonString)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = convertLocalToUTC(dateToConvert: df.string(from: Date()))
        let messageDetails = MessageDetails(id: nil, roomID: nil, sourceUserID: nil, targetUserID: nil, senderType: nil, receiverType: nil, bookingID: nil, bookingStatus: "0", message: message, status: nil, messageType: msgType.rawValue, modifiedOn: nil, createdOn: nil, senderID: senderId, receiverID: receiverId, senderName: nil, receiverName: nil, senderImg: nil, receiverImg: nil)
        self.chatMessages?.append(messageDetails)
        DispatchQueue.main.async {
            self.updateMessages?()
        }
    }
    
    // MARK: - CHECK IN
    func checkIn() {
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            let param = ["userID":"\(AppSettings.UserInfo?.id ?? "")", "experienceID":expID, "serviceType":socketType.rawValue, "Latitude":"\(lat)", "Longitude":"\(long)"]
            print(param)
            let encodedData = try! JSONEncoder().encode(param)
            guard let jsonString = String(data: encodedData,
                                          encoding: .utf8) else { return  }
            self.socket?.write(string: jsonString)
        }
    }
    //MARK: - Make Read Count 0
    func readChat(receiverId: Int){
        let param = ["userID":"\(AppSettings.UserInfo?.id ?? "")", "recieverID":"\(receiverId)", "serviceType":SocketType.chatType.rawValue, "msg":"", "room":room_Id, "MessageType":SocketType.chatType.rawValue, "type":SocketType.chatType.rawValue]
        print(param)
        let encodedData = try! JSONEncoder().encode(param)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return }
        self.socket?.write(string:jsonString)
    }
    
    func expAutoTrack(){
        
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            let param = ["userID":"\(AppSettings.UserInfo?.id ?? "")", "serviceType":SocketType.expAutoTrack.rawValue, "selectedUserID":selectedUserIds, "Latitude":"\(lat)", "Longitude":"\(long)"]
            print(param)
            let encodedData = try! JSONEncoder().encode(param)
            guard let jsonString = String(data: encodedData,
                                          encoding: .utf8) else { return }
            self.socket?.write(string:jsonString)
        }
    }
    
    func getExpAutoTrack(){
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            let param = ["userID":"\(AppSettings.UserInfo?.id ?? "")", "serviceType":SocketType.getExpAutoTrack.rawValue,  "Latitude":"\(lat)", "Longitude":"\(long)"]
            print(param)
            let encodedData = try! JSONEncoder().encode(param)
            guard let jsonString = String(data: encodedData,
                                          encoding: .utf8) else { return }
            self.socket?.write(string:jsonString)
        }
    }
    
    //MARK: - Used For Delete The Complete chat
    func deleteChat(receiverId:String){
        var parms = [String:String]()
        parms["serviceType"] = SocketType.deleteChat.rawValue
        parms["user_id"] = "\(AppSettings.UserInfo?.id ?? "")"
        parms["other_user_id"] = receiverId
        let encodedData = try! JSONEncoder().encode(parms)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return }
        self.socket?.write(string:jsonString)
    }
    
    //MARK: - Used For Delete The Complete chat
    func deletereadCount(receiverId:String){
        var parms = [String:String]()
        parms["type"] = SocketType.deleteReadCount.rawValue
        parms["userID"] = "\(AppSettings.UserInfo?.id ?? "")"
        parms["room"] = room_Id
        parms["recieverID"] = receiverId
        let encodedData = try! JSONEncoder().encode(parms)
        guard let jsonString = String(data: encodedData,
                                      encoding: .utf8) else { return }
        self.socket?.write(string:jsonString)
        
    }
    
    //MARK: - Used For get the previous Chat
    func getChatMessages(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getChatMessages(of: receiverId) { [weak self] (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.chatMessages = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetChatMessages)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func acceptOrRejectBooking(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.acceptOrRejectBooking(status: bookingStatus, booking:bookingID) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.AcceptOrRejectBooking)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func uploadImage(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.uploadImage(image: img) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.imgUrl = res.data?.imgURL ?? ""
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SendImage)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getNotifications() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getNotifications() { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.notificationsList = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.getNotifications)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
}

//MARK: - Socket Delegate Methods
extension ConnectSocketViewModel:WebSocketDelegate{
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            self.connectedCloser?()
            print("***** Websocket is connected: \(headers) *****")
            
        case .disconnected(let reason, let code):
            isConnected = false
            print("***** Websocket is disconnected: \(reason) with code: \(code) *****")
            
        case .text(let string):
            print("***** Received data: \(string) *****")
            guard let data = string.data(using: .utf8) else {return}
            do {
                isLoading = false
                switch socketType {
                case .autoCheckIn:
                    let basic_Info = try JSONDecoder().decode(GetUserLocationsResponseModel.self, from: data)
                    self.locations = basic_Info
                case .recentChatType:
                    let basic_Info = try JSONDecoder().decode(RecentChatResponseModel.self, from: data)
                    self.filteredChatList = basic_Info.data
                    self.recentChatList = basic_Info.data
                case .getBookedUsers:
                    let basic_Info = try JSONDecoder().decode(BookedUsersResponseModel.self, from: data)
                    self.bookedUsersList = basic_Info.data
                    self.filterBookedUsers = basic_Info.data
                default:
                    break
                }
                DispatchQueue.main.async {
                    self.updateMessages?()
                }
            } catch {
                print(error.localizedDescription)
            }
        case .binary(let data):
            print("***** Received data: \(data.count) *****")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
            print("***** Websocket is disconnected *****")
        case .error(let error):
            isConnected = false
            CompletionHandler?(error!)
            print(error?.localizedDescription ?? "")
        case .peerClosed: break
            
        }
    }
}


extension ConnectSocketViewModel{
    func convertLocalToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: convertedDate!)
        
    }
}

// MARK: - ReceiveChatDataModel
struct ReceiveChatDataModel: Codable {
    let senderName, senderID, senderProfilePicture, receiverName: String?
    let receiverID, receiverProfilePicture, message, msgID: String?
    let readStatus, createdOn, messageType, hash, senderOfflineTime, recieverOfflineTime: String?
    let unreadCount: Int?
    let baseURL: String?
    
    enum CodingKeys: String, CodingKey {
        case senderName
        case senderID = "sender_id"
        case senderProfilePicture = "sender_profile_picture"
        case receiverName
        case receiverID = "receiver_id"
        case receiverProfilePicture = "receiver_profile_picture"
        case message
        case msgID = "msgId"
        case readStatus
        case createdOn = "created_on"
        case messageType = "MessageType"
        case hash, senderOfflineTime, recieverOfflineTime, unreadCount
        case baseURL = "baseUrl"
    }
}

// MARK: - GetNotificationsResponseModel
struct GetNotificationsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [NotificationDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    // MARK: - Datum
    struct NotificationDetails: Codable {
        let id, notificationType, notificationMsg, bookingID, userID: String?
        let createdAt, experienceID, expName: String?
        let expImg: String?
        let userName: String?
        let userImg: String?
        let finalAmount: Int?
        let expCategory: String?
        let categories: [Categories]?
        enum CodingKeys: String, CodingKey {
            case id
            case notificationType = "notification_type"
            case notificationMsg = "notification_msg"
            case userID = "user_id"
            case experienceID = "experience_id"
            case bookingID = "booking_id"
            case createdAt = "created_at"
            case expName, expImg, userName, userImg
            case finalAmount = "final_amount"
            case expCategory = "exp_category"
            case categories = "category_name"
        }
        // MARK: - Categories
        struct Categories: Codable {
            let id, name, image, color: String?
            let description, createdAt: String?
            
            enum CodingKeys: String, CodingKey {
                case id, name, image, color, description
                case createdAt = "created_at"
            }
        }
    }
    
}

enum SocketType: String {
    case recentChatType     = "RecentChat"
    case chatType           = "Chat"
    case expAutoTrack       = "ExpautoTrack"
    case getExpAutoTrack    = "GetExpautoTrack"
    case deleteChat         = "ClearChat"
    case responseClearChat  = "clearChat"
    case deleteReadCount    = "read"
    case autoCheckIn        = "autoCheck"
    case manualCheckIn      = "manualCheck"
    case offer              = "Offer"
    case acceptOrReject     = "OfferAcceptReject"
    case creatorType        = "creator"
    case userType           = "user"
    case getBookedUsers     = "GetBookedUserList"
}

enum MessageType:String {
    case text          = "Text"
    case image         = "Image"
}


