//
//  CChoosePaymentVC.swift
//  BList
//
//  Created by admin on 27/05/22.
//

import UIKit

class CChoosePaymentVC: BaseClassVC{
    // MARK: - OUTLETS
    @IBOutlet weak var view_Pop: UIView!
    @IBOutlet weak var myTable: UITableView!
    
    // MARK: - PROPERTIES
    var selectedPaymentType:PaymentType = .card
    var selectedPaymentTypeClosure:((_ type: PaymentType)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - ACTIONS
    @IBAction func doneBtnAction(_ sender:UIButton){
        selectedPaymentTypeClosure?(selectedPaymentType)
        self.dismiss(animated: true)
    }
    
    
}
// MARK: - UITABLEVIEW DELEGATE & DATASOURCE METHODS
extension CChoosePaymentVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text  = paymentTypes[indexPath.row].rawValue
        cell.textLabel?.font = UIFont(name: "CerebriSans-Book", size: 16)
        cell.imageView?.image = UIImage(named: paymentTypes[indexPath.row].rawValue)
        if paymentTypes[indexPath.row].rawValue == selectedPaymentType.rawValue{
            cell.textLabel?.textColor = UIColor(hexString: "#F96A27")
            cell.accessoryType = .checkmark
        }
        else{
            cell.textLabel?.textColor = UIColor(hexString: "#676A71")
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaymentType = paymentTypes[indexPath.row]
        tableView.reloadData()
    }
}
