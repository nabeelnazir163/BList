//
//  UInboxVC.swift
//  BList
//
//  Created by iOS Team on 11/05/22.
//

import UIKit
import IBAnimatable

class UInboxVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var msgTblView           : UITableView!
    @IBOutlet var msgNotificationBtns       : [UIButton]!
    @IBOutlet weak var notificationTblView  : UITableView!
    @IBOutlet weak var msgView              : UIView!
    @IBOutlet weak var notificationView     : UIView!
    @IBOutlet weak var activeLbl            : UILabel!
    @IBOutlet weak var noDataLbl            : UILabel!
    // MARK: - PROPERTIES
    var socketVM: ConnectSocketViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        socketVM = ConnectSocketViewModel(type: .user)
        let nibName = UINib(nibName: "SearchChatHeader", bundle: nil)
        msgTblView.register(nibName, forHeaderFooterViewReuseIdentifier: "SearchChatHeader")
    }
    @objc func searchFieldAction(_ sender: UITextField){
        if sender.text?.isEmpty == true{
            socketVM.filteredChatList = socketVM.recentChatList
        }
        else{
            let receiverList = socketVM.recentChatList?.filter({
                $0.receiverID != AppSettings.UserInfo?.id ?? ""
            })
            socketVM.filteredChatList = receiverList?.filter({ chatDetails in
                return chatDetails.receiverName?.range(of: (sender.text ?? ""), options: .caseInsensitive) != nil
            })
        }
        msgTblView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: socketVM)
        for btn in msgNotificationBtns {
            if btn.isSelected == true {
                btn.tag == 0 ? connectSocket() : socketVM.getNotifications()
            }
        }
        //        connectSocket()
        socketVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            self.noDataLbl.isHidden = (self.socketVM.notificationsList?.count ?? 0) != 0
            self.notificationTblView.reloadData()
        }
    }
    func connectSocket(){
        socketVM.senderType = AppSettings.UserInfo?.role ?? "" == "1" ? "user" : "creator"
        socketVM.connectSocket()
        socketVM.connectedCloser = { [weak self] in
            // Socket is connected
            guard let self = self else{return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.socketVM.socketType = .recentChatType
                self.socketVM.getRecentChatList()
            }
        }
        socketVM.updateMessages = { [weak self] in
            // Updated Messages
            guard let self = self else{return}
            self.notificationView.isHidden = true
            self.msgTblView.reloadData()
            self.noDataLbl.isHidden = (self.socketVM.recentChatList?.count ?? 0) > 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.socketVM.removeSocketConnection()
    }
    
    // MARK: - IBACTIONS
    @IBAction func actionMsgNotifications(_ sender: UIButton) {
        for btn in msgNotificationBtns {
            btn.isSelected.toggle()
            btn.titleLabel?.font = (sender.tag == btn.tag) ? AppFont.cabinBold.withSize(23.0) : AppFont.cabinRegular.withSize(21.0)
        }
        
        activeLbl.frame.origin.x = msgNotificationBtns[sender.tag].frame.origin.x + 40
        
        msgView.isHidden = sender.tag == 1
        notificationView.isHidden = sender.tag == 0
        if sender.tag == 0 {
            if socketVM.isConnected == true {
                self.socketVM.socketType = .recentChatType
                self.socketVM.getRecentChatList()
            } else {
                self.socketVM.connectSocket()
            }
        } else {
            socketVM.getNotifications()
        }
        
    }
}
// MARK: - TABLE VIEW DATA SOURCE METHODS
extension UInboxVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == msgTblView{
            return socketVM.filteredChatList?.count ?? 0
        }
        return socketVM.notificationsList?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == msgTblView{
            return (socketVM.recentChatList?.count ?? 0) > 0 ? 1 : 0
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == msgTblView{
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchChatHeader" ) as? SearchChatHeader else{return .init()}
            headerView.socketVM = socketVM
            headerView.searchTF.addTarget(self, action: #selector(searchFieldAction(_:)), for: .editingChanged)
            return headerView
        }
        else{
            return .init()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == msgTblView{
            return 47
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == msgTblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else{ return .init()}
            cell.configureCellAtUser(with: socketVM.filteredChatList?[indexPath.row])
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableCell", for: indexPath) as? NotificationsTableCell else { return .init() }
            cell.configureCell(with: socketVM.notificationsList?[indexPath.row])
            let categories = socketVM.notificationsList?[indexPath.row].categories
            cell.categories = categories
            cell.catCV.isHidden = (categories?.count ?? 0) == 0
            cell.catCV.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == msgTblView {
            let vc = UIStoryboard.loadChatVC()
            vc.chatDetails = socketVM.filteredChatList?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class MessageTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var photoCVHeight        : NSLayoutConstraint!
    @IBOutlet weak var countLbl             : AnimatableLabel!
    @IBOutlet weak var receiverUserImg      : UIImageView!
    @IBOutlet weak var receiverUserNameLbl  : UILabel!
    @IBOutlet weak var userMsg              : UILabel!
    @IBOutlet weak var durationLbl          : UILabel!
    @IBOutlet weak var photoCV              : UICollectionView!
    @IBOutlet weak var acceptOrRejectView   : UIView!
    @IBOutlet weak var acceptBtn            : UIButton!
    @IBOutlet weak var rejectBtn            : UIButton!
    @IBOutlet weak var imageContainerView   : UIView!
    @IBOutlet weak var postedImage          : UIImageView!
    @IBOutlet weak var txtSV                : UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if photoCV != nil {
            photoCV.dataSource = self
            photoCV.delegate = self
        }
    }
    func configureCellAtUser(with data: ChatDetails?){
        
        if data?.receiverID == AppSettings.UserInfo?.id ?? ""{
            // If receiverId doesn't match with your id then the message comes from sender
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.senderProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.senderName ?? ""
            userMsg.text = data?.message ?? ""
        }
        else{
            // This message belongs to you
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.receiverProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.receiverName ?? ""
            userMsg.text = "You: " + (data?.message ?? "")
        }
        durationLbl.text = DateConvertor.shared.timeAgo(for: data?.createdOn ?? "", dateFormat: .yyyyMMddHHmmss)
        countLbl.isHidden = (data?.unreadCount ?? 0) == 0
        countLbl.text = "\(data?.unreadCount ?? 0)"
        txtSV.isHidden = data?.messageType == "Image" ? true : false
        imageContainerView.isHidden = data?.messageType == "Image" ? false : true
        postedImage.setImage(link: data?.message ?? "")
    }
    
    
    func configureCellAtCreator(with data: ChatDetails?){
        
        if data?.receiverID == AppSettings.UserInfo?.id ?? ""{
            // If receiverId doesn't match with your id then the message comes from sender
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.senderProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.senderName ?? ""
            userMsg.text = data?.message ?? ""
        }
        else{
            // This message belongs to you
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.receiverProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.receiverName ?? ""
            userMsg.text = "You: " + (data?.message ?? "")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let createDate = data?.createdOn, let date = formatter.date(from: createDate), #available(iOS 13.0, *){
            durationLbl.text = date.timeAgoDisplay()
        }
        else{
            durationLbl.text = ""
        }
        
        countLbl.text = "\(data?.unreadCount ?? 0)"
        countLbl.isHidden = (data?.unreadCount ?? 0) == 0
        acceptOrRejectView.isHidden = (data?.bookingStatus ?? "").isEmpty == true ? false : true
        userMsg.isHidden = data?.messageType == "Image" ? true : false
        imageContainerView.isHidden = data?.messageType == "Image" ? false : true
        postedImage.setImage(link: data?.message ?? "")
        
    }
    
    func configureCellAtCreator(with data: BookedUsersResponseModel.ChatDetails?){
        
        if data?.receiverID == AppSettings.UserInfo?.id ?? ""{
            // If receiverId doesn't match with your id then the message comes from sender
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.senderProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.senderName ?? ""
            userMsg.text = data?.message ?? ""
        }
        else{
            // This message belongs to you
            receiverUserImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.receiverProfilePicture ?? ""))
            receiverUserNameLbl.text = data?.receiverName ?? ""
            userMsg.text = "You: " + (data?.message ?? "")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let createDate = data?.createdOn, let date = formatter.date(from: createDate), #available(iOS 13.0, *){
            durationLbl.text = date.timeAgoDisplay()
        }
        else{
            durationLbl.text = ""
        }
        countLbl.isHidden = true//(data?.unreadCount ?? 0) == 0
        acceptOrRejectView.isHidden = (data?.bookingStatus ?? "").isEmpty == true ? false : true
        userMsg.isHidden = false//data?.messageType == "Image" ? true : false
        imageContainerView.isHidden = true//data?.messageType == "Image" ? false : true
        postedImage.setImage(link: data?.message ?? "")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 42)
    }
}


class PhotoCollectionCell: UICollectionViewCell {
    
}


class NotificationsTableCell: UITableViewCell {
    @IBOutlet weak var expImg               : UIImageView!
    @IBOutlet weak var userImg              : UIImageView!
    @IBOutlet weak var expName              : UILabel!
    @IBOutlet weak var userName             : UILabel!
    @IBOutlet weak var stack_rate           : UIStackView!
    @IBOutlet weak var notificationMsg      : UILabel!
    @IBOutlet weak var notificationTimeLbl  : UILabel!
    @IBOutlet weak var catCV                : UICollectionView! {
        didSet {
            catCV.delegate = self
            catCV.dataSource = self
        }
    }
    var categories: [GetNotificationsResponseModel.NotificationDetails.Categories]?
    func configureCell(with data: GetNotificationsResponseModel.NotificationDetails?) {
        notificationMsg.text = data?.notificationMsg ?? ""
        notificationTimeLbl.text = DateConvertor.shared.convert(dateInString: data?.createdAt ?? "", from: .yyyyMMddHHmmss, to: .ddMMMyyyy).dateInString
        expName.text = data?.expName ?? ""
        userName.text = data?.userName ?? ""
        userImg.setImage(link: data?.userImg ?? "")
        expImg.setImage(link: data?.expImg ?? "")
    }
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension NotificationsTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else{return .init()}
        cell.configureCell(with: categories?[indexPath.row])
        return cell
    }
}

