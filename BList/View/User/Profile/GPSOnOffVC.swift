//
//  GPSOnOffVC.swift
//  BList
//
//  Created by admin on 19/05/22.
//

import UIKit
protocol refreshDelegate :AnyObject{
    func refresh()
}
class GPSOnOffVC: UIViewController {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn_Off: UIButton!
    @IBOutlet weak var btn_On: UIButton!
    weak var delegate :refreshDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backDismiss(_ sender : UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.refresh()
        }
    }
    @IBAction func offAction(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
