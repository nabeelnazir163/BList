//
//  LoginVC.swift
//  BList
//
//  Created by iOS Team on 16/05/22.
//

import UIKit
import IBAnimatable
enum screenCome{
    case experience
    case profile
}
class LoginVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var phoneTxtField: SkyLabelTextField!{
        didSet { phoneTxtField.bind{[unowned self] in self.viewModel.phone.value = $0 } }
    }
    @IBOutlet weak var emailTxtField: SkyLabelImageTextField! {
        didSet { emailTxtField.bind{[unowned self] in self.viewModel.email.value = $0 } }
    }
    @IBOutlet weak var pwdTxtField: SkyLabelImageTextField! {
        didSet { pwdTxtField.bind{[unowned self] in self.viewModel.password.value = $0 } }
    }
    @IBOutlet weak var btn_code : UIButton!
    @IBOutlet var emailPhoneBtns: [UIButton]!
    @IBOutlet weak var pwdBtn: AnimatableButton!
    
    var viewModel: AuthViewModel!
    var screenAppear = screenCome.profile
    var user_Model:UserViewModel!
    var isSelectedpwdBtn = false {
        didSet{
            if isSelectedpwdBtn {
                pwdBtn.setImage(UIImage.HideIcon, for: .normal)
            } else {
                pwdBtn.setImage(UIImage.EyeIcon, for: .normal)
            }
        }
    }
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel(type: .SignIn(type: .Email))
        setUpVM(model: viewModel)
    }
    
    private func openBookDateVC(){
        switch screenAppear {
        case .experience:
            let storyboard = UIStoryboard.init(name: "Experience", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseAvailableDateVC") as! ChooseAvailableDateVC
            vc.viewModel = self.user_Model
            self.navigationController?.pushViewController(vc, animated: true)
        case .profile:
            self.navigationController?.popViewController(animated: true)
            if let tabBarController = self.navigationController?.viewControllers.last as? UTabBarVC{
                tabBarController.updateTabBarItems()
                tabBarController.selectedIndex = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.didFinishFetch = { [weak self] apiType in
            guard let self = self else{return}
            switch apiType {
            case .SignIn(type: .Email):
                if AppSettings.UserInfo?.role == "1"{
                    self.openBookDateVC()
                }
                else{
                    UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
                }
            case .SocialLogin(type: .Facebook), .SocialLogin(type: .Gmail), .SocialLogin(type: .AppleID), .SocialLogin(type: .Instagram):
                if AppSettings.UserInfo?.role == "1"{
                    self.openBookDateVC()
                }
                else{
                    UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
                }
            default: break
            }
        }
    }
    
    func signInFacebook(userType: UserType, creator_type: CreatorType) {
        FacebookIntegeration.basicInfoWithCompletionHandler(self) { [weak self](dataDictionary, error) in
            guard let self = self else {return}
            if dataDictionary != nil {
                FacebookIntegeration.logoutFromFacebook()
                self.viewModel.socialID = dataDictionary?["id"] as? String ?? ""
                self.viewModel.fname.value = dataDictionary?["first_name"] as? String ?? ""
                self.viewModel.lname.value = dataDictionary?["last_name"] as? String ?? ""
                self.viewModel.email.value = dataDictionary?["email"] as? String ?? ""
                self.viewModel.socialLogin(type: .Facebook, social_id: dataDictionary?["id"] as? String ?? "", userType: userType, creator_type: creator_type)
            }
        }
    }
    
    // MARK: - IBACTIONS
    @IBAction func codeSelectionAction(_ sender : UIButton){
        guard let  listVC = storyboard?.instantiateViewController(withIdentifier: "CountryListTable") as? CountryListTable else { return }
        listVC.countryID = {[weak self] (countryName,code,id) in
            guard  let self = self else {
                return
            }
            self.btn_code.setTitle("+\(code)", for: .normal)
            self.viewModel.phoneCode.value = code
        }
        self.present(listVC, animated: true, completion: nil)
    }
    
    @IBAction func actionEmailPhone(_ sender: UIButton) {
        emailPhoneBtns.forEach({$0.setTitleColor(AppColor.app2E2F41, for: .normal); $0.setImage(UIImage(named: "radio_button"), for: .normal)})
        emailPhoneBtns[sender.tag].setTitleColor(AppColor.orange, for: .normal)
        emailPhoneBtns[sender.tag].setImage(UIImage(named: "radio_active"), for: .normal)
        if sender.tag == 0{
            phoneStackView.isHidden = true
            emailTxtField.isHidden = false
            viewModel.isEmail = true
        }
        else{
            phoneStackView.isHidden = false
            emailTxtField.isHidden = true
            viewModel.isEmail = false
            
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        //        let storyboard = UIStoryboard.init(name: "Experience", bundle: Bundle.main)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseAvailableDateVC") as! ChooseAvailableDateVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if viewModel.isValid {
            viewModel.signIn(type: .Email, userType: .User)
            
        } else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
    @IBAction func forgetAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapPwdBtn(_ sender: Any) {
        isSelectedpwdBtn.toggle()
        pwdTxtField.isSecure.toggle()
    }
    
    @IBAction func actionSocialLogin(_ sender: UIButton) {
        if let vc = UIStoryboard.storyboardType(type: .auth).instantiateViewController(withIdentifier: "SignUpPopUp") as? SignUpPopUp {
            vc.closureDidDone = {[weak self] (userType,creatorType) in
                guard let self = self else{return}
                
                switch sender.tag {
                case 0:
                    // Facebook
                    self.signInFacebook(userType: userType, creator_type: creatorType)
                case 1:
                    // Google
                    GoogleLoginIntegration.shared.signInWith(presentingVC: self)
                    GoogleLoginIntegration.shared.closureDidGetUserDetails = { googleUser in
                        self.viewModel.socialID = googleUser.userID ?? ""
                        self.viewModel.fname.value = googleUser.profile?.givenName ?? ""
                        self.viewModel.lname.value = googleUser.profile?.familyName ?? ""
                        self.viewModel.email.value = googleUser.profile?.email ?? ""
                        self.viewModel.socialLogin(type: .Gmail, social_id: googleUser.userID ?? "", userType: userType, creator_type: creatorType)
                    }
                case 2:
                    // Apple
                    AppleLogin.shared.setUpAppleSignIn { user, error in
                        if error == nil {
                            self.viewModel.socialID = user?.socialId ?? ""
                            self.viewModel.fname.value = user?.firstName ?? ""
                            self.viewModel.lname.value = user?.lastName ?? ""
                            self.viewModel.email.value = user?.email ?? ""
                            self.viewModel.socialLogin(type: .AppleID, social_id: user?.socialId ?? "", userType: userType, creator_type: creatorType)
                        }
                    }
                case 3:
                    // Instagram
                    let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
                    webVC.modalPresentationStyle = .custom
                    self.present(webVC, animated:true)
                    
                default: break
                }
                
                /*self.viewModel.signUp(type: .Email, userType: userType, creator_type: creatorType)
                 self.viewModel.didFinishFetch = { [weak self] apiType in
                 guard let self = self else{return}
                 if let vc = UIStoryboard.storyboardType(type: .auth).instantiateViewController(withIdentifier: "OTPVerifyVC") as? OTPVerifyVC {
                 self.navigationController?.pushViewController(vc, animated: true)
                 }
                 }*/
            }
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}
