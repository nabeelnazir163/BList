//
//  PrivacyPolicyVC.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit

class PrivacyPolicyVC: BaseClassVC {
    weak var creatorVM : CreatorViewModel!
    @IBOutlet var btns_check : [UIButton]!
    @IBOutlet weak var policyAgreementCheck: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        policyAgreementCheck.addTarget(self, action: #selector(checkBoxAction(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: creatorVM)
        creatorVM.modelType = .Policy
        if let expDetails = creatorVM.expDetails{
            btns_check.forEach { btn in
                btn.isSelected = btn.currentTitle == expDetails.isCancel
            }
            policyAgreementCheck.isSelected = expDetails.isAgree ?? "no" == "yes" ? true : false
        }
    }
    @IBAction func policyCancalation(_ sender : UIButton){
        btns_check.forEach { btn in
            if btn.tag == sender.tag{
                btn.isSelected = true
            }
            else{
                btn.isSelected = false
            }
        }
        creatorVM.isCancel.value = btns_check[sender.tag].currentTitle ?? ""
    }
    
    //7 days/ 3 days / 24 hrs / anytime
    @objc func checkBoxAction(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.setImage(UIImage.init(named: "check_orange"), for: .normal)
        }
        else{
            sender.setImage(UIImage.init(named: "check_grey"), for: .normal)
        }
        creatorVM.privacyPolicyAgreement.value =   sender.isSelected ? "yes" : "no"
    }
    @IBAction func submit(_ sender : UIButton){
        if creatorVM.isValid{
            if creatorVM.expDetails != nil{
                creatorVM.updateExperience()
                creatorVM.didFinishFetch = { _ in
                    for vc in (self.navigationController?.viewControllers ?? []) as Array{
                        if vc.isKind(of: CreatorExperienceTabVC.self){
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostExperiencePopUp") as! PostExperiencePopUp
                vc.viewModel = creatorVM
                vc.delegate = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                self.present(vc, animated:true, completion: nil)
            }
        }
        else {
            showErrorMessages(message: creatorVM.brokenRules.first?.message ?? "Try again")
        }
    }

}
extension PrivacyPolicyVC:DismissViewDelegate{
    func dismissView(_ type: String) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
