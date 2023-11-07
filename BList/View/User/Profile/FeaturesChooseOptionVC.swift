//
//  FeaturesChooseOptionVC.swift
//  BList
//
//  Created by iOS TL on 20/05/22.
//

import UIKit
import IBAnimatable

struct EmergencyContactModel {
    let name: String
    let phone: String
    let email: String
}

class FeaturesChooseOptionVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet var autoCheckInBtns           : [UIButton]!
    @IBOutlet var manualCheckInBtns         : [UIButton]!
    @IBOutlet var expAutoTrackBtns          : [UIButton]!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var authorizedPeopleTV   : UITableView!
    @IBOutlet weak var authorizedtblHeight  : NSLayoutConstraint!
    @IBOutlet weak var tableHeight          : NSLayoutConstraint!
    @IBOutlet weak var usersSV              : UIStackView!
    @IBOutlet weak var infoBtn              : UIButton!
    @IBOutlet weak var autoTrackDesc        : UILabel!
    @IBOutlet weak var btn_code             : UIButton!
    @IBOutlet weak var nameTF: AnimatedBindingText!{
        didSet{
            nameTF.bind { [weak self] in
                self?.userVM.name.value = $0
            }
        }
    }
    
    @IBOutlet weak var phoneTF: AnimatedBindingText!{
        didSet{
            phoneTF.bind { [weak self] in
                self?.userVM.phone.value = $0
            }
        }
    }
    
    @IBOutlet weak var emailIdTF: AnimatedBindingText!{
        didSet{
            emailIdTF.bind { [weak self] in
                self?.userVM.emailId.value = $0
            }
        }
    }
    
    @IBOutlet weak var searchField: AnimatedBindingText!{
        didSet{
            searchField.bind { [weak self] in
                self?.userVM.keyword.value = $0
            }
        }
    }
    @IBOutlet weak var contactTblView                   : UITableView!
    @IBOutlet weak var contactTblViewHeightConst        : NSLayoutConstraint!
    var userVM: UserViewModel!
    var bookingId = ""
    var expId = ""
    var emergencyUsers = [EmergencyContactModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userVM = UserViewModel(type: .GPSCheck)
        self.showInfoOnUI()
        tableHeight.constant = tableView.getTableHeight()
        userVM.searchUsers()
        userVM.didFinishFetch = {[weak self](_) in
            guard let self = self else {return}
            
            if (AppSettings.UserInfo?.user_list ?? "") != "" {
                let users = AppSettings.UserInfo?.user_list ?? ""
                let userArr = users.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
                let selectedUsers = self.userVM.searchedUsers.filter { usr in
                    return userArr.contains(where: {$0 == (usr.id ?? "")})
                }
                self.userVM.selectedUsers = selectedUsers
            }
            
            let tblHeight = self.tableView.getTableHeight()
            self.tableHeight.constant = tblHeight > 300 ? 300 : tblHeight
            
            self.authorizedPeopleTV.reloadData()
            let tblHeight1 = self.authorizedPeopleTV.contentSize.height
            self.authorizedtblHeight.constant = tblHeight1 > 300 ? 300 : tblHeight1
            
        }
        searchField.addTarget(self, action: #selector(searchAction(_:)), for: .editingChanged)
        infoBtn.addTarget(self, action: #selector(infoBtnAction(_:)), for: .touchUpInside)
        
        self.reloadEmergencyTable()
    }
    
    func showInfoOnUI() {
        let checkInBtn = UIButton()
        checkInBtn.tag = (AppSettings.UserInfo?.autoCheckin ?? "0") == "1" ? 1 : 0
        autoCheckInBtnAction(checkInBtn)
        
        let manualCheckInBtn = UIButton()
        manualCheckInBtn.tag = (AppSettings.UserInfo?.manualCheckin ?? "0") == "1" ? 1 : 0
        manualCheckInBtnAction(manualCheckInBtn)
        
        let autoTrackBtn = UIButton()
        autoTrackBtn.tag = (AppSettings.UserInfo?.autoTrack ?? "0") == "1" ? 1 : 0
        autoTrackBtnAction(autoTrackBtn)
        
        
        if let emergency = AppSettings.UserInfo?.emergency, emergency != "" {
            var emergencyModelArr = [EmergencyContactModel]()
            
            do {
                if let data = emergency.data(using: .utf8) {
                    let emergencyDictArr = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] ?? [[:]]
                    for each in emergencyDictArr {
                        emergencyModelArr.append(EmergencyContactModel(name: each["emergency_name"] as? String ?? "",
                                                                       phone: each["emergency_phone"] as? String ?? "",
                                                                       email: each["emergency_email"] as? String ?? ""))
                    }
                }
            } catch {
                print(error)
            }
            emergencyUsers = emergencyModelArr
            self.reloadEmergencyTable()
        }
        
        
//        nameTF.text = AppSettings.UserInfo?.emergency_name
//        phoneTF.text = AppSettings.UserInfo?.emergency_phone
//        emailIdTF.text = AppSettings.UserInfo?.emergency_email
//
//        userVM.name.value = AppSettings.UserInfo?.emergency_name ?? ""
//        userVM.phone.value = AppSettings.UserInfo?.emergency_phone ?? ""
//        userVM.emailId.value = AppSettings.UserInfo?.emergency_email ?? ""
        
//        self.emergencyUsers.append(EmergencyContactModel(name: AppSettings.UserInfo?.emergency_name ?? "",
//                                                         phone: AppSettings.UserInfo?.emergency_phone ?? "",
//                                                         email: AppSettings.UserInfo?.emergency_email ?? ""))
        self.reloadEmergencyTable()
    }
    
    @objc func infoBtnAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        autoTrackDesc.isHidden = !sender.isSelected
    }
    
    @objc func searchAction(_ sender:UITextField) {
        userVM.searchUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tblHeight = tableView.contentSize.height
        let tblHeight1 = authorizedPeopleTV.contentSize.height
        self.tableHeight.constant = tblHeight > 300 ? 300 : tblHeight
        self.authorizedtblHeight.constant = tblHeight1 > 300 ? 300 : tblHeight1
    }
    
    func reloadEmergencyTable() {
        self.contactTblView.reloadData {
            self.contactTblViewHeightConst.constant = CGFloat(self.emergencyUsers.count * 100)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func autoCheckInBtnAction(_ sender:UIButton){
        if userVM.manualCheckIn == 1 && sender.tag == 1 {
            showErrorMessages(message: "Disable manual check in to enable auto check in")
        } else {
            userVM.autoCheckIn = sender.tag
            DispatchQueue.main.async {
                for btn in self.autoCheckInBtns{
                    if sender.tag == btn.tag{
                        btn.backgroundColor = UIColor(named: "AppOrange")
                        btn.setTitleColor(.white, for: .normal)
                    }
                    else{
                        btn.backgroundColor = UIColor(named: "#EFF0F1")
                        btn.setTitleColor(UIColor(named: "#190000"), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func codeSelectionAction(_ sender : UIButton){
        let  listVC = UIStoryboard.loadCountryListTable()
        listVC.countryID = {[weak self] (countryName,code,id) in
            guard  let self = self else {
                return
            }
            self.btn_code.setTitle("+\(code)", for: .normal)
            self.userVM.phoneCode = code
        }
        self.present(listVC, animated: true, completion: nil)
    }
    @IBAction func manualCheckInBtnAction(_ sender:UIButton) {
        if userVM.autoCheckIn == 1 && sender.tag == 1 {
            showErrorMessages(message: "Disable auto check in to enable manual check in")
        } else {
            userVM.manualCheckIn = sender.tag
            for btn in manualCheckInBtns {
                if sender.tag == btn.tag {
                    btn.backgroundColor = UIColor(named: "AppOrange")
                    btn.setTitleColor(.white, for: .normal)
                } else {
                    btn.backgroundColor = UIColor(named: "#EFF0F1")
                    btn.setTitleColor(UIColor(named: "#190000"), for: .normal)
                }
            }
        }
        
    }
    
    @IBAction func autoTrackBtnAction(_ sender:UIButton){
        userVM.autoTrack = sender.tag
        for btn in expAutoTrackBtns{
            if sender.tag == btn.tag{
                btn.backgroundColor = UIColor(named: "AppOrange")
                btn.setTitleColor(.white, for: .normal)
                
            }
            else{
                btn.backgroundColor = UIColor(named: "#EFF0F1")
                btn.setTitleColor(UIColor(named: "#190000"), for: .normal)
            }
        }
        usersSV.isHidden = sender.currentTitle != "On"
        searchField.isHidden = sender.currentTitle != "On"
    }
    
    @IBAction func trackUsers(_ sender:UIButton) {
        let vc = UIStoryboard.loadMapVC()
        vc.userVM = userVM
        vc.expID = expId
        vc.screenType = .trackedUsers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doneBtnAction(_ sender:UIButton){
        userVM.gpsCheck(bookingId: bookingId, emergency: emergencyUsers)
        userVM.didFinishFetch = { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addContactAction(_ sender:UIButton){
        if nameTF.text!.isEmptyOrWhitespace() {
            self.showErrorMessages(message: "Please enter emergency name")
            return
        } else if phoneTF.text!.isEmptyOrWhitespace() {
            self.showErrorMessages(message: "Please enter emergency phone number")
            return
        } else if emailIdTF.text!.isEmptyOrWhitespace() {
            self.showErrorMessages(message: "Please enter emergency email address")
            return
        }
        let user = EmergencyContactModel(name: nameTF.text!, phone: phoneTF.text!, email: emailIdTF.text!)
        emergencyUsers.append(user)
        self.reloadEmergencyTable()
        
        nameTF.text = ""
        emailIdTF.text = ""
        phoneTF.text = ""
    }
}

//MARK: - TV DELEGATE & DATASOURCE METHODS
extension FeaturesChooseOptionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == authorizedPeopleTV {
            return userVM.selectedUsers.count
        } else if tableView == contactTblView {
            return emergencyUsers.count
        } else {
            return userVM.searchedUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == authorizedPeopleTV {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorizedPeopleCell", for: indexPath) as? AuthorizedPeopleCell else {return .init()}
            cell.configureCell(with: userVM.selectedUsers[indexPath.row])
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
            return cell
        } else if tableView == contactTblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyContactTableCell", for: indexPath) as? EmergencyContactTableCell else {return .init()}
            cell.configure(data: emergencyUsers[indexPath.row])
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersCell else{return .init()}
            cell.userVM = userVM
            cell.configureCell(with: userVM.searchedUsers[indexPath.row])
            return cell
        }
       
    }
    @objc func cancelBtnAction(_ sender: UIButton) {
        
        if let index = self.userVM.selectedUserIds.firstIndex(where: { userId in
            userId == self.userVM.selectedUsers[sender.tag].id ?? ""
        }) {
            self.userVM.selectedUserIds.remove(at: index)
        }
        self.userVM.selectedUsers.remove(at: sender.tag)
        DispatchQueue.main.async {
            self.authorizedtblHeight.constant = self.authorizedPeopleTV.getTableHeight()
            self.tableView.reloadData()
        }
        // Cancel Action
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != authorizedPeopleTV {
            let data = self.userVM.searchedUsers[indexPath.row]

           if !self.userVM.selectedUsers.contains(data) {
               self.userVM.selectedUsers.append(data)
            }
//            if let index = self.userVM.selectedUserIds.firstIndex(where: { (abc) -> Bool in
//                return abc == data.id ?? ""
//            }){
//                self.userVM.selectedUserIds.remove(at: index)
//            } else {
//                self.userVM.selectedUserIds.append(data.id ?? "")
//            }
            if !self.userVM.selectedUserIds.contains(data.id ?? "") {
                self.userVM.selectedUserIds.append(data.id ?? "")
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                self.authorizedtblHeight.constant = self.authorizedPeopleTV.getTableHeight()
            }

        }
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
        emergencyUsers.remove(at: sender.tag)
        self.reloadEmergencyTable()
    }
}

class UsersCell: AnimatableTableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    weak var userVM: UserViewModel!
    func configureCell(with data: GetUsersResponseModel.Users?) {
        userName.text = data?.name ?? ""
        userImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.profileImg ?? ""))
        if userVM.selectedUserIds.contains(where: {$0 == data?.id ?? ""}) {
            userName.textColor = UIColor(named: K.Colors.orange)
            self.accessoryType = .checkmark
        } else {
            userName.textColor = UIColor(named: K.Colors._676A71)
            self.accessoryType = .none
        }
    }
}
 
class AuthorizedPeopleCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    func configureCell(with data: GetUsersResponseModel.Users?) {
        userName.text = data?.name ?? ""
        userImg.setImage(link: BaseURLs.userImgURL.rawValue + (data?.profileImg ?? ""))
        
    }
}



class EmergencyContactTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    func configure(data: EmergencyContactModel) {
        nameLbl.text = data.name
        emailLbl.text = data.email
        phoneLbl.text = data.phone
    }
}
