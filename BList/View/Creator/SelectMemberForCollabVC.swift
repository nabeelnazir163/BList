//
//  SelectMemberForCollabVC.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit

class SelectMemberForCollabVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var tbl_creator : UITableView!
    @IBOutlet weak var lbl_noData : UILabel!
    @IBOutlet weak var searchTF: UITextField!
    
    // MARK: - PROPERTIES
    weak var delegate:refreshDelegate?
    weak var viewModel : CreatorViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        searchTF.addTarget(self, action: #selector(searchMemberAction(_:)), for: .editingChanged)
        viewModel.allCreator_List()
        fetchData()
    }
    func fetchData(){
        viewModel.didFinishFetch = {[weak self] apiType in
            guard let self = self else{return}
            switch apiType{
            case .CreatorsList, .SearchCreator:
                self.lbl_noData.isHidden = self.viewModel.allCreatorList.count == 0 ? false : true
                if !self.viewModel.commissionEnteredList.isEmpty{
                    let creatorIds = self.viewModel.commissionEnteredList.map({$0.id})
                    for  i in self.viewModel.allCreatorList.enumerated(){
                        if creatorIds.contains(i.element.id){
                            if let creatorData = self.viewModel.commissionEnteredList.filter({$0.id == i.element.id}).first{
                                self.viewModel.allCreatorList[i.offset].commissionEntered = creatorData.commissionEntered
                                self.viewModel.allCreatorList[i.offset].selection = creatorData.selection
                            }
                        }
                    }
                }
                self.tbl_creator.reloadData()
            case .AddCreatorCommission:
                if !self.viewModel.users_collab.contains(self.viewModel.creatorId){
                    self.viewModel.users_collab.append(self.viewModel.creatorId)
                }
                if let index = self.viewModel.allCreatorList.firstIndex(where: {$0.id == self.viewModel.creatorId}){
                    self.viewModel.allCreatorList[index].commissionEntered = true
                    self.viewModel.allCreatorList[index].selection = true
                }
                self.tbl_creator.reloadData()
            default: break
            }
            
        }
    }
    @objc func searchMemberAction(_ sender:UITextField){
        viewModel.creator.value = sender.text ?? ""
        viewModel.searchCreator()
    }
    @IBAction func doneAction(_ sender : UIButton){
        if viewModel.users_collab.isEmpty{
            showErrorMessages(message: "Add commission for atleast one user")
        }
        else{
            self.dismiss(animated: false) {[weak self] in
                guard let self = self else{return}
                self.viewModel.filterCommissionEnteredList()
                self.delegate?.refresh()
            }
        }
    }
}
extension SelectMemberForCollabVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCreatorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMemberCell", for: indexPath) as? SelectMemberCell else{ return .init() }
        let data = viewModel.allCreatorList[indexPath.row]
        cell.configureCell(with: data)
        cell.txt_percentage.tag = indexPath.row
        cell.didEndEditAction = { [weak self] text in
            guard let self = self else{return}
            if !text.isEmpty{
                self.viewModel.creatorId = data.id ?? ""
                self.viewModel.commission = text
                self.viewModel.addCommission()
                self.viewModel.allCreatorList[indexPath.row].commission = text
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let creatorData = viewModel.allCreatorList[indexPath.row]
        if creatorData.commissionEntered{
            viewModel.allCreatorList[indexPath.row].selection.toggle()
            if viewModel.allCreatorList[indexPath.row].selection == false{
                viewModel.users_collab.removeAll { creatorId in
                    creatorId == creatorData.id
                }
            }
            else{
                viewModel.users_collab.append(creatorData.id ?? "")
            }
        }
        tbl_creator.reloadData()
    }
    
}
class SelectMemberCell:UITableViewCell{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_radio: UIButton!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var txt_percentage: AnimatedBindingText!{
        didSet{
            txt_percentage.delegate = self
        }
    }
    var didEndEditAction : ((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        txt_percentage.delegate = self
    }
    func configureCell(with data: CreatorData){
        txt_percentage.text = data.commissionEntered ? data.commission : ""
        lbl_title?.text  = data.name ?? ""
        img_user.setImage(link: data.image ?? "")
        btn_radio.setImage((data.selection && data.commissionEntered) ? UIImage.init(named: "checkedProfile") : UIImage.init(named: ""), for: .normal)
        btn_radio.backgroundColor = (data.selection && data.commissionEntered) ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.42) : .clear
    }
}
extension SelectMemberCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let value = Int(text) ?? 0
        return value <= 100 ? true : false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditAction?(textField.text!)
    }
}
