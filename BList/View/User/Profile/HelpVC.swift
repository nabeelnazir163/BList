//
//  HelpVC.swift
//  BList
//
//  Created by iOS Team on 12/05/22.
//

import UIKit

class HelpVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet var roleBtns: [UIButton]!
    var helpModel = HelpModel.data()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(updateUIAfterDelay), with: nil, afterDelay: 1.0)
    }

    
    @objc func updateUIAfterDelay() {
        self.tblViewHeightConst.constant = self.tableView.contentSize.height + 20.0
        self.tableView.layoutIfNeeded()
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionBtns(_ sender: UIButton) {
        roleBtns.forEach({$0.setTitleColor(AppColor.app989595, for: .normal); $0.titleLabel?.font = AppFont.cabinRegular.withSize(17.0)})
        roleBtns[sender.tag].setTitleColor(AppColor.orange, for: .normal)
        roleBtns[sender.tag].titleLabel?.font = AppFont.cabinSemiBold.withSize(17.0)
        
        activeLbl.frame.origin.x = roleBtns[sender.tag].frame.origin.x + 16
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension HelpVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableCell", for: indexPath) as! HelpTableCell
        cell.configure(help: helpModel[indexPath.row])
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleCollapseExpand(tap:)))
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleCollapseExpand(tap:)))
        cell.answerLbl.addGestureRecognizer(labelTap)
        cell.dropdownImgView.addGestureRecognizer(imageTap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func handleCollapseExpand(tap: UITapGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: tap.location(in: tableView)) else {return}
        let isExpanded = helpModel[indexPath.row].isExpanded
        helpModel[indexPath.row].isExpanded = !isExpanded
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



class HelpTableCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var dropdownImgView: UIImageView!
    
    // MARK: - CORE METHODS
    func configure(help: HelpModel) {
        questionLbl.text = help.question
        answerLbl.text = help.isExpanded ? help.answer : ""
        dropdownImgView.transform = help.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        dropdownImgView.image = help.isExpanded ? UIImage(named: "down_arrow_orange") : UIImage(named: "down_arrow_gray")
        questionLbl.textColor = help.isExpanded ? AppColor.orange : AppColor.app190000
    }
}
