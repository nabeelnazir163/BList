//
//  RatingSuccessfulVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit

class RatingSuccessfulVC: UIViewController {
    weak var delegate : DismissViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func doneAction(_ sender : UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.dismissView("Success")
        }
    }
}
