//
//  CAnalyticsVC.swift
//  BList
//
//  Created by admin on 25/05/22.
//

import UIKit

class CAnalyticsVC: BaseClassVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Price2: UILabel!
    @IBOutlet weak var lbl_Price3: UILabel!
    @IBOutlet weak var myTable: UITableView!
    
    var ratings = [("Communication",("#F9AC27",0.4)),("Atmosphere",("#F9AC27",0.4)),("Accuracy",("#27DCF9",0.75)),("Value",("#27ACF9",0.4)),("Creativity",("#9027F9",0.3)),("Location",("#F9DD27",0.4)),("Presentation",("#F97B27",0.65)),("Uniqueness",("#27C7F9",0.43))]
    
    let cellSpacingHeight: CGFloat = 5
    var creatorVM: CreatorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTable.separatorStyle = .none
        let nibName = UINib(nibName: "ExperrienceHeader", bundle: nil)
        self.myTable.register(nibName, forHeaderFooterViewReuseIdentifier: "ExperrienceHeader")
        let string = "$22,128.34"
        let string2 = "$23,118.64"
        let string3 = "$25,108.64"
           let attributedString = NSMutableAttributedString(string: string)
        let attributedString2 = NSMutableAttributedString(string: string2)
        let attributedString3 = NSMutableAttributedString(string: string3)
           let firstAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(name: "Cabin-Medium", size: 23)!]
           let secondAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(name: "Cabin-Medium", size: 9)!]
           attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 7))
           attributedString.addAttributes(secondAttributes, range: NSRange(location: 7, length: 3))
        attributedString2.addAttributes(firstAttributes, range: NSRange(location: 0, length: 7))
        attributedString2.addAttributes(secondAttributes, range: NSRange(location: 7, length: 3))
        attributedString3.addAttributes(firstAttributes, range: NSRange(location: 0, length: 7))
        attributedString3.addAttributes(secondAttributes, range: NSRange(location: 7, length: 3))
           lbl_Price.attributedText = attributedString
        lbl_Price2.attributedText = attributedString2
        lbl_Price3.attributedText = attributedString3
        creatorVM = CreatorViewModel(type: .GetAnalytics)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: creatorVM)
        creatorVM.getAnalytics()
        creatorVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        else if section == 1 || section == 2 || section == 3{
            return 1
        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell") as? FirstCell else{
            return FirstCell() }
            return cell
        }
                                        
        else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell") as? SecondCell else{
            return SecondCell()
            }
            cell.view_Collection.reloadData()
            return cell
        }
                                        
        else if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell") as? ThirdCell else{
            return ThirdCell()
            }
            cell.view_Collection.reloadData {
                cell.nslayout_collectionHeight.constant = CGFloat(74*2)
            }
            return cell
        }
                                        
        else if indexPath.section == 3{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FourthCell") as? FourthCell else{
            return FourthCell()
            }
            return cell
        }
                                            
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FifthCell") as? FifthCell else{
            return FifthCell()
            }
            cell.lbl_Com.text = ratings[indexPath.row].0
            cell.prog_rating.tintColor = UIColor.init(hexString: ratings[indexPath.row].1.0)
            cell.prog_rating.setProgress(Float(ratings[indexPath.row].1.1), animated: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }
        else if indexPath.section == 1{
            return 190
        }
        else if indexPath.section == 2{
            return 150
        }
        else if indexPath.section == 3{
            return 77
        }
        else if indexPath.section == 4{
            return 55
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 4{
            return UIView()
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExperrienceHeader" ) as! ExperrienceHeader
            headerView.tintColor = .clear
            headerView.lbl_title.text = section == 1 ? "My Experiences" : (section == 2 ? "Demographic Data" : "Experience Ratings")
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 4 {
            return 0
        }
        return 35
    }
}

class FirstCell: UITableViewCell {
    @IBOutlet weak var lbl_XYZ: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    
}

class FourthCell: UITableViewCell {
    
}

class FifthCell: UITableViewCell {
    
    @IBOutlet weak var lbl_Com: UILabel!
    @IBOutlet weak var prog_rating: UIProgressView!
}
