//
//  CreatorInboxtabVC.swift
//  BList
//
//  Created by iOS TL on 25/05/22.
//

import UIKit

class CreatorInboxtabVC: BaseClassVC {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        socketVM = ConnectSocketViewModel(type: .creator)
        let nibName = UINib(nibName: "SearchChatHeader", bundle: nil)
        msgTblView.register(nibName, forHeaderFooterViewReuseIdentifier: "SearchChatHeader")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: socketVM)
        for btn in msgNotificationBtns {
            if btn.isSelected == true {
                btn.tag == 0 ? connectSocket() : socketVM.getNotifications()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.socketVM.removeSocketConnection()
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
        socketVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .AcceptOrRejectBooking:
                self.socketVM.socketType = .recentChatType
                self.socketVM.getRecentChatList()
            case .getNotifications:
                break
            default:
                break
            }
        }
    }
    
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
extension CreatorInboxtabVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == msgTblView{
            return socketVM.filteredChatList?.count ?? 0
        }
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == msgTblView{
            return (socketVM.recentChatList?.count ?? 0) > 0 ? 1 : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == msgTblView{
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchChatHeader" ) as? SearchChatHeader else{return .init()}
            headerView.socketVM = socketVM
            headerView.searchTF.addTarget(self, action: #selector(searchFieldAction(_:)), for: .editingChanged)
            return headerView
        }
        return .init()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == msgTblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else{ return .init()}
            cell.configureCellAtCreator(with: socketVM.filteredChatList?[indexPath.row])
            cell.acceptBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnAction(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(rejectBtnAction(_:)), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableCell", for: indexPath) as! NotificationsTableCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == msgTblView{
            return 47
        }
        return 0
    }
    @objc func acceptBtnAction(_ sender:UIButton){
        socketVM.bookingID = socketVM.recentChatList?[sender.tag].bookingID ?? ""
        socketVM.bookingStatus = 1
        socketVM.acceptOrRejectBooking()
    }
    @objc func rejectBtnAction(_ sender:UIButton){
        socketVM.bookingID = socketVM.recentChatList?[sender.tag].bookingID ?? ""
        socketVM.bookingStatus = 0
        socketVM.acceptOrRejectBooking()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == msgTblView {
            let vc = UIStoryboard.loadChatVC()
            vc.chatDetails = socketVM.recentChatList?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
