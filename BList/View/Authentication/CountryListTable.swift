//
//  CountryListTable.swift
//  BamigbeApp
//
//  Created by Apps on 01/02/21.
//  Copyright © 2021 iOS System. All rights reserved.
//

import UIKit
class CountryListTable: BaseClassVC {
    var countries: [String] = []
    var countryList = [CountiesWithPhoneModel]()
    @IBOutlet weak var countrytable:UITableView!{
        didSet{
            self.countrytable.delegate = self
            self.countrytable.dataSource = self
        }
    }
    @IBOutlet var searchBar: UISearchBar!
    var countryID : ((_ countryName:String,_ code:String,_ id:String) -> Void)?
    var filterdata = [CountiesWithPhoneModel]()
    var country_Code  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countrytable.separatorStyle = .none
        searchBar.delegate = self
        let data = self.getDataFormFile()
        if data.1 == ""{
            countryList = data.0
            filterdata = countryList
            self.countrytable.reloadData()
        }
    }
}

extension CountryListTable:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filterdata.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell else {
            return CountryCell()
        }
            cell.flag.isHidden = false
            cell.code.isHidden = false
            cell.countryNameLbl.textAlignment = .left
            cell.countryNameLbl.text = filterdata[indexPath.row].countryName
            cell.flag.image = UIImage.init(named: filterdata[indexPath.row].code ?? "")
            cell.code.text = "+\(filterdata[indexPath.row].dial_code ?? 0)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countryID?(filterdata[indexPath.row].countryName ?? "", "\(filterdata[indexPath.row].dial_code ?? 0)", "\(filterdata[indexPath.row].id ?? 0)")
        dismiss(animated: true, completion: nil)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.view.endEditing(true)
        self.filterdata = self.countryList
        self.countrytable.reloadData()
        self.searchBar.text = ""
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterdata = searchText.isEmpty ? countryList : countryList.filter { (($0.countryName ?? "").contains(searchText)) || (("\($0.dial_code ?? 0)").contains(searchText))}
        countrytable.reloadData()
    }
}
  
class CountryCell: UITableViewCell {
    @IBOutlet weak var countryNameLbl:UILabel!
    @IBOutlet weak var flag:UIImageView!
    @IBOutlet weak var code:UILabel!
}

