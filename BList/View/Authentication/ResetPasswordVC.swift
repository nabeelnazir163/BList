//
//  ResetPasswordVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit

class ResetPasswordVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backAction(_ sender : UIButton){
        for view in self.navigationController?.viewControllers ?? []{
            if view.isKind(of: LoginVC.self){
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }

}
