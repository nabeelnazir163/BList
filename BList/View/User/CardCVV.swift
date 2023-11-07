//
//  CardCVV.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 22/03/23.
//

import UIKit

class CardCVV: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var cvvTF: UITextField!
    var callBack:((_ cvv: String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func bookNowAction(_ sender:UIButton) {
        if !(cvvTF.text ?? "").isEmptyOrWhitespace() {
            callBack?(cvvTF.text ?? "")
            self.dismiss(animated: false)
        } else {
            showErrorMessages(message: "Enter CVV")
        }
    }
}
