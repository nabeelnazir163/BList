//
//  CInboxVC.swift
//  BList
//
//  Created by Rahul Chopra on 15/05/22.
//

import UIKit
import IBAnimatable

class CInboxVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var msgTblView: UITableView!
    @IBOutlet var msgNotificationBtns: [UIButton]!
    @IBOutlet weak var notificationTblView: UITableView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var activeLbl: UILabel!
    
    // MARK: - PROPERTIES
    var viewModel: ConnectSocketViewModel!
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    // MARK: - IBACTIONS
    @IBAction func actionMsgNotifications(_ sender: UIButton) {
        msgNotificationBtns.forEach({$0.setTitleColor(AppColor.app989595, for: .normal); $0.titleLabel?.font = AppFont.cabinRegular.withSize(21.0)})
        msgNotificationBtns[sender.tag].setTitleColor(AppColor.orange, for: .normal)
        msgNotificationBtns[sender.tag].titleLabel?.font = AppFont.cabinBold.withSize(23.0)
        
        activeLbl.frame.origin.x = msgNotificationBtns[sender.tag].frame.origin.x + 40
        
        msgView.isHidden = sender.tag == 1
        notificationView.isHidden = sender.tag == 0
    }
}


// MARK: - TABLE VIEW DATA SOURCE METHODS
extension CInboxVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == msgTblView ? 5 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == msgTblView {
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessagePhotoTableCell", for: indexPath) as! MessageTableCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as! MessageTableCell
                cell.countLbl.isHidden = indexPath.row != 1
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableCell", for: indexPath) as! NotificationsTableCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == msgTblView {
            let vc = UIStoryboard.loadChatVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class CMessageTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var photoCollectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var countLbl: AnimatableLabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if photoCollectionView != nil {
            photoCollectionView.dataSource = self
            photoCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 42)
    }
}


class CPhotoCollectionCell: UICollectionViewCell {
    
}


class CNotificationsTableCell: UITableViewCell {
    
}

