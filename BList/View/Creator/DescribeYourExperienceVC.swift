//
//  DescribeYourExperienceVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import GooglePlaces
protocol changeModelType : AnyObject{
    func changeModel()
}
class DescribeYourExperienceVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var txt_ExperienceTitle  : AnimatedBindingText!{
        didSet { txt_ExperienceTitle.bind{[unowned self] in self.creatorVM.experienceTitle.value = $0 } }
    }
    @IBOutlet weak var txt_AddLocation      : UITextField!
    @IBOutlet weak var collection_describe  : UICollectionView!
    @IBOutlet  var btn_experienceType       : [UIButton]!
    @IBOutlet  var btn_WillType             : [UIButton]!
    @IBOutlet  var tbl_location             : UITableView!
    @IBOutlet  var textView_willingTotravel : UITextView!
    @IBOutlet weak var willingTotravelCount : UILabel!
    @IBOutlet weak var location_Stack       : UIStackView!
    @IBOutlet  var View_willingTotravel     : UIView!
    @IBOutlet  var nslayout_locationHeight  : NSLayoutConstraint!
    @IBOutlet  var nslayout_categoryHeight  : NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    weak var creatorVM      : CreatorViewModel!
    private var dataSource  : TableViewDataSource<LocationCell,String>!
    weak var delegate       : changeModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: creatorVM)
        creatorVM.modelType = .DescribeExperience
        location_Stack.isHidden = creatorVM.kindOfExperience.0 == "Online" ? true : false
        txt_AddLocation.addTarget(self, action: #selector(chooseAction(_:)), for: .allEvents)
        setData()
        let layout = TagFlowLayout()
        collection_describe.collectionViewLayout = layout
        getCategoryData()
    }
    func getCategoryData(){
        creatorVM.getCategories()
        creatorVM.didFinishFetch = { [weak self](_) in
            guard let self = self else{return}
            if let index = self.creatorVM.categories.firstIndex(where: {($0.name ?? "").lowercased() == "all"}) {
                self.creatorVM.categories.remove(at: index)
            }
            if let expDetails = self.creatorVM.expDetails{
                let catIDs = (expDetails.expCategory ?? "").components(separatedBy: ",")
                for catID in catIDs {
                    if let index = self.creatorVM.categories.firstIndex(where: {$0.id == catID}){
                        self.creatorVM.categories[index].isSelected = true
                    }
                }
            }
            self.collection_describe.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tbl_location.layoutIfNeeded()
        nslayout_locationHeight.constant = tbl_location.contentSize.height
        collection_describe.layoutIfNeeded()
        nslayout_categoryHeight.constant = collection_describe.contentSize.height
        view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let expDetails = creatorVM.expDetails{
            setExperienceValue(Int(expDetails.expType ?? "") ?? 1)
            setWillingTravelVal(expDetails.willingTravel ?? "no" == "yes" ? 0 : 1)
            textView_willingTotravel.text = expDetails.willingMessage ?? ""
            updateCharacterCount()
            if creatorVM.latitudes.count > 0 && creatorVM.longitudes.count == creatorVM.longitudes.count{
                var coordinates = [CLLocationCoordinate2D]()
                for i in 0..<creatorVM.latitudes.count{
                    if let lat = Double(creatorVM.latitudes[i]), let long = Double(creatorVM.longitudes[i]){
                        coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
                    }
                }
                Task{
                    creatorVM.location_arr.removeAll()
                    for try await location in Locations(coordinates: coordinates){
                        if let completeAddress = location.completeAddress {
                            creatorVM.location_arr.append(completeAddress)
                        }
                    }
                    tbl_location.isHidden = false
                    nslayout_locationHeight.constant = tbl_location.getTableHeight()
                }
            }
        }
    }
    // MARK: - OBJ FUNCTIONS
    @objc func chooseAction(_ textField : UITextField) {
        if !textField.isFirstResponder {
            return
        }
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    // MARK: - KEY FUNCTIONS
    func setData(){
        self.updateCharacterCount()
        txt_ExperienceTitle.text = creatorVM.experienceTitle.value
        if self.creatorVM.experienceType.value != "", let expTypeInInt = Int(creatorVM.experienceType.value){
            setExperienceValue(expTypeInInt)
        }
        setWillingTravelVal(creatorVM.willingToTravel.value == "yes" ? 0 : 1)
        self.nslayout_categoryHeight.constant = collection_describe.getCollectionHeight()
    }
    
    func updateCharacterCount() {
        let summaryCount = self.textView_willingTotravel.text.count
        self.willingTotravelCount.text    = "\((0) + summaryCount)/100"
    }
    // Set experience Type
    func setExperienceValue(_ tag : Int){
        btn_experienceType.forEach({$0.setImage(UIImage.init(named: "radio_button"), for: .normal)})
        btn_experienceType[tag-1].setImage(UIImage.init(named: "radio_active"), for: .normal)
    }
    
    // set the value of willing to travel
    func setWillingTravelVal(_ tag : Int){
        btn_WillType.forEach({$0.setImage(UIImage.init(named: "radio_button"), for: .normal)})
        btn_WillType[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
        View_willingTotravel.isHidden = tag == 0 ? false : true
    }
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - ACTIONS
    @IBAction func selectDateAction(_ sender :UIButton){
        creatorVM.hasStartEndDate.value = sender.currentTitle?.lowercased() ?? ""
    }
    @IBAction func experincTypeAction(_ sender : UIButton){
        setExperienceValue(sender.tag)
        creatorVM.experienceType.value = "\(sender.tag)"
    }
    
    @IBAction func willTypeAction(_ sender : UIButton){
        setWillingTravelVal(sender.tag)
        creatorVM.willingToTravel.value = sender.currentTitle?.lowercased() ?? ""
    }
    
    @IBAction func submit(_ sender : UIButton){
        if creatorVM.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLanguageVC") as! ChooseLanguageVC
            vc.delegate = self
            vc.viewModel = creatorVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: creatorVM.brokenRules.first?.message ?? "")
        }
    }
    
}
//MARK: - TV DELEGATE & DATASOURCE METHODS
extension DescribeYourExperienceVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorVM.location_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else{return .init()}
        cell.lbl_location.text = creatorVM.location_arr[indexPath.row]
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteLocation(_:)), for: .touchUpInside)
        return cell
    }
    @objc func deleteLocation(_ sender:UIButton){
        creatorVM.location_arr.remove(at: sender.tag)
        creatorVM.location_coordinates.remove(at: sender.tag)
        if self.creatorVM.location_arr.count == 0{
            self.nslayout_locationHeight.constant = 0
            self.tbl_location.isHidden = true
        }
        else{
            self.tbl_location.isHidden = false
            self.nslayout_locationHeight.constant = self.tbl_location.getTableHeight()
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - TEXTVIEW DELEGATE METHOD
extension DescribeYourExperienceVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        self.creatorVM.willingMessage.value = newText
        return numberOfChars <= 100
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else  {
            return
        }
        let _ = text.count
        let _ = text.filter {$0 == "\n"}.count
        self.updateCharacterCount()
    }
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension DescribeYourExperienceVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = creatorVM.categories.filter({$0.isSelected}).count
        if count == 0 {
            return 1
        }
        return  count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let selectedCategories = creatorVM.categories.filter({$0.isSelected})
        if selectedCategories.count == 0 || (indexPath.row == selectedCategories.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddMoreCell
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell2", for: indexPath) as! MyCollectionViewCell2
            cell.lbl.text = selectedCategories[indexPath.row].name?.capitalized
            cell.closeBtn.tag = Int(selectedCategories[indexPath.row].id ?? "") ?? 0
            cell.closeBtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    @objc func closeBtnAction(_ sender:UIButton){
        if let index = creatorVM.categories.firstIndex(where: { category in
            category.id == "\(sender.tag)"
        }){
            creatorVM.categories[index].isSelected.toggle()
        }
        self.nslayout_categoryHeight.constant = collection_describe.getCollectionHeight()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategories = creatorVM.categories.filter({$0.isSelected})
        if selectedCategories.count == 0 || (indexPath.row == selectedCategories.count) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseVC") as! ChooseVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.creatorVM = self.creatorVM
            vc.callBack = {
                self.nslayout_categoryHeight.constant = self.collection_describe.getCollectionHeight()
            }
            self.present(vc, animated:true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectedCategories = creatorVM.categories.filter({$0.isSelected})
        if selectedCategories.count == 0 || (indexPath.row == selectedCategories.count){
            return CGSize(width: 100, height: 30)
        }
        else{
            let label = UILabel()
            label.text = selectedCategories[indexPath.row].name?.capitalized
            label.font = UIFont.cabin_SemiBold(size: 14)
            let lblWidth = label.intrinsicContentSize.width
            let cellWidth:CGFloat = 40 + lblWidth
            return CGSize(width: cellWidth, height: 30)
        }
    }
}
extension DescribeYourExperienceVC:changeModelType{
    func changeModel() {
        creatorVM.modelType = .DescribeExperience
    }
}
// MARK: - GMSAutocompleteViewController Delegate Methods
extension DescribeYourExperienceVC: GMSAutocompleteViewControllerDelegate {
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
        guard (place.addressComponents?.count  ?? 0) > 2 else {
            self.showErrorMessages(message: "Please select complete address")
            self.dismiss(animated: true)
            return
        }
        for component in place.addressComponents ?? []{
            appendLocationNameComponent(value: component.name)
            if component.types.contains(where: {$0 == "country"}) {
                
                if component.name != "" {
                    creatorVM.countries.append(component.name)
                } else {
                    creatorVM.countries.append(component.shortName ?? "")
                }
                
               /* if let shortName = component.shortName {
                    creatorVM.countries.append(shortName)
                } else {
                    creatorVM.states.append(component.name)
                }*/
            }
            if component.types.contains(where: {$0 == "administrative_area_level_1"}) {
                if let shortName = component.shortName {
                    creatorVM.states.append(shortName)
                } else {
                    creatorVM.states.append(component.name)
                }
            }
            if component.types.contains(where: {$0 == "locality"}) {
                if component.name != "" {
                    creatorVM.cities.append(component.name)
                } else {
                    creatorVM.cities.append(component.shortName ?? "")
                }
                
                /*if let shortName = component.shortName {
                    creatorVM.cities.append(shortName)
                } else {
                    creatorVM.cities.append(component.name)
                }*/
            }
        }
        
        creatorVM.location_arr.append(locationName.joined(separator: ","))
        creatorVM.latitudes.append("\(place.coordinate.latitude)")
        creatorVM.longitudes.append("\(place.coordinate.longitude)")
//        creatorVM.states.append(place.)
        creatorVM.location_coordinates.append("\(place.coordinate.latitude)-\(place.coordinate.longitude)")
        self.tbl_location.isHidden = false
        self.nslayout_locationHeight.constant = self.tbl_location.getTableHeight()
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

// MARK: - UITABLEVIEWCELL
class LocationCell: UITableViewCell{
    @IBOutlet weak var lbl_location : UILabel!
    @IBOutlet weak var deleteBtn    : UIButton!
    
}
