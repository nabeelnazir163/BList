//
//  CreatorExperienceTabVC.swift
//  BList
//
//  Created by iOS TL on 25/05/22.
//

import UIKit
import SwiftUI
import IBAnimatable
import GooglePlaces
class CreatorExperienceTabVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var collection_creator       : UICollectionView!
    @IBOutlet weak var tbl_creator              : myTableView!
    @IBOutlet weak var nslayout_collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var nslayout_TableHeight     : NSLayoutConstraint!
    @IBOutlet weak var wishListView: AnimatableView!
    @IBOutlet weak var searchField              : AnimatedBindingText!{
        didSet{
            searchField.bind { [weak self] in
                self?.creatorVM.keyword.value = $0
            }
        }
    }
    @IBOutlet weak var locationBtn              : UIButton!
    @IBOutlet weak var creatorTypeLbl           : UILabel!
    // MARK: - PROPERTIES
    var creatorVM : CreatorViewModel!
    var userVM : UserViewModel!
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = UserViewModel(type: .ExperienceDetails)
        creatorVM = CreatorViewModel(type: .CreatorHome)
        searchField.addTarget(self, action: #selector(txtChangeAction(_:)), for: .editingChanged)
        locationBtn.addTarget(self, action: #selector(locationTapAction(_:)), for: .touchUpInside)
        creatorTypeLbl.text = AppSettings.UserInfo?.creatorType == "2" ? "Venue Creator" : "Individual Creator"
        wishListView.borderType = .dash(dashLength: 5, spaceLength: 5)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        counter = 0
        setUpVM(model: creatorVM)
        creatorVM.creatorHomeDetail()
        fetchCurrentLocation()
        creatorVM.didFinishFetch = { [weak self] apiType in
            guard let self = self else {return}
            switch apiType{
            case .CreatorHome:
                if self.creatorVM.identityVerified ?? "" == "0"{
                    if AppSettings.verificationAppeared != true{
                        if let vc = UIStoryboard.storyboardType(type: .creator).instantiateViewController(withIdentifier: "CreatorPageUnverifyiedPopUp") as? CreatorPageUnverifyiedPopUp {
                            vc.delegate = self
                            vc.modalPresentationStyle = .custom
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
                self.collection_creator.reloadData()
            case .DeleteExperience:
                if let index = self.creatorVM.experiences?.firstIndex(where: { exp in
                    exp.experienceID == self.creatorVM.expId
                }){
                    self.creatorVM.experiences?.remove(at: index)
                    self.nslayout_collectionHeight.constant = self.collection_creator.contentSize.height
                }
            case .SearchWishlists:
                self.setTableHeight()
            default:
                break
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTableHeight()
        nslayout_collectionHeight.constant = collection_creator.getCollectionHeight()
    }
    func fetchCurrentLocation(){
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            self.creatorVM.latitudes = ["\(lat)"]
            self.creatorVM.longitudes = ["\(long)"]
            self.userVM.latitude = "\(lat)"
            self.userVM.longitude = "\(long)"
            self.creatorVM.searchWishlists()
            Task{
                for try await location in Locations(coordinates: [CLLocationCoordinate2D(latitude: lat, longitude: long)]){
                    if let city_state_country = location.city_state_country {
                        let address = LocationManager.shared.appendAddress(components: city_state_country)
                        self.locationBtn.setTitle(address, for: .normal)
                    }
                    print("Locations retrieved --> \(location)")
                }
            }
        }
    }
    @objc func txtChangeAction(_ sender:UITextField){
        creatorVM.searchWishlists()
    }
    @objc func locationTapAction(_ sender:UIButton){
                let acController = GMSAutocompleteViewController()
                acController.delegate = self
                present(acController, animated: true, completion: nil)
    }
    
    func setTableHeight(){
        let tblHeight = tbl_creator.getTableHeight()
        nslayout_TableHeight.constant = tblHeight > 400 ? 400 : tblHeight
    }
    @IBAction func plusAction(_ sender :UIButton){
        //NewExperienceVC
        creatorVM.expDetails = nil
        let vc = UIStoryboard.loadNewExperienceVC()
        vc.creatorVM = creatorVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - TABLEVIEW DELEGATE & DATASOURCE METHODS
extension CreatorExperienceTabVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creatorVM.wishLists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BListPostTableCell") as? BListWishlistTableCell else{ return .init() }
        cell.configureData(data: creatorVM.wishLists?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
}

// MARK: - COLLECTION VIEW DELEGATE & DATA SOURCE METHODS
extension CreatorExperienceTabVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        creatorVM.experiences?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatorExperienceCell", for: indexPath) as? CreatorExperienceCell else{ return .init() }
        cell.configureCell(with: creatorVM.experiences?[indexPath.row])
        cell.btn_more.tag = indexPath.row
        cell.btn_more.addTarget(self, action: #selector(showMoreOption(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func showMoreOption(_ sender :UIButton){
        showOptions(index: sender.tag)
    }
    func showOptions(index: Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseOptionsVC") as! ChooseOptionsVC
        creatorVM.expId = creatorVM.experiences?[index].experienceID ?? ""
        vc.callBack = { [weak self](selectedOption) in
            guard let self = self else{return}
            switch selectedOption{
            case .Edit_Experience:
                self.creatorVM.expDetails = self.creatorVM.experiences?[index]
                let vc = UIStoryboard.loadNewExperienceVC()
                vc.creatorVM = self.creatorVM
                self.navigationController?.pushViewController(vc, animated: true)
            case .Activate:
                break
            case .Promote:
                let vc = UIStoryboard.loadPromoteVC()
                vc.viewModel = self.creatorVM
                self.navigationController?.pushViewController(vc, animated: true)
            case .Deactivate:
                break
            }
        }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        vc.experience = creatorVM.experiences?[index]
        self.present(vc, animated:true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collection_creator.frame.size.width - 15) / 2
        return CGSize(width: width, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = creatorVM.experiences?[indexPath.row]
        if data?.status == "1"{
            showOptions(index: indexPath.row)
        }
        else{
            userVM.expIds.append(creatorVM.experiences?[indexPath.row].experienceID ?? "0")
            let vc = UIStoryboard.loadNewlyExperienceDetail()
            vc.accountType = .creator
            vc.userVM = userVM
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension CreatorExperienceTabVC:active_deactiveDelegate{
    func acctive_Deactive(_ experience: String, status: String) {
        creatorVM.active_deactiveExperience(status == "1" ? true : false, experience_id: experience)
        creatorVM.didActivateDeactivateResult = {[weak self] in
            guard let self = self else{return}
            self.creatorVM.creatorHomeDetail()
            
        }
    }
    func deleteExperience() {
        creatorVM.deleteExperience()
    }
    
}
extension CreatorExperienceTabVC:DismissViewDelegate{
    func dismissView(_ type: String) {
        if type == "Unverify"{
            let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "IdentityVerificationVC") as! IdentityVerificationVC
            self.navigationController?.pushViewController(vc, animated:false)
        }
        else if type == "back"{
            AppSettings.verificationAppeared = true
            //            if let vc = UIStoryboard.storyboardType(type: .creator).instantiateViewController(withIdentifier: "CreatorPageUnverifyiedPopUp") as? CreatorPageUnverifyiedPopUp {
            //                vc.delegate = self
            //                vc.modalPresentationStyle = .custom
            //                vc.modalTransitionStyle = .crossDissolve
            //                self.present(vc, animated: true, completion: nil)
            //            }
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PromoteVC") as! PromoteVC
            self.navigationController?.pushViewController(vc, animated:false)
        }
    }
}
// MARK: - COLLECTIONVIEW CELL
class CreatorExperienceCell : UICollectionViewCell{
    @IBOutlet weak var viewImg          : AnimatableImageView!
    @IBOutlet weak var titlLbl          : UILabel!
    @IBOutlet weak var priceLbl         : UILabel!
    @IBOutlet weak var btn_more         : UIButton!
    @IBOutlet weak var userImg          : UIImageView!
    @IBOutlet weak var creatorTypeLbl   : UILabel!
    @IBOutlet weak var creatortTypeImg  : UIImageView!
    @IBOutlet weak var fadedView        : UIView!
    
    func configureCell(with data:Experience?){
        titlLbl.text = data?.experienceName
        priceLbl.text = "$ \(data?.amount ?? "")"
        viewImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverPic ?? ""), placeholder: "no_image")
        userImg.setImage(link: data?.userImage ?? "", placeholder: "img")
        creatorTypeLbl.text = data?.creatorType
        if data?.creatorType == "Individual Creator"{
            creatortTypeImg.image = UIImage(named: "creative-idea")
        }else if data?.creatorType == "Venue" {
            creatortTypeImg.image = UIImage(named: "venue")
        }else{
            creatortTypeImg.image = UIImage(named: "Team")
        }
        fadedView.alpha = data?.status ?? "0" == "1" ? 0.5 : 0
    }
}


// MARK: - GMSAutocompleteViewController Delegate Methods
extension CreatorExperienceTabVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        if let country = place.addressComponents?.filter({
            $0.types.contains("country")
        }).first{
            creatorVM.country = country.name
        }
        if let state = place.addressComponents?.filter({
            $0.types.contains("administrative_area_level_1")
        }).first{
            creatorVM.state = state.name
        }
        var locationName = [String]()
        locationName.append(place.name ?? "")
        for component in place.addressComponents ?? []{
            appendLocationNameComponent(value: component.name)
        }
        creatorVM.location_arr.append(locationName.joined(separator: ", "))
        creatorVM.latitudes = ["\(place.coordinate.latitude)"]
        creatorVM.longitudes = ["\(place.coordinate.longitude)"]
        creatorVM.searchWishlists()
        locationBtn.setTitle(place.formattedAddress ?? "", for: .normal)
        func appendLocationNameComponent(value: String){
            if !locationName.contains(value){
                locationName.append(value)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
