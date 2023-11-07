//
//  APIEndPoint.swift
//  GunInstructor
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

enum NetworkEnvironment : String {
    case development = "https://php.parastechnologies.in/blist/"
}

enum BaseURLs : String {
    case Privacy      = "https://www.manzanotactical.com/privacy-policy"
    case ImageBaseURL = "https://php.parastechnologies.in/blist/media/"
    case userImgURL = "https://php.parastechnologies.in/blist/public/assets/uploads/"
    case userCoverPic = "https://php.parastechnologies.in/blist/public/assets/uploads/usercoverImg/"
    case experience_Image = "https://php.parastechnologies.in/blist/public/assets/uploads/experiences/"
    case categoryURL = "https://php.parastechnologies.in/blist/public/assets/uploads/category/"
    case postImgURL = "https://php.parastechnologies.in/blist/public/assets/uploads/posts/"
}

enum APIEndPoint: Equatable{
    static func == (lhs: APIEndPoint, rhs: APIEndPoint) -> Bool {
        return lhs == rhs
    }
    case logIn(param :[String:Any])
    case signup(param :[String:Any])
    case forgotPassword(param: [String:Any])
    case verifyOtp(param:[String:Any])
    case logout(param: [String:Any])
    case socialLogin(param:[String:Any])
    case getProfileDetail(param:[String:Any])
    case updateProfile(param:[String:Any], profileImg:UIImage?, identityDocument:UIImage?)
    case verifyIdentity(userID:[String:Any],image:UIImage?)
    case categories(param: [String:Any])
    case addExperience(param:[String:Any],images:[UIImage?],coverPhoto: UIImage?,videoURL:URL?)
    case updateExperience(param:[String:Any],images:[UIImage?],coverPhoto: UIImage?, videoURL:URL?)
    case allCreators
    case searchCreator(param:[String:Any])
    case switchToCreatorProfile(param: [String:Any])
    case switchToUserProfile(param: [String:Any])
    case addCreatorCommission(param:[String:Any])
    case creatorHome(param:[String:Any])
    case userHome(param:[String:Any])
    case bookingList(param:[String:Any])
    case getUsers(param:[String:Any])
    case searchUsers(param:[String:Any])
    case bookingDetails(param: [String:Any])
    case experienceDetail(String)
    case activateExperience(param:[String:Any])
    case deActivateExperience(param:[String:Any])
    case deleteExperience(param: [String:Any])
    case add_bookings(param:[String:Any])
    case getFavouritesList(param: [String:Any])
    case doFavourite(param: [String:Any])
    case removeFavourite(param: [String:Any])
    case addCard(param:[String:Any])
    case getCardsList(param:[String:Any])
    case promoteExp(param:[String:Any])
    case searchExp(param:[String:Any])
    case searchWishList(param:[String:Any])
    case filter(param:[String:Any])
    case otherFilter(param:[String:Any])
    case postMsg(param:[String:Any])
    case searchComments(param:[String:Any])
    case gpsCheck(param:[String:Any])
    case postComment(param:[String:Any],image:[String:Any])
    case getPostComments(param:[String:Any])
    case likeComment(param:[String:Any])
    case disLikeComment(param:[String:Any])
    case replyComment(param:[String:Any])
    case newCreatedExperiences(param:[String:Any])
    case topExperiences(param:[String:Any])
    case blistFeatureList(param:[String:Any])
    case getNotifications
    case getTransactions
    case getReviews(param:[String:Any])
    case giveRating(param:[String:Any])
    case getAnalytics
    case getExperiences(param:[String:Any])
    case shareFeedback(param:[String:Any])
    case addCoverPhoto(image:UIImage?)
    case updateBlockDates(param:[String:Any])
    case cancelBooking(param:[String:Any])
    case profileDetails
    // Socket
    case chatList(param:[String:Any])
    case acceptOrRejectBooking(param:[String:Any])
    case uploadImage(param:[String:Any],image:[String:Any])
}
extension APIEndPoint:EndPointType{
    var environmentBaseURL : String {
        return NetworkManager.environment.rawValue
    }
    var baseURL: URL{
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String{
        switch  self {
            // Registration
        case .logIn:
            return "auth/login"
        case .signup:
            return "auth/signup"
        case .forgotPassword:
            return "auth/forgot_password"
        case .verifyOtp:
            return "auth/verifyOtp"
        case .socialLogin:
            return "auth/socialLogin"
        case .logout:
            return "auth/logout"
        case .getProfileDetail:
            return "auth/getProfile"
        case .updateProfile:
            return "auth/updateProfile"
        case .addCoverPhoto:
            return "main/uploadCoverImg"
        case .verifyIdentity:
            return "auth/verifyIdentity"
        case .categories:
            return "main/allCategories"
        case .addExperience:
            return "main/addExperiences"
        case .updateExperience:
            return "main/updateExperience"
        case .allCreators:
            return "main/allCreators"
        case .searchCreator:
            return "main/searchbyName"
        case .switchToCreatorProfile:
            return "auth/switchToCreatorProfile"
        case .switchToUserProfile:
            return "auth/switchToUserProfile"
        case .addCreatorCommission:
            return "main/addCreatorCommission"
        case .creatorHome:
            return "main/creatorHome"
        case .userHome:
            return "main/userHome"
        case .bookingList:
            return "main/allBookings"
        case .bookingDetails:
            return "main/getBookingDetails"
        case .experienceDetail(let expId):
            return "main/experienceDetail/\(expId)"
        case .activateExperience:
            return "main/activateExperience"
        case .deActivateExperience:
            return "main/deactivateExperience"
        case .deleteExperience:
            return "main/delExperience"
        case .add_bookings:
            return "main/add_bookings"
        case .getCardsList:
            return "main/cardListing"
        case .addCard:
            return "main/addCardDtl"
        case .getFavouritesList:
            return "main/getAllFavorites"
        case .doFavourite:
            return "main/do_favorites"
        case .removeFavourite:
            return "main/remove_favorites"
        case .promoteExp:
            return "main/addPromote"
        case .searchExp:
            return "main/searchExperience"
        case .filter:
            return "main/filter_search"
        case .otherFilter:
            return "main/other_search"
        case .postMsg:
            return "main/postWishlist"
        case .searchWishList:
            return "main/searchbyKeyword"//"main/searchWishlist"
        case .gpsCheck:
            return "auth/gpsCheck"
        case .postComment:
            return "main/postBlistBoard"
        case .getPostComments:
            return "main/getPostComments"
        case .searchComments:
            return "main/allPosts"
        case .likeComment:
            return "main/doLikePost"
        case .disLikeComment:
            return "main/unlikePost"
        case .replyComment:
            return "main/doCommentPost"
        case .newCreatedExperiences:
            return "main/newCreatedExperiences"
        case .topExperiences:
            return "main/topExperiences"
        case .blistFeatureList:
            return "main/blistFeatureList"
        case .getNotifications:
            return "main/getNotification"
        case .getTransactions:
            return "main/getTransactionDetails"
        case .getAnalytics:
            return "main/analytics"
        case .getUsers:
            return "main/userListExperience"
        case .searchUsers:
            return "main/searchUser"
        case .getReviews:
            return "main/reviewsRatings"
        case .giveRating:
            return "main/giveRatings"
        case .shareFeedback:
            return "auth/send_feedback"
        case .getExperiences:
            return "main/getcalenderExperience"
        case .updateBlockDates:
            return "main/updateblockDates"
        case .cancelBooking:
            return "main/cancelbookingbyExp"
        case .profileDetails:
            return "main/gettingProfileDetails"
            // Socket
        case .chatList:
            return "main/getchatList"
        case .acceptOrRejectBooking:
            return "main/acceptanceBooking"
        case .uploadImage:
            return "main/chatImgUpload"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .experienceDetail:
            return .get
        default:
            return .post
        }
    }
    var task: HTTPTask{
        switch self {
        case .logIn(param: let param),
                .forgotPassword(param: let param),
                .signup(param: let param),.logout(param: let param), .promoteExp(param: let param),.searchExp(param: let param),.filter(param: let param),.otherFilter(param: let param),.deleteExperience(param: let param),.bookingList(param: let param),.acceptOrRejectBooking(param: let param),.searchWishList(param: let param),.gpsCheck(param: let param),.searchComments(param: let param),.getPostComments(param: let param),.replyComment(param: let param),.chatList(param: let param),.newCreatedExperiences(param: let param),.topExperiences(param: let param),.blistFeatureList(param: let param),.getUsers(param: let param),.searchUsers(param: let param),.getReviews(param: let param),.giveRating(param: let param),.shareFeedback(param: let param),.getExperiences(param: let param),.updateBlockDates(param: let param),.cancelBooking(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: headers)
        case .experienceDetail:
            return.requestParametersAndHeaders(bodyParameters: [:], bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: headers)
        case .verifyIdentity(userID: let param,image: let verifyImage):
            let boundry = "Boundary-\(UUID().uuidString)"
            var body = Data()
            let boundaryPrefix = "--\(boundry)\r\n"
            for (key, value) in param {
                body.append(boundaryPrefix)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
            
            if let image = verifyImage {
                let imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"identity_document\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
                body.append( "Content-Type: image/jpeg\r\n\r\n")
                body.append(imgData)
                body.append( "\r\n")
            }
            body.append( "--\(boundry)--\r\n")
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundry)","Authorization": "Bearer \(AppSettings.Token)"])
        case .verifyOtp(param: let param),
                .socialLogin(param: let param),
                .getProfileDetail(param: let param),
                .switchToCreatorProfile(param: let param),
                .switchToUserProfile(param: let param),
                .addCreatorCommission(param: let param), .creatorHome(param: let param), .userHome(param: let param), .bookingDetails(param: let param),.activateExperience(param: let param),.deActivateExperience(param: let param),.add_bookings(param: let param),.getCardsList(param: let param),.addCard(param: let param),.searchCreator(param: let param),.getFavouritesList(param: let param),.doFavourite(param: let param),.removeFavourite(param: let param),.postMsg(param: let param),.likeComment(param: let param),.disLikeComment(param: let param):
            return.requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: headers)
            
        case .addExperience(param: let param, images: let arrOfImage, coverPhoto: let coverPhoto, videoURL: let videoURL),.updateExperience(param: let param, images: let arrOfImage, coverPhoto: let coverPhoto, videoURL: let videoURL):
            let body = self.generateBoundaryData(param:param, images: arrOfImage, coverPhoto: coverPhoto, videoURL: videoURL)
            return .requestMultipart(data: body.data, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(body.boundary)", "Authorization": "Bearer \(AppSettings.Token)"])
        case .postComment(param: let param, image: let image),.uploadImage(param: let param, image: let image):
            let body = self.generateBoundaryData(param:param, images: image)
            return .requestMultipart(data:body.data, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(body.boundary)","Authorization":"Bearer \(AppSettings.Token)"])
        case .addCoverPhoto(image: let coverPhoto):
            let boundry = "Boundary-\(UUID().uuidString)"
            var body = Data()
            let boundaryPrefix = "--\(boundry)\r\n"
            if let image = coverPhoto {
                let imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"cover\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
                body.append( "Content-Type: image/jpeg\r\n\r\n")
                body.append(imgData)
                body.append( "\r\n")
            }
                        
            body.append(boundaryPrefix)
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundry)", "Authorization": "Bearer \(AppSettings.Token)"])
        case .updateProfile(param: let param, profileImg: let profileImg, identityDocument: let identityDocument):
            let boundry = "Boundary-\(UUID().uuidString)"
            var body = Data()
            let boundaryPrefix = "--\(boundry)\r\n"
            for (key, value) in param {
                body.append(boundaryPrefix)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
            if let image = profileImg {
                let imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"profile_img\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
                body.append( "Content-Type: image/jpeg\r\n\r\n")
                body.append(imgData)
                body.append( "\r\n")
            }
            if let image = identityDocument {
                let imgData = image.jpegData(compressionQuality: 0.5) ?? Data()
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"identity_document\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
                body.append( "Content-Type: image/jpeg\r\n\r\n")
                body.append(imgData)
                body.append( "\r\n")
            }
            
            body.append(boundaryPrefix)
            return .requestMultipart(data: body, additionHeaders: ["Content-Type":"multipart/form-data; boundary=\(boundry)", "Authorization": "Bearer \(AppSettings.Token)"])
        default:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .formDataEncoding, urlParameters: nil, additionHeaders: headers)
            
        }
    }
    var headers: HTTPHeaders? {
        switch self{
        case .logIn,
                .forgotPassword,
                .signup,.logout:
            return ["Content-Type":NetworkManager.contentType]
        case .userHome,.searchComments,.searchWishList,.experienceDetail,.blistFeatureList,.newCreatedExperiences,.topExperiences,.searchExp:
            if AppSettings.Token == ""{
                return ["Content-Type":NetworkManager.contentType]
            }
            else{
                return ["Content-Type":NetworkManager.contentType, "Authorization": "Bearer \(AppSettings.Token)"]
            }
        default:
            if AppSettings.Token == ""{
                return ["Content-Type":NetworkManager.contentType]
            }
            return ["Content-Type":NetworkManager.contentType, "Authorization": "Bearer \(AppSettings.Token)"]
        }
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    mutating func appendAny(_ obj: Any) {
        if let data = (obj as? String)?.data(using: .utf8) {
            append(data)
        }else if let data = try? JSONSerialization.data(withJSONObject: obj, options: []) {
            append(data)
        }
    }
}

extension APIEndPoint{
    func generateBoundaryData(param: [String:Any], images: [UIImage?], coverPhoto: UIImage?, videoURL: URL?) -> (data: Data, boundary: String) {
        let boundry = "Boundary-\(UUID().uuidString)"
        var body = Data()
        let boundaryPrefix = "--\(boundry)\r\n"
        for (key, value) in param {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append(boundaryPrefix)
        
        for image in images.enumerated(){
            if let img = image.element {
                let imgData = img.jpegData(compressionQuality: 0.5) ?? Data()
                body.append( boundaryPrefix)
                body.append( "Content-Disposition: form-data; name=\"images[\(image.offset)]\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
                body.append( "Content-Type: image/jpeg\r\n\r\n")
                body.append(imgData)
                body.append( "\r\n")
            }
        }
        
        body.append(boundaryPrefix)
        
        if let coverPhoto = coverPhoto {
            let imgData = coverPhoto.jpegData(compressionQuality: 0.5) ?? Data()
            body.append( boundaryPrefix)
            body.append( "Content-Disposition: form-data; name=\"cover_img\"; filename=\"image_\(Date().timeIntervalSince1970).jpeg\"\r\n")
            body.append( "Content-Type: image/jpeg\r\n\r\n")
            body.append(imgData)
            body.append( "\r\n")
        }
        
        body.append(boundaryPrefix)
        
        // video_url
        if let videoURL = videoURL {
            let filename = "\(Date().timeIntervalSince1970).\(videoURL.absoluteURL.pathExtension)"
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"video_url\"; filename=\"\(filename)\"\r\n")
            if filename.lowercased() == "mov"{
                body.append("Content-Type: video/quicktime\r\n\r\n")
            }
            else{
                body.append("Content-Type: video/mp4\r\n\r\n")
            }
            let data = try? Data.init(contentsOf: videoURL)
            body.append(data ?? Data())
            body.append("\r\n")
        }
        
        body.append("--".appending(boundry.appending("--")))
        return (body, boundry)
    }
    func generateBoundaryData(param: [String:Any], images: [String:Any]) -> (data: Data, boundary: String) {
        let boundry = "Boundary-\(UUID().uuidString)"
        var body = Data()
        let boundaryPrefix = "--\(boundry)\r\n"
        for (key, value) in param {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        body.append(boundaryPrefix)
        
        for (paramName, image) in images{
            if let image = image as? UIImage {
                body.append(boundaryPrefix)
                let filename = "\(Date().timeIntervalSince1970).jpg"
                body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: image/jpg\r\n\r\n")
                body.append(image.jpegData(compressionQuality: 0.1) ?? Data())
                body.append("\r\n")
            }
        }
        
        body.append("--".appending(boundry.appending("--")))
        return (body, boundry)
    }
    
}

