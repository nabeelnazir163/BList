//
//  UTransactionListVC.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import UIKit

class UTransactionListVC: BaseClassVC {

    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    // MARK: - PROPERTIES
    weak var authVM: AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: authVM)
        authVM.getTransactions()
        authVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            self.noDataLbl.isHidden = self.authVM.transactions?.count ?? 0 != 0
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension UTransactionListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authVM.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableCell", for: indexPath) as? TransactionTableCell else {return .init()}
        cell.configureCell(with: authVM.transactions?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.loadUTransactionDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class TransactionTableCell: UITableViewCell {
    @IBOutlet weak var expImg: UIImageView!
    @IBOutlet weak var expName: UILabel!
    @IBOutlet weak var expPrice: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var transactionId: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    
    func configureCell(with data: GetTransactionsResponseModel.TransactionDetails?) {
        expName.text = data?.expName ?? ""
        expImg.setImage(link: data?.image ?? "")
        expPrice.text = "$\(data?.amount ?? "")"
        rating.text = "\(data?.averageRating ?? "0") (\(data?.totalRatingsCount ?? 0))"
        transactionId.text = data?.transactionID ?? ""
        
    }
}
