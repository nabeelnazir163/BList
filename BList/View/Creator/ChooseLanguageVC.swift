//
//  ChooseLanguageVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit

import UIKit

class ChooseLanguageVC: BaseClassVC {
    var options = ["English","Català","Español","Français","Italiano","日本語","한국어","Português"]
    weak var viewModel : CreatorViewModel!
    weak var delegate : changeModelType?
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.modelType = .ChooseLanguage
        // Do any additional setup after loading the view.
    }
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submit(_ sender : UIButton){
        if viewModel.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateExperienceFirst") as! CreateExperienceFirst
            vc.delegate = self
            vc.creatorVM = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
extension ChooseLanguageVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.lbl_title?.text  = options[indexPath.row]
        if viewModel.chooseLanguage.contains(options[indexPath.row]){
            cell.btn_radio.setImage(UIImage.init(named: "check_orange"), for: .normal)
            cell.lbl_title?.font = UIFont(name: "Cabin-SemiBold", size: 16)
            cell.lbl_title?.textColor = UIColor(hexString: "#252634")
        }else{
            cell.btn_radio.setImage(UIImage.init(named: "check_grey"), for: .normal)
            cell.lbl_title?.font = UIFont(name: "Cabin-Regular", size: 16)
            cell.lbl_title?.textColor = UIColor(hexString: "#676A71")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if viewModel.chooseLanguage.contains(options[indexPath.row]){
            viewModel.chooseLanguage.removeAll { abc in
                return options[indexPath.row] == abc
            }
        }
        else{
            viewModel.chooseLanguage.append(options[indexPath.row])
        }
        tableView.reloadData()
    }
}
extension ChooseLanguageVC:changeModelType{
    func changeModel() {
        viewModel.modelType = .ChooseLanguage
    }
}
class LanguageCell:UITableViewCell{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_radio: UIButton!
}
