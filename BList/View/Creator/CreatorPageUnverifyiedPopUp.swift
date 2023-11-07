//
//  CreatorPageUnverifyiedPopUp.swift
//  BList
//
//  Created by iOS TL on 06/06/22.
//

import UIKit

class CreatorPageUnverifyiedPopUp: BaseClassVC {
    weak var delegate : DismissViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        AppSettings.verificationAppeared = true
    }
    @IBAction func doneAction(_ sender : UIButton){
        self.dismiss(animated:false) {[weak self] in
            guard let self = self else {return}
            self.delegate?.dismissView("Unverify")
        }
    }
    @IBAction func dismissBack(_ sender:UIButton){
        self.dismiss(animated:false) {[weak self] in
            guard let self = self else {return}
            self.delegate?.dismissView("back")
        }
    }

}
