//
//  OTPVerifyVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit

class OTPVerifyVC: BaseClassVC {
    @IBOutlet weak var otpView: VPMOTPView!
    var userType = UserType.User
    var viewModel : AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel.init(type: .Otp)
        setUpVM(model: viewModel)
        viewModel.modelType =  .Otp
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBorderColor = UIColor.init(hexString: "#FBFBFB")
        otpView.cursorColor = UIColor.black
        otpView.delegate = self
        otpView.shouldAllowIntermediateEditing = false
        otpView.initializeUI()
    }
    @IBAction func sumitAction(_ sender: Any) {
        if viewModel.isValid{
            viewModel.otpVerification()
            viewModel.didFinishFetch = {[weak self] apiType in
                guard let self = self else{return}
                if self.userType == .User{
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else{
                    UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
                }
//                for view in self.navigationController?.viewControllers ?? []{
//                    if view.isKind(of: LoginVC.self){
//                        self.navigationController?.popToViewController(view, animated: true)
//                    }
//                }
            }
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}

extension OTPVerifyVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        if !hasEntered{

        }
        return hasEntered
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        viewModel.otp.value = otpString

    }
}
