//
//  ChooseVC.swift
//  BList
//
//  Created by admin on 17/05/22.
//

import UIKit

class ChooseVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var countSelectionLbl: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var done: UIButton!
    // MARK: - PROPERTIES
    weak var creatorVM: CreatorViewModel!
    var callBack:(()->())?
    
    //MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopUp.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       countSelectionLbl.text = "\(creatorVM.categories.filter({$0.isSelected}).count) Selected"
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionDone(_ sender: UIButton) {
        self.callBack?()
        self.dismiss(animated: false, completion: nil)
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension ChooseVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorVM.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text  = creatorVM.categories[indexPath.row].name?.capitalized
        cell.accessoryType = creatorVM.categories[indexPath.row].isSelected ? .checkmark : .none
        cell.textLabel?.font = creatorVM.categories[indexPath.row].isSelected ? UIFont(name: "Cabin-SemiBold", size: 16) : UIFont(name: "Cabin-Regular", size: 16)
        cell.textLabel?.textColor = creatorVM.categories[indexPath.row].isSelected ? UIColor(hexString: "#F96A27") : UIColor(hexString: "#676A71")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if creatorVM.categories[indexPath.row].name
                    == "All" {
            creatorVM.categories = creatorVM.categories.map({ cat in
                var cat = cat
                cat.isSelected = false
                return cat
            })
            creatorVM.categories[indexPath.row].isSelected = true
            self.myTable.reloadData()
            self.countSelectionLbl.text = "All Selected"
        } else {
            var allCategoryIndex:Int? = nil
            if let index = creatorVM.categories.firstIndex(where: {$0.name == "All"}), creatorVM.categories[index].isSelected == true {
                creatorVM.categories[index].isSelected = false
                allCategoryIndex = index
            }
            self.creatorVM.categories[indexPath.row].isSelected.toggle()
            (allCategoryIndex == nil) ? myTable.reloadRows(at: [indexPath], with: .automatic) : myTable.reloadRows(at: [indexPath,IndexPath(row: allCategoryIndex ?? 0, section: 0)], with: .automatic)
            self.countSelectionLbl.text = "\(self.creatorVM.categories.filter({$0.isSelected}).count) Selected"
        }
        
    }
}
