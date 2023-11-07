//
//  IdentityVerificationVC.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit

class IdentityVerificationVC: BaseClassVC {
    @IBOutlet weak var view_upload: CustomDashedView!
    @IBOutlet weak var img_document: UIImageView!
    @IBOutlet weak var lbl_subHeading: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    var viewModel : AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel.init(type: .UploadDocument)
        setUpVM(model: viewModel)
        if AppSettings.UserInfo?.role == "2" && AppSettings.UserInfo?.creatorType == "2"{
            lbl_subHeading.text = "Upload your Business Licence to verify\nthe account"
            lbl_title.text = "Upload Business Licence"
        }

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(openCamera(_:)))
        tapGesture.numberOfTapsRequired = 1
        view_upload.addGestureRecognizer(tapGesture)
    }
    
    @objc func openCamera(_ sender : UITapGestureRecognizer){
        let share = CameraHandler.shared
        share.showActionSheet(vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            self.img_document.isHidden = false
            self.viewModel.document_image = img
            self.img_document.image = img
        }
    }
    @IBAction func SubmitAction(_ sender : UIButton){
        if AppSettings.UserInfo?.id == nil{
            showErrorMessages(message: "You have to login first")
        }
        else if viewModel.isValid{
            viewModel.uploadIdentityDocument()
            viewModel.didFinishFetch = { [weak self] apiType in
                guard let self = self else{return}
                self.showAlertCompletion(alertText: "", alertMessage: "Document has uploaded successfully") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
