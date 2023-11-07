//
//  WingWomenExperienceTabVC.swift
//  BList
//
//  Created by iOS TL on 17/05/22.
//

import UIKit

class WingWomenExperienceTabVC: UIViewController {

    @IBOutlet weak var tbl_wing : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ExperrienceHeader", bundle: nil)
        self.tbl_wing.register(nibName, forHeaderFooterViewReuseIdentifier: "ExperrienceHeader")
    }
}
extension WingWomenExperienceTabVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return UIView.init()
        }
        else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExperrienceHeader" ) as! ExperrienceHeader
            headerView.tintColor = .red
            headerView.lbl_title.text = section == 1 ? "Blist Featured Wing(wo)men" : "Wing(wo)men"
            headerView.btn_seeAll.isHidden = true
            return headerView
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 134
        }
        return 245
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell") as? CategoryDetailCell else{
                return CategoryDetailCell()
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WingWomenCell") as? WingWomenCell else{
                return WingWomenCell()
            }
            cell.parentsVc = self
            return cell
        }
    }
}
class WingWomenCell:UITableViewCell{
    var parentsVc:WingWomenExperienceTabVC?
    @IBOutlet weak var collection_wingWomen : UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension WingWomenCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WomenCell", for: indexPath) as? WomenCell else{
            return WomenCell()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "User", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "WingWomenDetailVC") as! WingWomenDetailVC
        self.parentsVc?.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 196, height: 100.0)
    }
    
}
class WomenCell : UICollectionViewCell{
    
}
