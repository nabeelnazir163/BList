//
//  ChatVC.swift
//  BList
//
//  Created by iOS Team on 11/05/22.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift
import IBAnimatable
class ChatVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var chatTblView          : UITableView!
    @IBOutlet weak var msgTxtview           : GrowingTextView!
    @IBOutlet weak var receiverNameLbl      : UILabel!
    @IBOutlet weak var receiverImg          : UIImageView!
    @IBOutlet weak var searchBtn            : UIButton!
    @IBOutlet weak var txtViewContainerBottomConst   : NSLayoutConstraint!
    @IBOutlet weak var accept_RejectView    : UIView!
    // MARK: - PROPERTIES
    var socketVM: ConnectSocketViewModel!
    var userVM  : UserViewModel!
    var chatDetails:ChatDetails?
    var receiverID = ""
    var receiverName = ""
    var receiverImgString = ""
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        msgTxtview.font = AppFont.cabinRegular.withSize(15.0)
        socketVM = ConnectSocketViewModel(type: .creator)
        setUpVM(model: socketVM, hideKeyboardWhenTapAround: false)
        setUpUI()
        connectSocket()
        socketVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .GetChatMessages:
                self.chatTblView.reloadData()
                if (self.socketVM.chatMessages?.count ?? 0) > 0{
                    self.chatTblView.scrollToRow(at: IndexPath(row: (self.socketVM.chatMessages?.count ?? 0)-1, section: 0), at: .bottom, animated: true)
                }
            case .SendImage:
                self.socketVM.sendMessage(message: self.socketVM.imgUrl,msgType: .image)
            case .AcceptOrRejectBooking:
                if let index = self.socketVM.chatMessages?.firstIndex(where: {$0.bookingID == self.socketVM.bookingID}) {
                    self.socketVM.chatMessages?[index].bookingStatus = self.socketVM.bookingStatus == 1 ? "1" : "2"
                    self.chatTblView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
                
            default:
                break
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.socketVM.removeSocketConnection()
    }
    
    func connectSocket(){
        socketVM.receiverId = receiverID
        socketVM.senderType = AppSettings.UserInfo?.role ?? "" == "1" ? "user" : "creator"
        socketVM.connectSocket()
        socketVM.connectedCloser = {
            // Socket is connected
            self.socketVM.getChatMessages()
        }
        socketVM.updateMessages = { [weak self] in
            // Updated Messages
            guard let self = self else{return}
            self.chatTblView.reloadData()
            if let chatCount = self.socketVM.chatMessages?.count, chatCount > 0 {
                self.chatTblView.scrollToRow(at: IndexPath(row: chatCount-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    func setUpUI(){
        if let chatDetails = chatDetails{
            if chatDetails.receiverID == AppSettings.UserInfo?.id ?? ""{
                receiverID = chatDetails.senderID ?? ""
                receiverImg.setImage(link: BaseURLs.userImgURL.rawValue + (chatDetails.senderProfilePicture ?? ""))
                receiverNameLbl.text = chatDetails.senderName ?? ""
                
            }
            else{
                receiverID = chatDetails.receiverID ?? ""
                receiverImg.setImage(link: BaseURLs.userImgURL.rawValue + (chatDetails.receiverProfilePicture ?? ""))
                receiverNameLbl.text = chatDetails.receiverName ?? ""
            }
        }
        else {
            receiverNameLbl.text = receiverName
            receiverImg.setImage(link: receiverImgString)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification)  {
        
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        let lastVisibleCell = self.chatTblView.indexPathsForVisibleRows?.last
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            let y = keyboardFrame.height - CGFloat(bottomPadding ?? 0.0)
            self.txtViewContainerBottomConst.constant = y + 20
            self.view.layoutIfNeeded()
            if let lastVisibleCell = lastVisibleCell {
                self.chatTblView.scrollToRow(at: lastVisibleCell, at: .bottom, animated: false)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.txtViewContainerBottomConst.constant = 20
            self.view.layoutIfNeeded()
        })
    }
    // MARK: - IBACTIONS
    @IBAction func actionSend(_ sender: UIButton) {
         if let msg = msgTxtview.text, !msg.isEmpty {
         socketVM.sendMessage(message: msg,msgType: .text)
         msgTxtview.text.removeAll()
         } else {
         showErrorMessages(message: "Enter message to send.")
         }
    }
    
    @IBAction func actionPhoto(_ sender: UIButton) {
        let share = CameraHandler.shared
        share.showActionSheet(vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            self.socketVM.img = img
            self.socketVM.uploadImage()
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension ChatVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socketVM.chatMessages?.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = socketVM.chatMessages?[indexPath.row]
        if message?.receiverID ?? "" == AppSettings.UserInfo?.id ?? ""{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableCell", for: indexPath) as? ChatTableCell else{ return .init() }
            cell.configureCell(with: message,isSender: false)
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(acceptAction(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(rejectAction(_:)), for: .touchUpInside)
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableCell", for: indexPath) as? ChatTableCell else{ return .init()}
            cell.configureCell(with: message,isSender: true)
            return cell
        }
    }
    @objc func acceptAction(_ sender: UIButton) {
        socketVM.bookingID = socketVM.chatMessages?[sender.tag].bookingID ?? ""
        socketVM.bookingStatus = 1
        socketVM.acceptOrRejectBooking()
    }
    @objc func rejectAction(_ sender: UIButton) {
        socketVM.bookingID = socketVM.chatMessages?[sender.tag].bookingID ?? ""
        socketVM.bookingStatus = 0
        socketVM.acceptOrRejectBooking()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageDetails = socketVM.chatMessages?[indexPath.row]
        if messageDetails?.messageType ?? "" == "Image" || messageDetails?.messageType ?? "" == "image" {
            let vc = UIStoryboard.loadZoomImageVC()
            vc.imageString = messageDetails?.message ?? ""
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


class ChatTableCell: UITableViewCell {
    @IBOutlet weak var msgLbl           : UILabel!
    @IBOutlet weak var userImg          : UIImageView!
    @IBOutlet weak var postedImage      : UIImageView!
    @IBOutlet weak var imageContainer   : UIView!
    @IBOutlet weak var messageContainer : UIView!
    @IBOutlet weak var acceptRejectSV   : UIStackView!
    @IBOutlet weak var acceptBtn        : AnimatableButton!
    @IBOutlet weak var rejectBtn        : AnimatableButton!
    
    func configureCell(with data: MessageDetails?, isSender:Bool){
        if isSender{
            if data?.messageType ?? "" == "text" || data?.messageType ?? "" == "Text"{
                msgLbl.text = data?.message ?? ""
                imageContainer.isHidden = true
                messageContainer.isHidden = false
            }
            else{
                imageContainer.isHidden = false
                messageContainer.isHidden = true
                postedImage.setImage(link: data?.message ?? "")
            }
            
        }
        else{
            userImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.senderImg ?? ""))
            if data?.messageType ?? "" == "text" || data?.messageType ?? "" == "Text"{
                msgLbl.text = data?.message ?? ""
                imageContainer.isHidden = true
                messageContainer.isHidden = false
            }
            else{
                imageContainer.isHidden = false
                messageContainer.isHidden = true
                postedImage.setImage(link: data?.message ?? "")
            }
            if data?.receiverType == "creator" {
                if data?.bookingStatus ?? "" == "1" {
                    acceptRejectSV.isHidden = false
                    acceptBtn.isHidden = false
                    acceptBtn.setTitle("Accepted", for: .normal)
                    acceptBtn.setImage(nil, for: .normal)
                    acceptBtn.isUserInteractionEnabled = false
                    rejectBtn.isHidden = true
                } else if data?.bookingStatus ?? "" == "0" && data?.bookingID ?? "" != "0"{
                    rejectBtn.isHidden = false
                    rejectBtn.setTitle("Rejected", for: .normal)
                    rejectBtn.setImage(nil, for: .normal)
                    rejectBtn.isUserInteractionEnabled = false
                    acceptBtn.isHidden = true
                } else if data?.bookingStatus ?? "" == "0" && data?.bookingID ?? "" == "0" {
                    acceptRejectSV.isHidden = true
                } else {
                    acceptRejectSV.isHidden = false
                    acceptBtn.isHidden = false
                    rejectBtn.isHidden = false
                    acceptBtn.isUserInteractionEnabled = true
                    rejectBtn.isUserInteractionEnabled = true
                    acceptBtn.setImage(UIImage(named: "accept_tick"), for: .normal)
                    acceptBtn.setTitle("Accept", for: .normal)
                    rejectBtn.setImage(UIImage(named: "reject_cross"), for: .normal)
                    rejectBtn.setTitle("Reject", for: .normal)
                }
            } else {
                acceptRejectSV.isHidden = true
            }
        }
    }
}
