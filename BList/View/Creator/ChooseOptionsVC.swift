//
//  ChooseOptionsVC.swift
//  BList
//
//  Created by admin on 25/05/22.
//

import UIKit
protocol active_deactiveDelegate:AnyObject{
    func acctive_Deactive(_ experience:String,status:String)
    func deleteExperience()
}
struct Option{
    var optionName: String
    var optionImg: String
    var selection: Bool
}
class ChooseOptionsVC: BaseClassVC{
    
    // MARK: - OUTLETS
    @IBOutlet weak var viewPopUp    : UIView!
    @IBOutlet weak var myTable      : UITableView!
    @IBOutlet weak var tableHeight  : NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var experience :Experience?
    var options_arr:[Option] = options
    weak var delegate:active_deactiveDelegate?
    var callBack:((_ selectedOption: Option_Enum)->())?
    // MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        if experience?.status ?? "" == "0"{
            options_arr[1].optionName = "Deactivate"
            options_arr[1].optionImg = "close_btn"
            options_arr.append(Option(optionName: "Delete", optionImg: "delete", selection: false))
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTable.layoutIfNeeded()
        tableHeight.constant = myTable.contentSize.height
    }
    
}

//MARK: - TV DELEGATE & DATASOURCE METHODS
extension ChooseOptionsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionCell", for: indexPath) as? ChooseOptionCell else {return .init()}
        
        cell.configure(data: options_arr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            // Edit Experience
            
            self.dismiss(animated: false, completion: nil)
            self.callBack?(.Edit_Experience)
        }
        else if indexPath.row == 1{
            // Activate or Deactivate
            let message = self.experience?.status ?? "" == "1" ? "Activate" : "De-Activate"
            self.showAlertCompletionWithTwoOption(alertText: "", alertMessage: "Are you sure you want to \(message) your Experience") { flag in
                if flag{
                    self.dismiss(animated: false) {[weak self] in
                        guard let self = self else{return}
                        self.delegate?.acctive_Deactive(self.experience?.experienceID ?? "", status:self.experience?.status ?? "")
                    }
                }
            }
        }
        else if indexPath.row == 2{
            // Promote
            self.dismiss(animated: false)
            self.callBack?(.Promote)
        }
        else{
            // Delete
            self.showAlertCompletionWithTwoOption(alertText: "", alertMessage: "Are you sure you want to delete your Experience") { flag in
                if flag{
                    self.dismiss(animated: false) {[weak self] in
                        guard let self = self else{return}
                        self.delegate?.deleteExperience()
                    }
                }
            }
        }
    }
}

// MARK: - UITABLEVIEW CELL
class ChooseOptionCell: UITableViewCell{
    @IBOutlet weak var optionNameLbl: UILabel!
    @IBOutlet weak var optionImg    : UIImageView!
    func configure(data: Option){
        optionNameLbl.text = data.optionName
        optionImg.image = UIImage(named: "\(data.optionImg)")
    }
}
