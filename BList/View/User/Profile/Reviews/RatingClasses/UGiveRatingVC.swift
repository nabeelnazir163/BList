//
//  UGiveRatingVC.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import UIKit
import GrowingTextView
import FloatRatingView
class UGiveRatingVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var ratingView: FloatRatingView! {
        didSet {
            ratingView.delegate = self
        }
    }
    @IBOutlet weak var reviewTxtView: GrowingTextView!
    
    weak var authVM: AuthViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.type = .floatRatings
        reviewTxtView.layer.cornerRadius = 15.0
        reviewTxtView.layer.borderColor = AppColor.appE6E6E6.cgColor
        reviewTxtView.layer.borderWidth = 1.0
        reviewTxtView.font = AppFont.cabinRegular.withSize(15.0)
        reviewTxtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
   // MARK: - IBACTIONS
    @IBAction func actionNext(_ sender: Any) {
        if let review = reviewTxtView.text, review.isEmptyOrWhitespace() {
            showErrorMessages(message: "Enter some review")
        } else {
            authVM.reviewMsg.value = reviewTxtView.text ?? ""
            let vc = UIStoryboard.loadGiveRatingVC()
            vc.delegate = self
            vc.authVM = authVM
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
    }
    
}
extension UGiveRatingVC: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        authVM.overallRating = String(format: "%.1f", rating)
        print("Overall rating --> \(authVM.overallRating)")
    }
}
extension UGiveRatingVC:DismissViewDelegate{
    func dismissView(_ type :String) {
        if type == "Success"{
            self.navigationController?.popViewController(animated: true)
        } else {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingSuccessfulVC") as! RatingSuccessfulVC
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
    }
    
    
}
