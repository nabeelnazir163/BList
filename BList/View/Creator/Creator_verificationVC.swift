//
//  Creator_verificationVC.swift
//  BList
//
//  Created by iOS TL on 09/06/22.
//

import UIKit

class Creator_verificationVC: UIViewController {
    weak var delegate : DismissViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func BackAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: false)
        self.delegate?.dismissView("back")
    }
    @IBAction func doneAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
