//
//  AddNewExperienceVC.swift
//  BList
//
//  Created by admin on 17/05/22.
//

import UIKit

class AddNewExperienceVC: BaseClassVC{
    // MARK: - OUTLETS
    @IBOutlet weak var viewPopUp    : UIView!
    @IBOutlet weak var myTable      : UITableView!{
        didSet{
            myTable.delegate = self
            myTable.dataSource = self
        }
    }
    @IBOutlet weak var tableHeight  : NSLayoutConstraint!
    @IBOutlet weak var cancel       : UIButton!
    @IBOutlet weak var done         : UIButton!
    
    // MARK: - PROPERTIES
    weak var delegate : DismissViewDelegate?
    weak var creatorVM : CreatorViewModel!
    var closureWithData:(([String])->())?
    var options = [("Zoom",false), ("Facetime",false), ("Google Meet",false), ("Duo",false), ("Skype",false), ("Discord",false), ("Other",false)]
    
    // MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopUp.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let expDetails = creatorVM.expDetails{
            let onlineTypes = (expDetails.onlineType ?? "").components(separatedBy: ",")
            for onlineType in onlineTypes {
                if let index = options.firstIndex(where: { $0.0 == onlineType}){
                    options[index].1 = true
                }
            }
            myTable.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTable.layoutIfNeeded()
        let tblHeight = myTable.contentSize.height
        let screenHeight = UIScreen.main.bounds.height * 0.6
        tableHeight.constant = tblHeight > screenHeight ? screenHeight : tblHeight
    }
    // MARK: - ACTIONS
    @IBAction func actionDone(_ sender: UIButton) {
        self.dismiss(animated: false) {[weak self] in
            guard let self = self else{return}
            let data = self.options.filter{$0.1}.compactMap {$0.0}
            self.closureWithData?(data)
        }
    }
}
//MARK: - TV DELEGATE & DATASOURCE METHODS
extension AddNewExperienceVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text  = options[indexPath.row].0
        cell.imageView?.image = UIImage(named:options[indexPath.row].0)
        cell.textLabel?.font = UIFont(name: "Cabin-Medium", size: 17)
        cell.textLabel?.textColor = UIColor(hexString: "#190000")
        if indexPath.row == (options.count - 1){
            cell.accessoryType = .none
        }
        else{
            if  options[indexPath.row].1{
                cell.accessoryType = .checkmark
                
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        options[indexPath.row].1 = !options[indexPath.row].1
        tableView.reloadData()
    }
}
