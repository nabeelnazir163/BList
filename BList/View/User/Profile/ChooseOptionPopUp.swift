//
//  TableVC.swift
//  BList
//
//  Created by admin on 16/05/22.
//

import UIKit

class ChooseOptionPopUp: BaseClassVC, UITableViewDelegate, UITableViewDataSource {
    // MARK:- Outlets
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var chooseOptionsLbl: UILabel!
    @IBOutlet weak var myTable: UITableView!
    var callBack: (()->())?
    // MARK:- Properties
    weak var authVM: AuthViewModel!
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authVM.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = authVM.options[indexPath.row]
        cell.textLabel?.text  = data.optionName
        cell.textLabel?.font = UIFont(name: "Cabin-Medium", size: 17)
        
        if data.isSelected {
            cell.textLabel?.textColor = UIColor(hexString: "#F96A27")
            cell.accessoryType = .checkmark
        }else{
            cell.textLabel?.textColor = UIColor(hexString: "#190000")
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        authVM.options = authVM.options.map({ option in
            var option = option
            option.isSelected = false
            return option
        })
        authVM.options[indexPath.row].isSelected.toggle()
        callBack?()
        self.dismiss(animated: true)
        
    }
    
}
