//
//  ReviewsListVC.swift
//  BList
//
//  Created by iOS Team on 12/05/22.
//

import UIKit
import FloatRatingView
class UReviewsListVC: BaseClassVC {

    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    weak var authVM: AuthViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: authVM)
        authVM.getReviews()
        authVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension UReviewsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authVM.reviewedExps?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableCell", for: indexPath) as! ReviewTableCell
        cell.configureCell(with: authVM.reviewedExps?[indexPath.row])
        cell.giveRatingBtn.tag = indexPath.row
        cell.giveRatingBtn.addTarget(self, action: #selector(openGiveRating(btn:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func openGiveRating(btn: UIButton) {
        let vc = UIStoryboard.loadUGiveRatingVC()
        vc.authVM = authVM
        vc.authVM.expId = authVM.reviewedExps?[btn.tag].experienceID ?? ""
        vc.authVM.bookingId = authVM.reviewedExps?[btn.tag].bookingID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class ReviewTableCell: UITableViewCell {
    @IBOutlet weak var expImg           : UIImageView!
    @IBOutlet weak var expName          : UILabel!
    @IBOutlet weak var expDescription   : UILabel!
    @IBOutlet weak var amount           : UILabel!
    @IBOutlet weak var creatorName      : UILabel!
    @IBOutlet weak var creatorImg       : UIImageView!
    @IBOutlet weak var giveRatingBtn    : UIButton!
    @IBOutlet weak var completedBtn     : UIButton!
    @IBOutlet weak var dateLbl          : UILabel!
    @IBOutlet weak var ratingView       : FloatRatingView!{
        didSet {
            ratingView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var ratingViewCont   : UIView!
    
    func configureCell(with data: GetReviewsResponseModel.ExperienceDetails?) {
        expName.text = data?.experienceName ?? ""
        amount.text = "$\(data?.minGuestAmount ?? "")"
        expImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.images?.components(separatedBy: ",").first ?? ""))
        ratingViewCont.isHidden = data?.isRating ?? "" == "0"
        ratingView.rating = Double(data?.overallRating ?? "") ?? 0.0
        giveRatingBtn.isHidden = data?.isRating == "1"
        dateLbl.text = BList.convert(text: data?.bookingDate ?? "", dataType: .dic_arr).dic_arr?.first?["date"] as? String
        expDescription.text = data?.expDescribe ?? ""
        creatorName.text = data?.creatorName ?? ""
        creatorImg.setImage(link: data?.categoryImage ?? "")
    }
    
}
