//
//  ExperienceTabVC.swift
//  BList
//
//  Created by iOS TL on 16/05/22.
//

import UIKit
import CoreLocation
import GooglePlaces
import IBAnimatable

enum AddressMapEnum: Codable {
    case none
    case country
    case cityStateCountry
    case stateCounry
}

struct AddressMapModel: Codable {
    var type: AddressMapEnum
    var city: String = ""
    var state: String = ""
    var country: String = ""
}


class ExperienceTabVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var container            : UIView!
    @IBOutlet weak var collection_category  : UICollectionView!
    @IBOutlet weak var locationTF           : UITextField!
    
    // MARK: - PROPERTIES
    
    var currentViewController: UIViewController?
    var selectedIndex = 0
    var userVM: UserViewModel!
    let expBasedCatVC = UIStoryboard.loadExperiencesBasedOnCategoryVC()
    let allCatVC = UIStoryboard.loadAllCategoryVC()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundObserver()
        userVM = UserViewModel(type: .Categories)
        guard let items = self.tabBarController?.tabBar.items else {return}
        if AppSettings.UserInfo != nil {
            items.last?.title = "Profile"
        }else{
            items.last?.title = "Login"
        }
        locationTF.addTarget(self, action: #selector(locationChangeAction(_:)), for: .editingDidBegin)
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdate(_:)), name: NSNotification.Name(K.NotificationKeys.locationUpdate), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrentLocation()
        fetchCategories()
    }
    @objc func locationUpdate(_ sender:NSNotification) {
        fetchCurrentLocation()
    }
    override func appMovedToForeground() {
        self.displayCurrentTab(0)
    }
    func fetchCategories(){
        userVM.getCategories()
        userVM.didFinishFetch = { _ in
            self.userVM.catID = self.userVM.categories.first?.id ?? ""
            self.displayCurrentTab(0)
            self.collection_category.reloadData()
        }
    }
    @objc func locationChangeAction(_ textField : UITextField) {
        if !textField.isFirstResponder {
            return
        }
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    func fetchCurrentLocation(){
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            userVM.latitude = "\(lat)"
            userVM.longitude = "\(long)"
            print(AppSettings.currentLocation)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            Task{
                for try await location in Locations(coordinates: [coordinate]){
                    let city = location.city_state_country?.city ?? ""
                    let state = location.city_state_country?.state ?? ""
                    let country = location.city_state_country?.country ?? ""
                    if let city_state_country = location.city_state_country {
                        if self.userVM.locationName != "" {
                            self.locationTF.text = self.userVM.locationName
                        } else {
                            self.locationTF.text = LocationManager.shared.appendAddress(components: city_state_country)
                        }
                    }
                    self.userVM.city = city
                    self.userVM.state = state
                    self.userVM.country = country
                    print("Locations retrieved --> \(location)")
                    break
                }
            }
        } else {
            self.locationTF.text = "World wide"
        }
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else{return}
                if let currentVC = self.currentViewController{
                    currentVC.willMove(toParent: nil)
                    currentVC.removeFromParent()
                    currentVC.view.removeFromSuperview()
                }
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.view.frame = self.container.bounds
                self.container.addSubview(vc.view)
                self.currentViewController = vc
            }
        }
    }
    
    @IBAction func seeAll(_ sender : UIButton){
        let vc = UIStoryboard.loadAllCategoriesListVC()
        vc.hidesBottomBarWhenPushed = true
        vc.userVM = userVM
        vc.selectedIndex = { [weak self](selIndex) in
            guard let self = self else {return}
            self.selectedIndex = selIndex
            DispatchQueue.main.async {
                self.collection_category.reloadData()
                self.collection_category.scrollToItem(at: IndexPath(item: selIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
            self.displayCurrentTab(selIndex)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var viewController: UIViewController?
        if userVM.categories.count > 0 {
            userVM.catID = userVM.categories[index].id ?? ""
        }
        switch index {
        case 0 :
            allCatVC.parentVC = self
            allCatVC.userVM = userVM
            viewController = allCatVC
        default :
            expBasedCatVC.categoryDetails = userVM.categories[index]
            expBasedCatVC.parentVC = self
            expBasedCatVC.userVM = userVM
            viewController = expBasedCatVC
        }
        return viewController
    }
}
extension ExperienceTabVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return CategoryCell()
        }
        cell.configureCell(data: userVM.categories[indexPath.row], isSelected: selectedIndex == indexPath.item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collection_category.reloadData()
        displayCurrentTab(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == selectedIndex{
            return CGSize(width: 90, height: 90)
        }
        else{
            return  CGSize(width: 70, height: 70)
        }
    }
}

class CategoryCell: UICollectionViewCell{
    @IBOutlet weak var img_category     : UIImageView!
    @IBOutlet weak var lbl_title        : UILabel!
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var mainView         : AnimatableView!
        
    func configureCell(data: Category,isSelected: Bool){
        lbl_title.text = data.name ?? ""
        img_category.setImage(link: data.image ?? "")
        if isSelected == true {
            mainView.borderColor = UIColor.lightGray
            mainView.borderWidth = 0.5
        } else {
            mainView.borderColor = UIColor.clear
        }
    }
    func configureCell(data: Category){
        lbl_title.text = data.name ?? ""
        img_category.setImage(link: data.image ?? "")
    }
    func configureCell(with data: GetNotificationsResponseModel.NotificationDetails.Categories?) {
        lbl_title.text = data?.name ?? ""
        img_category.setImage(link: BaseURLs.categoryURL.rawValue + (data?.image ?? ""))
        containerView.backgroundColor = UIColor(hexString: data?.color ?? "000000")
    }
}
// MARK: - GMSAutocompleteViewController Delegate Methods
extension ExperienceTabVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        /*if let country = place.addressComponents?.filter({
         $0.types.contains("country")
         }).first{
         viewModel.country = country.name
         }
         if let state = place.addressComponents?.filter({
         $0.types.contains("administrative_area_level_1")
         }).first{
         viewModel.state = state.name
         }*/
        var locationName = [String]()
        locationName.append(place.name ?? "")
        for component in place.addressComponents ?? []{
            appendLocationNameComponent(value: component.name)
        }
        userVM.latitude = "\(place.coordinate.latitude)"
        userVM.longitude = "\(place.coordinate.longitude)"
        displayCurrentTab(selectedIndex)
        userVM.locationName = locationName.joined(separator: ", ")
        self.locationTF.text = locationName.joined(separator: ", ")
        AppSettings.currentLocation = [
            "lat" : place.coordinate.latitude,
            "long": place.coordinate.longitude
        ]
        
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
