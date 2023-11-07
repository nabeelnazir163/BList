//
//  ContactUs.swift
//  BList
//
//  Created by iOS Team on 11/05/22.
//

import UIKit
import GrowingTextView

class ContactUs: BaseClassVC {

    // MARK: - OUTLETS
    @IBOutlet weak var contactTblView: UITableView!
    @IBOutlet weak var msgTxtview: GrowingTextView!
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTxtview.font = AppFont.cabinRegular.withSize(15.0)
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionSend(_ sender: Any) {
        
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension ContactUs: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderContactTableCell", for: indexPath) as! ContactTableCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - CONTACT TABLE CELL
class ContactTableCell: UITableViewCell {
    
}
