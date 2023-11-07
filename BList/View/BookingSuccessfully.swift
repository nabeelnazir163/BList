//
//  BookingSuccessfully.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit

class BookingSuccessfully: UIViewController {
    weak var delegate : DismissViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func doneAction(_ sender : UIButton){
        weak var previousVC = self.presentingViewController as? UINavigationController
        self.dismiss(animated: false) {
            previousVC?.popToRootViewController(animated: true)
        }
    }

}
