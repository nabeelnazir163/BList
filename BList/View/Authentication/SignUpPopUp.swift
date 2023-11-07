//
//  SignUpPopUp.swift
//  BList
//
//  Created by iOS TL on 06/06/22.
//

import UIKit
import IBAnimatable

class SignUpPopUp: BaseClassVC {

    @IBOutlet var userCreatorViews: [AnimatableView]!
    @IBOutlet var individualVenueBtns: [UIButton]!
    @IBOutlet weak var userBtn: CustomRightAndLeftImageButton!
    @IBOutlet weak var creatorBtn: CustomRightAndLeftImageButton!
    var closureDidDone: ((_ userType:UserType,_ creator_type:CreatorType) -> ())?
    var userType = UserType.User
    var creator = CreatorType.Individual
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(updateUIAfterDelay), with: nil, afterDelay: 0.1)
    }
    @objc func updateUIAfterDelay() {
        let btn = CustomRightAndLeftImageButton()
        btn.tag = 0
        actionUserCreator(btn)
        
        individualVenueBtns.forEach({$0.isHidden = true})
    }
    @IBAction func doneAction(_ sender:UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.closureDidDone?(self.userType,self.creator)
        }
    }
    @IBAction func cancelAction(_ sender:UIButton){
        self.dismiss(animated: false)
    }
    @IBAction func actionUserCreator(_ sender: CustomRightAndLeftImageButton) {
        userBtn.rightImg.isHidden = true
        creatorBtn.rightImg.isHidden = true
        userCreatorViews.forEach({$0.borderColor = AppColor.appECECEC})
        if sender.tag == 0 {
            userType = .User
            userBtn.rightImg.isHidden = false
            individualVenueBtns.forEach({$0.isHidden = true})
        } else {
            userType = .Creator
            creatorBtn.rightImg.isHidden = false
            individualVenueBtns.forEach({$0.isHidden = false})
        }
        userCreatorViews[sender.tag].borderColor = AppColor.orange
    }
    @IBAction func actionIndividualVenue(_ sender: UIButton) {
        creator = sender.currentTitle == "Venue" ? .Venue : .Individual
        individualVenueBtns.forEach({$0.setImage(UIImage(named: "radio_button"), for: .normal)})
        individualVenueBtns[sender.tag].setImage(UIImage(named: "radio_active"), for: .normal)
    }
}
