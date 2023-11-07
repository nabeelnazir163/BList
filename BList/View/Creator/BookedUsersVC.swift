//
//  BookedUsersVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 28/04/23.
//

import UIKit

class BookedUsersVC: BaseClassVC {
    @IBOutlet weak var msgTblView           : UITableView!
    @IBOutlet weak var noDataLbl            : UILabel!
    // MARK: - PROPERTIES
    var socketVM: ConnectSocketViewModel!
    var expID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "SearchChatHeader", bundle: nil)
        msgTblView.register(nibName, forHeaderFooterViewReuseIdentifier: "SearchChatHeader")
        socketVM = ConnectSocketViewModel(type: .creator)
    }
    @objc func searchFieldAction(_ sender: UITextField){
        if sender.text?.isEmpty == true{
            socketVM.filterBookedUsers = socketVM.bookedUsersList
        }
        else{
            let receiverList = socketVM.bookedUsersList?.filter({
                $0.receiverID != AppSettings.UserInfo?.id ?? ""
            })
            socketVM.filterBookedUsers = receiverList?.filter({ chatDetails in
                return chatDetails.receiverName?.range(of: (sender.text ?? ""), options: .caseInsensitive) != nil
            })
        }
        msgTblView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: socketVM)
        connectSocket()
    }
    
    func connectSocket(){
        socketVM.senderType = AppSettings.UserInfo?.role ?? "" == "1" ? "user" : "creator"
        if socketVM.isConnected == true {
            socketVM.socketType = .getBookedUsers
            socketVM.getBookedUsers(of: expID)
        } else {
            socketVM.connectSocket()
        }
        
        socketVM.connectedCloser = { [weak self] in
            // Socket is connected
            guard let self = self else{return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.socketVM.socketType = .getBookedUsers
                self.socketVM.getBookedUsers(of: self.expID)
            }
        }
        socketVM.updateMessages = { [weak self] in
            // Updated Messages
            guard let self = self else{return}
            self.msgTblView.reloadData()
            self.noDataLbl.isHidden = (self.socketVM.bookedUsersList?.count ?? 0) > 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.socketVM.removeSocketConnection()
    }

}
// MARK: - TABLE VIEW DATA SOURCE METHODS
extension BookedUsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return socketVM.filterBookedUsers?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            return (socketVM.filterBookedUsers?.count ?? 0) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchChatHeader" ) as? SearchChatHeader else{return .init()}
            headerView.socketVM = socketVM
            headerView.searchTF.addTarget(self, action: #selector(searchFieldAction(_:)), for: .editingChanged)
            return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 47
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as? MessageTableCell else{ return .init()}
            cell.configureCellAtCreator(with: socketVM.filterBookedUsers?[indexPath.row])
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetails = socketVM.filterBookedUsers?[indexPath.row]
            let vc = UIStoryboard.loadChatVC()
        vc.chatDetails = ChatDetails(message: userDetails?.message, createdOn: userDetails?.createdOn, readStatus: nil, messageType: nil, bookingID: nil, bookingStatus: nil, senderType: nil, recieverType: nil, sourceUserID: nil, targetUserID: nil, hash: nil, senderOfflineTime: nil, recieverOfflineTime: nil, unreadCount: nil, senderName: userDetails?.senderName, senderID: userDetails?.senderID, senderProfilePicture: userDetails?.senderProfilePicture, receiverName: userDetails?.receiverName, receiverID: userDetails?.receiverID, receiverProfilePicture: userDetails?.receiverProfilePicture)
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
