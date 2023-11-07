//
//  ExperiencesBasedOnCategoryVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 27/01/23.
//

import UIKit

class ExperiencesBasedOnCategoryVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var tbl_Experience:  UITableView!
    var locationName: String =  ""
    
    // MARK: - PROPERTIES
    weak var userVM : UserViewModel!
    var categoryDetails: Category?
    weak var parentVC: ExperienceTabVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ExperrienceHeader", bundle: nil)
        self.tbl_Experience.register(nibName, forHeaderFooterViewReuseIdentifier: "ExperrienceHeader")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        setUpVM(model: userVM)
        userVM.userHome()
        userVM.didFinishFetch = { [weak self] (apiType) in
            guard let self = self else {return}
            switch apiType{
            case .UserHome:
                self.tbl_Experience.reloadData()
            case .MakeFavourite, .MakeUnFavourite:
                if let newExperiences = self.userVM.homeData.filter({$0.name == "New Experiences"}).first{
                    var newExp = newExperiences
                    newExp.items = newExp.items!.map({ homeItem in
                        var homeItem = homeItem
                        if homeItem.expID ?? "" == self.userVM.fav_unfavExp?.experienceID ?? ""{
                            homeItem.favouriteStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                        }
                        return homeItem
                    })
                    if let index = self.userVM.homeData.firstIndex(where: { homeData in
                        homeData.name == newExp.name
                    }){
                        self.userVM.homeData[index] = newExp
                        self.tbl_Experience.reloadData()
                    }
                }
            default:
                break
            }
            
        }
    }
    @objc func searchTapAction(_ sender:UITextField){
        let vc = UIStoryboard.loadFilterResultsVC()
        vc.screenType = .search
        vc.userVM = userVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - ACTIONS
    @IBAction func mapAction(_ sender : UIButton){
        let vc = UIStoryboard.loadMapVC()
        vc.userVM = userVM
        vc.screenType = .multipleExp
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func filterAction(_ sender : UIButton){
        let vc = UIStoryboard.loadFilterVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.apiSuccess = {
            let vc = UIStoryboard.loadFilterResultsVC()
            vc.userVM = self.userVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        vc.viewModel = userVM
        self.present(vc, animated: true, completion: nil)
    }

}

// MARK: - TABLEVIEW DELEGATE & DATASOURCE METHODS
extension ExperiencesBasedOnCategoryVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return userVM.homeData.count + 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return UIView()
        }
        else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExperrienceHeader" ) as! ExperrienceHeader
            headerView.tintColor = .gray
            headerView.lbl_title.text = userVM.homeData[section - 1].name
            headerView.btn_seeAll.isHidden = (userVM.homeData[section - 1].items?.count ?? 0) == 0
            headerView.btn_seeAll.tag = section - 1
            headerView.btn_seeAll.addTarget(self, action: #selector(seeAllAction(_:)), for: .touchUpInside)
            return headerView
        }
    }
    @objc func seeAllAction(_ sender : UIButton){
        let vc = UIStoryboard.loadExperiencesListVC()
        vc.hidesBottomBarWhenPushed = true
        vc.userVM = userVM
        vc.expType = ExperienceType(rawValue: userVM.homeData[sender.tag].type ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 117
        }
        if indexPath.section == 1{
            return 275
        }
        if indexPath.section == 2{
            return 275
        }
        return UITableView.automaticDimension
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
                return .init()
            }
            cell.configure(data: categoryDetails)
            cell.searchField.addTarget(self, action: #selector(searchTapAction(_:)), for: .editingDidBegin)
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell") as? ExperienceCell else{
                return ExperienceCell()
            }
            cell.itemIndex = indexPath.section
            cell.experienceBasedVC = self
            cell.userVM = userVM
            let items = userVM.homeData[indexPath.section - 1].items ?? []
            cell.noDataLbl.isHidden = items.count > 0
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.collection_Experience.reloadData()
            if indexPath.section == 3 && items.count < 3{
                cell.layout_collection.constant = 275
            }
            else{
                cell.layout_collection.constant = (2.0 * 275)
            }
            cell.setData()
            return cell
        }
    }
    
}

class CategoryDetailCell: UITableViewCell{
    @IBOutlet weak var categoryName     : UILabel!
    @IBOutlet weak var categoryImg      : UIImageView!
    @IBOutlet weak var descriptionLbl   : UILabel!
    @IBOutlet weak var searchField      : UITextField!
    @IBOutlet weak var parentView       : UIView!
    func configure(data: Category?){
        categoryName.text = data?.name ?? ""
        categoryImg.setImage(link: data?.image ?? "")
        categoryImg.image = categoryImg.image?.withRenderingMode(.alwaysTemplate)
        categoryImg.tintColor = UIColor(named: "AppOrange")
        descriptionLbl.text = data?.description ?? ""
//        parentView.backgroundColor = UIColor(hexString: data?.color ?? "")
    }
}
