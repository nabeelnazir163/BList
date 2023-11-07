//
//  ForgotPasswordVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit

class ForgotPasswordVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var emailTxtField: SkyLabelImageTextField! {
        didSet { emailTxtField.bind{[unowned self] in self.viewModel.email.value = $0 } }
    }
    @IBOutlet weak var txt_phone: SkyLabelTextField! {
        didSet { txt_phone.bind{[unowned self] in self.viewModel.phone.value = $0 } }
    }
    @IBOutlet weak var btn_code : UIButton!
    var viewModel: AuthViewModel!
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel.init(type: .Forget)
        setUpVM(model: viewModel)
    }
    
    // MARK: - IBACTIONS
    @IBAction func forgetAction(_ sender: Any) {
        if viewModel.isValid {
            viewModel.forgot()
            viewModel.didFinishFetch = { apiType in
                switch apiType {
                case .Forget:
//                    self.showSuccessMessages(message: self.viewModel.commonApiModel?.message ?? "")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailSendVC") as! EmailSendVC
                    vc.delegate = self
                    vc.email = self.viewModel.email.value
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .custom
                    self.present(vc, animated:true, completion: nil)
                default: break
                }
            }
        } else {
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
}
extension ForgotPasswordVC:DismissViewDelegate{
    func dismissView(_ type: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
