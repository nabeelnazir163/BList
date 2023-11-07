//
//  RequestSentPopUp.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit

class RequestSentPopUp: UIViewController {
    weak var delegate :DismissViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func dissmiss(_ sender : UIButton){
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.dismissView("")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
