//
//  PostExperiencePopUp.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit

class PostExperiencePopUp: BaseClassVC {
    weak var delegate :DismissViewDelegate?
    weak var viewModel : CreatorViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.modelType = .PostExperience
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: viewModel)
    }
    
    @IBAction func submit(_ sender : UIButton){
        viewModel.addExperience()
        viewModel.didFinishFetch = {[weak self] apiType in
            guard let self = self else{return}
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestSentPopUp") as! RequestSentPopUp
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
    }
}
extension PostExperiencePopUp:DismissViewDelegate{
    func dismissView(_ type: String) {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            self.delegate?.dismissView("")
        }
    }
}
