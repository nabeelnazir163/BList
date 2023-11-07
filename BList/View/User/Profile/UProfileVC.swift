//
//  UProfileVC.swift
//  BList
//
//  Created by Rahul Chopra on 10/05/22.
//

import UIKit
import IBAnimatable

class UProfileVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var unameLbl             : UILabel!
    @IBOutlet weak var nameLbl              : UILabel!
    @IBOutlet weak var tableHeight          : NSLayoutConstraint!
    @IBOutlet weak var profileView          : AnimatableView!
    @IBOutlet weak var table_View           : AnimatableView!
    @IBOutlet weak var listView             : UITableView!
    @IBOutlet weak var btn_identifyDocument : UIButton!
    @IBOutlet weak var btn_verifyNow        : UIButton!
    @IBOutlet weak var login_Btn            : UIView!
    @IBOutlet weak var switch_Btn           : UIButton!
    @IBOutlet weak var profileImg           : UIImageView!
    @IBOutlet weak var topBGView            : AnimatableView!
    @IBOutlet weak var accountLbl           : UILabel!
    @IBOutlet weak var topBGImage           : UIImageView!
    
    // MARK: - PROPERTIES
    var authVM:AuthViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authVM = AuthViewModel.init(type: .None)
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPersonalProfile(tap:))))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpVM(model: self.authVM)
        guard let items = self.tabBarController?.tabBar.items else {return}
        self.listView.reloadData()
        if AppSettings.UserInfo != nil {
            self.table_View.isHidden = false
            items.last?.title = "Profile"
            self.tableHeight.constant = CGFloat(ProfileModel.userData().count) * 60 + 20
        }else{
            self.table_View.isHidden = true
            self.tableHeight.constant = 0
            items.last?.title = "Login"
        }
        if AppSettings.UserInfo != nil {
            self.login_Btn.isHidden = true
            self.profileView.isHidden = false
            self.switch_Btn.isHidden = false
            self.authVM.getProfile_Details()
            self.authVM.didFinishFetch = { [weak self](apiType) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if let user_Details = self.authVM.user_ProfileDetails?.data{
                        self.profileImg.setImage(link: BaseURLs.userImgURL.rawValue + (user_Details.profileImg ?? ""), placeholder: "place_holder")
                        if user_Details.role ?? "" == "1"{
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
                        else {
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
        else{
            self.login_Btn.isHidden = false
            self.profileView.isHidden = true
            self.switch_Btn.isHidden = true
            
//            self.topBGImage.isHidden = false
//            self.topBGView.isHidden = false
//            self.accountLbl.textAlignment = .center
//            self.accountLbl.centerXAnchor.constraint(equalTo: topBGView.centerXAnchor).isActive = true
//            self.accountLbl.centerYAnchor.constraint(equalTo: topBGView.centerYAnchor).isActive = true
//
//            self.login_Btn.topAnchor.constraint(equalTo: topBGView.bottomAnchor, constant: 100).isActive = true
//            self.accountLbl.text = "Login"
//            self.accountLbl.font = UIFont(name: "Cabin-Bold", size: 25)
//            self.accountLbl.textColor = .white
        }
        
        
    }
    @IBAction func unverifyAccount(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IdentityVerificationVC") as! IdentityVerificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login_Btn(_ sender :UIButton){
         let vc = UIStoryboard.loadLoginVC()
            vc.screenAppear = .profile
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - SELECTOR METHODS
    @objc func openPersonalProfile(tap: UITapGestureRecognizer) {
        let vc = UIStoryboard.loadUPersonalProfileVC()
        vc.authVM = authVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - IBACTIONS
    @IBAction func actionSwitchToCreator(_ sender: Any) {
        if AppSettings.UserInfo != nil {
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "ChooseCreatorVC") as? ChooseCreatorVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        else{
            self.showErrorMessages(message: "Please perform login First")
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension UProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppSettings.UserInfo != nil{
            return ProfileModel.userData().count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsOptionsCell") as? SettingsOptionsCell else {return SettingsOptionsCell()}
        cell.configure(profile: ProfileModel.userData()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ProfileModel.userData()[indexPath.row].action {
        case .contactUs:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
            self.navigationController?.pushViewController(vc, animated: true)
        case .help:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .aboutUs:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .reviews:
            let vc = UIStoryboard.loadUReviewsListVC()
            vc.authVM = authVM
            self.navigationController?.pushViewController(vc, animated: true)
        case .giveFeedback:
            let vc = UIStoryboard.loadUSendFeedbackVC()
            vc.authVM = authVM
            self.navigationController?.pushViewController(vc, animated: true)
        case .paymentMethod:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UPaymentMethodsVC") as! UPaymentMethodsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .transaction:
            let vc = UIStoryboard.loadUTransactionListVC()
            vc.authVM = authVM
            self.navigationController?.pushViewController(vc, animated: true)
        case .myBookings:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .reliability:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "GPSOnOffVC") as? GPSOnOffVC {
                vc.delegate = self
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        case .Logout:
            self.authVM.logout()
            self.authVM.didFinishFetch = { [weak self] (type) -> Void in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    AppSettings.Token =  ""
                    AppSettings.UserInfo = nil
                    
                    if let tabBarController = self.tabBarController as? UTabBarVC{
                        tabBarController.updateTabBarItems()
                        tabBarController.selectedIndex = 0
                    }
                }
            }
        default:
            break
        }
    }
}
extension UProfileVC:refreshDelegate{
    func refresh() {
        if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "FeaturesChooseOptionVC") as? FeaturesChooseOptionVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension UProfileVC:DismissViewDelegate{
    func dismissView(_ type: String) {
        if type == "choose"{
            UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
        }
    }
}

extension UProfileVC:chooseCreatorTypeDelegate{
    func getType(_ type: String) {
        authVM.switchToCreatorProfile(type)
        authVM.didFinishFetch = { apiType in
            AppSettings.UserInfo?.role = "2"
            AppSettings.UserInfo?.creatorType = type
            UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
        }
    }
}
