//
//  SignUpVC.swift
//  BList

//
//  Created by iOS TL on 23/05/22.
//

import UIKit
import IBAnimatable

class SignUpVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var genderBtn: CustomRightAndLeftImageButton!
    @IBOutlet weak var phoneTxtField: SkyLabelTextField!{
        didSet { phoneTxtField.bind{[unowned self] in self.viewModel.phone.value = $0 } }
    }
    @IBOutlet weak var emailTxtField: SkyLabelImageTextField!{
        didSet { emailTxtField.bind{[unowned self] in self.viewModel.email.value = $0 } }
    }
    @IBOutlet weak var lnameTxtField: SkyLabelImageTextField!{
        didSet { lnameTxtField.bind{[unowned self] in self.viewModel.lname.value = $0 } }
    }
    @IBOutlet weak var fnameTxtField: SkyLabelImageTextField!{
        didSet { fnameTxtField.bind{[unowned self] in self.viewModel.fname.value = $0 } }
    }
    @IBOutlet weak var pwdTxtField: SkyLabelImageTextField!{
        didSet { pwdTxtField.bind{[unowned self] in self.viewModel.password.value = $0 } }
    }
    @IBOutlet weak var confirmPwdTxtField: SkyLabelImageTextField!{
        didSet { confirmPwdTxtField.bind{[unowned self] in self.viewModel.confirmPasswrd.value = $0 } }
    }
    @IBOutlet weak var pwdEyeBtn: AnimatableButton!
    @IBOutlet weak var confirmPwdEyeBtn: UIButton!
    
    @IBOutlet weak var btn_code: AnimatableButton!
    @IBOutlet weak var dobTxtField: SkyLabelImageTextField!
    var viewModel: AuthViewModel!
    var picker = PickerView()
    var isSelectedpwdBtn = false {
        didSet{
            if isSelectedpwdBtn {
                pwdEyeBtn.setImage(UIImage.HideIcon, for: .normal)
            } else {
                pwdEyeBtn.setImage(UIImage.EyeIcon, for: .normal)
            }
        }
    }
    var isSelectedCnfrmPwdBtn = false {
        didSet{
            if  isSelectedCnfrmPwdBtn {
                confirmPwdEyeBtn.setImage(UIImage.HideIcon, for: .normal)
            } else {
                confirmPwdEyeBtn.setImage(UIImage.EyeIcon, for: .normal)
            }
        }
    }
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel(type: .SignUp(type: .Email, userType: .User))
        setUpVM(model: viewModel)
        dobTxtField.textField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        if let datePicker = self.dobTxtField.textField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.dobTxtField.textField.text = dateFormatter.string(from: datePicker.date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.viewModel.dob.value = dateFormatter.string(from: datePicker.date)
        }
        self.dobTxtField.textField.resignFirstResponder()
     }
    
    
    // MARK: - IBACTIONS
    @IBAction func signUpBtnAction(_ sender: Any) {
        if viewModel.isValid{
            if let vc = UIStoryboard.storyboardType(type: .auth).instantiateViewController(withIdentifier: "SignUpPopUp") as? SignUpPopUp {
                vc.closureDidDone = {[weak self] (userType,creatorType) in
                    guard let self = self else{return}
                    self.viewModel.signUp(type: .Email, userType: userType, creator_type: creatorType)
                    self.viewModel.didFinishFetch = { [weak self] apiType in
                        guard let self = self else{return}
                        if let vc = UIStoryboard.storyboardType(type: .auth).instantiateViewController(withIdentifier: "OTPVerifyVC") as? OTPVerifyVC {
                            vc.userType = userType
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
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
    @IBAction func genderAction(_ sender: CustomRightAndLeftImageButton) {
        picker.showPicker(view: self.view, data: ["Male", "Female", "They/Them", "Other"])
        picker.closureDidSelect = { selectedText in
            sender.titleStr = selectedText
            sender.title.textColor = .black
            self.viewModel.gender.value = selectedText.lowercased()
        }
    }
    @IBAction func didTapPwdBtn(_ sender: Any) {
        isSelectedpwdBtn.toggle()
        pwdTxtField.isSecure.toggle()
    }
    
    @IBAction func didTapCnfrmPwdBtn(_ sender: Any) {
        isSelectedCnfrmPwdBtn.toggle()
        confirmPwdTxtField.isSecure.toggle()
    }
}
extension SignUpVC : refreshDelegate{
    func refresh() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        viewModel.signUp(type: .Email, userType: .User)
//        viewModel.didFinishFetch = { [weak self] (apiType) in
//            guard let self = self else{return}
//
//        }
    }
}
