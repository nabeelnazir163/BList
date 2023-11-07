//
//  ChangeLocationVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 12/01/23.
//

import UIKit

class ChangeLocationVC: BaseClassVC {
// MARK: - OUTLETS
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var locations = [String]()
    var selectedIndex = 0{
        didSet{
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    var selectedLocationIndex:((_ index:Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenHeight = UIScreen.main.bounds.height
        let tblHeight = table.getTableHeight()
        let restrictedHeight = screenHeight * 0.7
        tableHeight.constant = tblHeight > (restrictedHeight) ? restrictedHeight : tblHeight
    }
    @IBAction func doneBtnTapAction(_ sender:UIButton){
        selectedLocationIndex?(selectedIndex)
        self.dismiss(animated: true)
    }
}
//MARK: - TV DELEGATE & DATASOURCE METHODS
extension ChangeLocationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row]
        cell.textLabel?.font = UIFont(name: "CerebriSans-Book", size: 16)
        cell.imageView?.image = indexPath.row == selectedIndex ? UIImage(named: "location_selected") : UIImage(named: "location_unselected")
       cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
}
