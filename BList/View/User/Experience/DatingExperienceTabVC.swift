//
//  DatingExperienceTabVC.swift
//  BList
//
//  Created by iOS TL on 16/05/22.
//

import UIKit

class DatingExperienceTabVC: UIViewController {
    @IBOutlet weak var tbl_Experience:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ExperrienceHeader", bundle: nil)
        self.tbl_Experience.register(nibName, forHeaderFooterViewReuseIdentifier: "ExperrienceHeader")
    }
}
extension DatingExperienceTabVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return UIView.init()
        }
        else{
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExperrienceHeader" ) as! ExperrienceHeader
        headerView.tintColor = .clear
        headerView.lbl_title.text = section == 1 ? "Blist Featured" : (section == 2 ? "Top Experiences" : "Newly Created Experiences")
            headerView.btn_seeAll.isHidden = true
        return headerView
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 114
        }
        if indexPath.section == 1{
            return 210
        }
        if indexPath.section == 2{
            return 114
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else{
                return SearchCell()
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell") as? ExperienceCell else{
                return ExperienceCell()
            }
            cell.itemIndex = indexPath.section
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.collection_Experience.reloadData()
            cell.layout_collection.constant = (2.0 * 174.0)
            cell.setData()
            return cell
        }
    }
}

