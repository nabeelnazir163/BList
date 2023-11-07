//
//  PromoteVC.swift
//  BList
//
//  Created by PARAS on 28/05/22.
//

import UIKit
import GooglePlaces
import DropDown
class PromoteVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var minAgeTF: AnimatedBindingText!{
        didSet { minAgeTF.bind { [unowned self] in
                self.viewModel.minAgeLimit.value = $0 } }
    }
    @IBOutlet weak var maxAgeTF: AnimatedBindingText!{
        didSet { maxAgeTF.bind { [unowned self] in
                self.viewModel.maxAgeLimit.value = $0 } }
    }
    @IBOutlet weak var budgetTF: AnimatedBindingText!{
        didSet { budgetTF.bind { [unowned self] in
                self.viewModel.budget.value = $0 } }
    }
    @IBOutlet var genderBtns                : [UIButton]!
    @IBOutlet weak var txt_AddLocation      : UITextField!
    @IBOutlet  var tbl_location             : UITableView!
    @IBOutlet weak var sliderView           : RangeSeekSlider!{
        didSet{
            sliderView.delegate = self
        }
    }
    @IBOutlet weak var runTimeTF            : UITextField!{
        didSet{
            runTimeTF.inputView = UIView()
            runTimeTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet  var nslayout_locationHeight  : NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var dropDown: DropDown = DropDown()
    weak var viewModel : CreatorViewModel!
    var userVM: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.location_arr = []
        viewModel.modelType = .PromoteExperience
        userVM = UserViewModel(type: .GetCardsList)
        txt_AddLocation.addTarget(self, action: #selector(chooseAction(_:)), for: .allEvents)
        runTimeTF.addTarget(self, action: #selector(runTimePickerAction(_:)), for: .editingDidBegin)
    }
    
    // MARK: - OBJ FUNCTIONS
    @objc func runTimePickerAction(_ sender: UITextField) {
        dropDown.anchorView = sender
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
            dropDown.dataSource = Array(1...30).map({String($0)})
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            sender.text = item
            viewModel.runtime = item
        }
        dropDown.show()
    }
    @objc func chooseAction(_ textField : UITextField) {
        if !textField.isFirstResponder {
            return
        }
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    // MARK: - ACTION
    @IBAction func genderBtnAction(_ sender:UIButton){
        genderBtns.forEach { genderBtn in
            if genderBtn.tag == sender.tag{
                genderBtn.isSelected = !genderBtn.isSelected
            }
        }
        viewModel.gender = genderBtns.filter({$0.isSelected}).map({$0.currentTitle ?? ""})
    }
    
    @IBAction func doneAction(_ sender : UIButton){
        if viewModel.isValid{
            let vc = UIStoryboard.loadUPaymentMethodsVC()
            vc.creatorVM = self.viewModel
            vc.userVM = userVM
            vc.paymentTypeScreen = .promoteExp
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "try again")
        }
        /*
         if cardId.isEmptyOrWhitespace(){
             self.brokenRules.append(BrokenRule(propertyName: "NoCardId", message: "Please pick a card for payment"))
         }
         */
    }
}

// MARK: - RANGESEEKSLIDER DELEGATE METHODS
extension PromoteVC:RangeSeekSliderDelegate{
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat){
        viewModel.minradius = "\(Int(minValue.rounded()))"
        viewModel.maxradius = "\(Int(maxValue.rounded()))"
    }
}
//MARK: - TV DELEGATE & DATASOURCE METHODS
extension PromoteVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.location_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else{return .init()}
        cell.lbl_location.text = viewModel.location_arr[indexPath.row]
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteLocation(_:)), for: .touchUpInside)
        return cell
    }
    @objc func deleteLocation(_ sender:UIButton){
        viewModel.location_arr.remove(at: sender.tag)
        viewModel.location_coordinates.remove(at: sender.tag)
        if self.viewModel.location_arr.count == 0{
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

// MARK: - GMSAutocompleteViewController Delegate Methods
extension PromoteVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        if let country = place.addressComponents?.filter({
            $0.types.contains("country")
        }).first{
            viewModel.country = country.name
        }
        if let state = place.addressComponents?.filter({
            $0.types.contains("administrative_area_level_1")
        }).first{
            viewModel.state = state.name
        }
        var locationName = [String]()
        locationName.append(place.name ?? "")
        for component in place.addressComponents ?? []{
            appendLocationNameComponent(value: component.name)
        }
        viewModel.location_arr.append(locationName.joined(separator: ", "))
        viewModel.latitudes.append("\(place.coordinate.latitude)")
        viewModel.longitudes.append("\(place.coordinate.longitude)")
        viewModel.location_coordinates.append("\(place.coordinate.latitude)-\(place.coordinate.longitude)")
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
