//
//  UPersonalProfileVC.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import UIKit
import SwiftUI
enum UserType:Int{
    case User = 1
    case Creator = 2
}
/*1=> Individual 2=> Venue*/
enum CreatorType:Int{
    case Individual = 1
    case Venue = 2
}
class UPersonalProfileVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var tbl_rating               : UITableView!
    @IBOutlet weak var tblHeight                : NSLayoutConstraint!
    @IBOutlet weak var collection_experience    : UICollectionView!
    @IBOutlet weak var stack_creator            : UIStackView!
    @IBOutlet weak var btn_creator              : UIButton!
    @IBOutlet weak var btn_user                 : UIButton!
    @IBOutlet weak var profileImg               : UIImageView!
    @IBOutlet weak var coverPhoto               : UIImageView!
    @IBOutlet weak var unameLbl                 : UILabel!
    @IBOutlet weak var nameLbl                  : UILabel!
    @IBOutlet weak var aboutMe                  : UILabel!
    @IBOutlet weak var expNoData                : UILabel!
    @IBOutlet weak var reviewsNoData            : UILabel!
    // MARK: - PROPERTIES
    var type = UserType.User
    weak var authVM: AuthViewModel!
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpVM(model: authVM)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        authVM.profileDetails()
        authVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            if let user_Details = self.authVM.userDetails?.data{
                self.profileImg.setImage(link: BaseURLs.userImgURL.rawValue + (user_Details.profileImg ?? ""), placeholder: "place_holder")
                    self.nameLbl.text = "\(user_Details.firstName ?? "") \(user_Details.lastName ?? "")"
                    self.unameLbl.text = "@\(user_Details.firstName?.lowercased() ?? "")\(user_Details.lastName?.lowercased() ?? "")"
                self.coverPhoto.setImage(link: BaseURLs.userCoverPic.rawValue + (user_Details.coverImg ?? ""))
            }
            self.expNoData.isHidden = (self.authVM.userDetails?.experienceData?.count ?? 0) != 0
            print("Fetched profile details")
            let tblHeight = self.tbl_rating.getTableHeight()
            self.tblHeight.constant = 100
            self.collection_experience.reloadData()
        }
    }
    func setupUI(){
        if type == .User{
            btn_creator.isHidden = true
            stack_creator.isHidden = true
        }
        else{
            btn_user.isHidden = true
        }
    }
    // MARK: - ACTIONS
    @IBAction func actionAdd(_ sender: UIButton) {
        let share = CameraHandler.shared
        share.showActionSheet(vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            self.authVM.coverPhoto = img
            self.authVM.addCoverPhoto()
            self.authVM.didFinishFetch = { [weak self](_) in
                guard let self = self else {return}
                self.coverPhoto.image = self.authVM.coverPhoto
            }
        }
    }
    @IBAction func editAction(_ sender : UIButton){
        let vc = UIStoryboard.loadUEditProfileVC()
        vc.viewModel = authVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - TABLEVIEW DELEGATE & DATASOURCE METHODS
extension UPersonalProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell") as? RatingCell else{
            return RatingCell()
        }
        return cell
    }
    
    
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension UPersonalProfileVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return authVM.userDetails?.experienceData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as? ExperienceDetailsCell else{
                return .init()
            }
            cell.configureCell(with: authVM.userDetails?.experienceData?[indexPath.row])
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.6, height:collectionView.frame.size.height)
    }
}


// MARK: - TABLEVIEW CELL
class RatingCell : UITableViewCell{
    
}
