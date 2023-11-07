//
//  GiveRatingVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit
import FloatRatingView
import IBAnimatable
protocol DismissViewDelegate : NSObject{
    func dismissView(_ type : String)
}

class GiveRatingVC: BaseClassVC {
    weak var delegate :DismissViewDelegate?
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet var yes_noBtns: [AnimatableButton]!
    @IBOutlet var moneyBtns: [AnimatableButton]!
    @IBOutlet weak var tipAmountTF: AnimatedBindingText! {
        didSet {
            tipAmountTF.bind(callback: { [weak self] in
                self?.authVM.tipAmount.value = $0
            })
        }
    }
    @IBOutlet weak var amountSV: UIStackView!
    
    weak var authVM: AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeight.constant = myTable.getTableHeight()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authVM.modelType = .RateExperienceQualities
        setUpVM(model: authVM)
        authVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            self.dismiss(animated: false) {[weak self] in
                guard let self = self else{return}
                self.delegate?.dismissView("Rating")
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeight.constant = myTable.contentSize.height
    }
    @IBAction func postReview(_ sender: UIButton) {
        if authVM.isValid {
            authVM.giveRating()
        } else {
            showErrorMessages(message: authVM.brokenRules.first?.message ?? "")
        }
    }
    
    @IBAction func actionSkip(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func yes_noAction(_ sender:AnimatableButton) {
        for btn in yes_noBtns {
            btn.borderWidth = 0
            btn.borderColor = .white
        }
        sender.borderColor = UIColor(named: "AppOrange")
        sender.borderWidth = 1.5
        amountSV.isHidden = sender.tag == 1
        authVM.tipYes_No = sender.currentTitle ?? ""
    }
    @IBAction func moneyBtnAction(_ sender:AnimatableButton) {
        for btn in moneyBtns {
            btn.borderWidth = 0
            btn.borderColor = .white
        }
        sender.borderColor = UIColor(named: "AppOrange")
        sender.borderWidth = 1.5
        tipAmountTF.isHidden = sender.tag != 3
        tipAmountTF.borderWidth = sender.tag != 3 ? 0 : 1
        var amount = sender.currentTitle ?? ""
        amount.remove(at: amount.startIndex)
        authVM.tipAmount.value = (sender.tag != 3 ) ? amount : ""
    }
}
extension GiveRatingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return authVM.ratings.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyTableViewCell else {return .init()}
            cell.lbl_Main.text = authVM.ratings[indexPath.row].categoryName ?? ""
            cell.lbl_Star.text = authVM.ratings[indexPath.row].ratingValue + "star"
            cell.view_StarRating.tag = indexPath.row
            cell.parentVC = self
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
   //"Rating"
class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Main: UILabel!
    @IBOutlet weak var lbl_Star: UILabel!
    @IBOutlet weak var view_StarRating: FloatRatingView! {
        didSet {
            view_StarRating.delegate = self
        }
    }
    weak var parentVC: GiveRatingVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        view_StarRating.type = .floatRatings
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
}

extension MyTableViewCell: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let rateValue = String(format: "%.1f", rating)
        parentVC?.authVM.ratings[ratingView.tag].ratingValue = rateValue
        lbl_Star.text = rateValue + "star"
    }
}

struct RatingCategory {
    var categoryName: String?
    var ratingValue : String = "0.0"
}
