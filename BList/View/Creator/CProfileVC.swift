//
//  ProfileVC.swift
//  BList
//
//  Created by PARAS on 09/05/22.
//

import UIKit
import IBAnimatable
class CProfileVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var unameLbl             : UILabel!
    @IBOutlet weak var nameLbl              : UILabel!
    @IBOutlet weak var tableHeight          : NSLayoutConstraint!
    @IBOutlet weak var listView             : UITableView!
    @IBOutlet weak var profileView          : AnimatableView!
    @IBOutlet weak var btn_identifyDocument : UIButton!
    @IBOutlet weak var btn_verifyNow        : UIButton!
    @IBOutlet weak var profileImg           : UIImageView!
    // MARK: - PROPERTIES
    var authVM : AuthViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        authVM = AuthViewModel.init(type: .SwitchToCreatorProfile)
        setUpVM(model: authVM)
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPersonalProfile(tap:))))
    }
    // MARK: - SELECTOR METHODS
    @objc func openPersonalProfile(tap: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "User", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "UPersonalProfileVC") as! UPersonalProfileVC
        vc.authVM = authVM
        vc.type = .Creator
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.reloadData()
        self.tableHeight.constant = CGFloat(ProfileModel.creatorData().count) * 60 + 20
        if AppSettings.UserInfo != nil {
            self.authVM.getProfile_Details()
            self.authVM.didFinishFetch = { [weak self] (ApiType) -> Void  in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if let user_Details = self.authVM.user_ProfileDetails?.data{
                        self.profileImg.setImage(link: BaseURLs.userImgURL.rawValue + (user_Details.profileImg ?? ""), placeholder: "place_holder")
                        if user_Details.role ?? "" == "2"{
                            self.nameLbl.text = "\(user_Details.firstName ?? "") \(user_Details.lastName ?? "")"
                            self.unameLbl.text = "@\(user_Details.firstName?.lowercased() ?? "")\(user_Details.lastName?.lowercased() ?? "")"
                            if user_Details.identityVerified == "1"{
                                self.btn_identifyDocument.setTitle("Verified Identity", for: .normal)
                                self.btn_identifyDocument.setImage(UIImage.init(named: "verify"), for: .normal)
                                self.btn_identifyDocument .setTitleColor(UIColor.init(hexString: "#00AF5E"), for: .normal)
                                self.btn_verifyNow.isHidden = true
                            }
                            else{
                                self.btn_identifyDocument.setTitle("Unverified Identity", for: .normal)
                                self.btn_identifyDocument.setImage(UIImage.init(named: "unverify"), for: .normal)
                                self.btn_identifyDocument .setTitleColor(UIColor.init(hexString: "#F9C127"), for: .normal)
                                self.btn_verifyNow.isHidden = false
                            }
                        }
                        else{
                            self.nameLbl.text = "Demo"
                            self.unameLbl.text = "@Demo"
                            self.btn_identifyDocument.setTitle("Unverified Identity", for: .normal)
                            self.btn_identifyDocument.setImage(UIImage.init(named: "unverify"), for: .normal)
                            self.btn_identifyDocument .setTitleColor(UIColor.init(hexString: "#F9C127"), for: .normal)
                            self.btn_verifyNow.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - IBACTIONS
    @IBAction func actionSwitchToUser(_ sender: Any) {
        authVM.switchToUserProfile()
        authVM.didFinishFetch = { _ in
            AppSettings.UserInfo?.role = "1"
            UIStoryboard.setTo(type: .user, vcName: "UTabBarVC")
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension CProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppSettings.UserInfo != nil{
            return ProfileModel.creatorData().count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsOptionsCell") as? SettingsOptionsCell else {return SettingsOptionsCell()}
        cell.configure(profile: ProfileModel.creatorData()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ProfileModel.creatorData()[indexPath.row].action {
        case .help:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "HelpVC") as? HelpVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .giveFeedback:
            let vc = UIStoryboard.loadUSendFeedbackVC()
            vc.authVM = authVM
                self.navigationController?.pushViewController(vc, animated: true)
        case .contactUs:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "ContactUs") as? ContactUs {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .paymentMethod:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "UPaymentMethodsVC") as? UPaymentMethodsVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .myBookings:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "MyBookingsVC") as? MyBookingsVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .Logout:
            self.authVM.logout()
            self.authVM.didFinishFetch = { [weak self] (type) -> Void in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    AppSettings.Token =  ""
                    AppSettings.UserInfo = nil
                    UIStoryboard.setTo(type: .user, vcName: "UTabBarVC")
                    guard let items = self.tabBarController?.tabBar.items else {return}
                    if AppSettings.UserInfo != nil {
                        items.last?.title = "Profile"
                    }else{
                        items.last?.title = "Login"
                    }
                }
            }
        default:
            break
        }
    }
}


class SettingsOptionsCell: UITableViewCell{
    @IBOutlet weak var optionImg:UIImageView!
    @IBOutlet weak var optionName:UILabel!
    @IBOutlet weak var notificationSwitch:UISwitch!
    @IBOutlet weak var optionArrow:UIButton!
    
    func configure(profile: ProfileModel) {
        notificationSwitch.isHidden = profile.action != .notifications
        optionArrow.isHidden = profile.action == .notifications
        optionImg.image = UIImage(named: profile.image)
        optionName.text = profile.name
        if profile.action != .Logout{
            optionName.textColor = UIColor(named:"#190000")
        }else{
            optionName.textColor = .red
        }
    }
}

extension CProfileVC:refreshDelegate{
    func refresh() {
        if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "FeaturesChooseOptionVC") as? FeaturesChooseOptionVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
