//
//  EmailSendVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit

class EmailSendVC: UIViewController {
    weak var delegate :DismissViewDelegate?
    var email = ""
    // MARK: - OUTLETS
    @IBOutlet weak var lbl_SuccessMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_SuccessMsg.text = "Code has been sent to your email \(email) for reset password"
    }
    @IBAction func dismissAction(_ sender: UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.dismissView("")
        }
    }
}
