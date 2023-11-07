//
//  ChooseCreatorVC.swift
//  BList
//
//  Created by iOS TL on 06/06/22.
//

import UIKit
import IBAnimatable
protocol chooseCreatorTypeDelegate : AnyObject{
    func getType(_ type :String)
}
class ChooseCreatorVC: BaseClassVC {
    weak var delegate : chooseCreatorTypeDelegate?
    @IBOutlet weak var userBtn: CustomRightAndLeftImageButton!
    @IBOutlet weak var creatorBtn: CustomRightAndLeftImageButton!
    @IBOutlet var userCreatorViews: [AnimatableView]!
    var type = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(updateUIAfterDelay), with: nil, afterDelay: 0.1)
    }
    @objc func updateUIAfterDelay() {
        let btn = CustomRightAndLeftImageButton()
        btn.tag = 0
        actionIndividualVenue(btn)
    }
    //actionUserCreator(_ sender: CustomRightAndLeftImageButton)
    @IBAction func actionIndividualVenue(_ sender: CustomRightAndLeftImageButton) {
        if sender.title.text == nil {
            type = sender.currentTitle == "Venue" ? "2" : "1"
        } else {
            type = sender.title.text! == "Venue" ? "2" : "1"
        }
        
        userBtn.rightImg.isHidden = true
        creatorBtn.rightImg.isHidden = true
        userCreatorViews.forEach({$0.borderColor = AppColor.appECECEC})
        if sender.tag == 0 {
            userBtn.rightImg.isHidden = false
        } else {
            creatorBtn.rightImg.isHidden = false
        }
        userCreatorViews[sender.tag].borderColor = AppColor.orange
    }
    @IBAction func done(_ sender : UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.getType(self.type)
        }
    }
}
