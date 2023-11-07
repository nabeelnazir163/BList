//
//  USendFeedbackVC.swift
//  BList
//
//  Created by iOS Team on 12/05/22.
//

import UIKit
import GrowingTextView
import IBAnimatable

class USendFeedbackVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var txtView: GrowingTextView!
    @IBOutlet weak var txt_choose: UITextField!
    
    weak var authVM: AuthViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successView.alpha = 0.0
        txtView.font = AppFont.cabinRegular.withSize(15.0)
        txt_choose.addTarget(self, action: #selector(chooseAction(_:)), for: .allEvents)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: authVM)
    }
    @objc func chooseAction(_ textField : AnimatableTextField) {
        if !textField.isFirstResponder {
            return
        }
        textField.resignFirstResponder()
        let vc = UIStoryboard.loadChooseOptionPopUp()
        vc.authVM = authVM
        vc.callBack = { [weak self] in
            guard let self = self else {return}
            textField.text = self.authVM.options.filter({$0.isSelected == true}).first?.optionName
        }
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle  = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
   
    
    // MARK: - IBACTIONS
    @IBAction func actionSubmit(_ sender: Any) {
        if let feedbackOption = authVM.options.filter({$0.isSelected}).first?.optionName, let feedbackMsg = txtView.text, !feedbackMsg.isEmptyOrWhitespace() {
            authVM.feedbackOption = feedbackOption
            authVM.feedbackMsg = feedbackMsg
            authVM.shareFeedback()
            authVM.didFinishFetch = { [weak self](_) in
                guard let self = self else {return}
                UIView.animate(withDuration: 0.5) {
                    self.successView.alpha = 1.0
                } completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.successView.alpha = 0.0
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else if authVM.feedbackOption.isEmptyOrWhitespace(){
            showErrorMessages(message: "Select a feedback option")
        } else {
            showErrorMessages(message: "Enter feedback details")
        }
        
    }
}
