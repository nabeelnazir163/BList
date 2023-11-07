//
//  FilterVC.swift
//  BList
//
//  Created by iOS TL on 24/05/22.
//

import UIKit
import IBAnimatable
import GooglePlaces
enum SwitchBtn{
    case filter
    case other
}
class FilterVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var typeCHeight      : NSLayoutConstraint!
    @IBOutlet weak var expTypeCHeight   : NSLayoutConstraint!
    @IBOutlet weak var typeCV           : UICollectionView!
    @IBOutlet weak var expTypeCV        : UICollectionView!
    @IBOutlet weak var othersCV         : UICollectionView!
    @IBOutlet weak var othersCHeight    : NSLayoutConstraint!
    @IBOutlet weak var view_filter      : UIView!
    @IBOutlet weak var view_other       : UIView!
    @IBOutlet weak var dateTF           : UITextField!
    @IBOutlet weak var keywordTF        : AnimatedBindingText! {
        didSet {
            keywordTF.bind { [unowned self] in
                viewModel.keyword.value = $0
            }
        }
    }
    @IBOutlet weak var creatorIdTF: AnimatedBindingText! {
        didSet {
            creatorIdTF.bind { [unowned self] in
                viewModel.creatorId.value = $0
            }
        }
    }
    @IBOutlet weak var locationTF       : UITextField! {
        didSet{
            locationTF.inputView = UIView()
            locationTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var otherLocationTF  : UITextField! {
        didSet{
            otherLocationTF.inputView = UIView()
            otherLocationTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var before_timeTF    : UITextField!
    @IBOutlet weak var after_timeTF     : UITextField!
    @IBOutlet weak var anyTimeBtn       : UIButton!
    @IBOutlet weak var sliderView       : RangeSeekSlider!{
        didSet{
            sliderView.selectedMinValue = CGFloat(Int(self.viewModel.min_price) ?? 0)
            sliderView.selectedMaxValue = CGFloat(Int(self.viewModel.max_price) ?? 0)
            sliderView.delegate = self
        }
    }
    // MARK: - PROPERTIES
   
    weak var viewModel: UserViewModel!
    var apiSuccess:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        expTypeCV.collectionViewLayout = TagFlowLayout()
        addDatePickers()
        locationTF.addTarget(self, action: #selector(chooseAction(_:)), for: .allEvents)
        otherLocationTF.addTarget(self, action: #selector(chooseAction(_:)), for: .allEvents)
        anyTimeBtn.addTarget(self, action: #selector(anyTimeTapAction(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.modelType = .Filter
        setUpVM(model: viewModel)
        self.viewModel.categories = []
        viewModel.getCategories()
        viewModel.didFinishFetch = { [weak self](ApiType) in
            guard let self = self else{return}
            switch ApiType{
            case .Filter,.OtherFilter:
                self.apiSuccess?()
                self.dismiss(animated: false)
            case .Categories:
//                if let index = self.viewModel.categories.firstIndex(where: {($0.name ?? "").lowercased() == "all"}) {
//                    self.viewModel.categories.remove(at: index)
//                }
                
                self.before_timeTF.text = self.viewModel.before_time
                self.after_timeTF.text = self.viewModel.after_time
                if self.before_timeTF.text != nil{
                    self.after_timeTF.addDatePicker(mode: .time, minDate: nil,
                                                    maxDate: self.viewModel.maxDate,
                                             target: self,
                                                    selector: #selector(self.requestTimeAction(_:)))
                }

                self.dateTF.text = self.viewModel.date
                self.locationTF.text = self.viewModel.location.value
               // self.anyTimeBtn.isSelected = !self.viewModel.time
                self.expTypeCHeight.constant = self.expTypeCV.getCollectionHeight()
            default:
                break
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        typeCHeight.constant = typeCV.getCollectionHeight()
        expTypeCHeight.constant = expTypeCV.getCollectionHeight()
        othersCHeight.constant = othersCV.getCollectionHeight()
    }
    @objc func chooseAction(_ textField : UITextField) {
        viewModel.otherLocation = textField.tag == 1
        if !textField.isFirstResponder {
            return
        }
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func addDatePickers(){
        dateTF.addDatePicker(minDate: Date(),
                                 maxDate: nil,
                                 target: self,
                                 selector: #selector(requestDateAction(_:)))
        before_timeTF.addDatePicker(mode: .time, minDate: nil,
                                 maxDate: nil,
                                 target: self,
                                 selector: #selector(requestTimeAction(_:)))
        after_timeTF.addTarget(self, action: #selector(after_timeAction(_:)), for: .editingDidBegin)
    }
    @objc func after_timeAction(_ sender:UITextField){
        if viewModel.before_time.isEmptyOrWhitespace(){
            showErrorMessages(message: "Please select before time first")
            sender.resignFirstResponder()
        }
    }
    @objc func requestDateAction(_ sender:UITextField) {
        if let datePicker = self.dateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormat.ddMMyyyy.rawValue
            self.dateTF.text = dateFormatter.string(from: datePicker.date)
            dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
            self.viewModel.date = dateFormatter.string(from: datePicker.date)
        }
        self.dateTF.resignFirstResponder()
    }
    
    @objc func requestTimeAction(_ sender:UITextField) {
        if sender.tag == 0 {
            if let datePicker = before_timeTF.inputView as? UIDatePicker {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = DateFormat.HHmm.rawValue
                before_timeTF.text = dateFormatter.string(from: datePicker.date)
                viewModel.maxDate = datePicker.date
                after_timeTF.addDatePicker(mode: .time, minDate: nil,
                                           maxDate: datePicker.date,
                                         target: self,
                                         selector: #selector(requestTimeAction(_:)))
                self.viewModel.before_time = before_timeTF.text ?? ""
                self.before_timeTF.resignFirstResponder()
            }
        }
        else {
            if let datePicker = after_timeTF.inputView as? UIDatePicker {
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = DateFormat.HHmm.rawValue
                self.after_timeTF.text = dateFormatter.string(from: datePicker.date)
                self.viewModel.after_time = after_timeTF.text ?? ""
                self.after_timeTF.resignFirstResponder()
            }
        }
    }
    // MARK: - ACTIONS
    @IBAction func segmentAction(_ sender : UIButton){
        if sender.tag == 1 {
            view_filter.isHidden = false
            view_other.isHidden = true
        }
        else{
            view_filter.isHidden = true
            view_other.isHidden = false
        }
    }
    @objc func anyTimeTapAction(_ sender:UIButton){
        sender.isSelected.toggle()
        viewModel.time.toggle()
    }
    @IBAction func applyBtnAction(_ sender:UIButton){
        viewModel.type = viewModel.creatorTypes_arr[0].types?.filter({$0.isSelected == true}).map({String($0.typeID)}).joined(separator: ",") ?? ""
        viewModel.creator_type = viewModel.creatorTypes_arr[1].types?.filter({$0.isSelected == true}).map({String($0.typeID)}).joined(separator: ",") ?? ""
        viewModel.modelType = sender.tag == 0 ? .Filter : .OtherFilter
        if viewModel.isValid {
            switch viewModel.modelType {
            case .Filter:
                viewModel.filter()
            case .OtherFilter:
                viewModel.otherFilter()
            default:
                break
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "try again")
        }
    }
    
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension FilterVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0{
            return viewModel.creatorTypes_arr.count
        }
        else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return viewModel.creatorTypes_arr[section].types?.count ?? 0
        }
        if collectionView.tag == 1{
            return viewModel.categories.count
        }
        else{
            return viewModel.creatorTypes_arr[1].types?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatorTypeCell", for: indexPath) as? CreatorTypeCell else{return .init()}
                
                cell.configure(data: viewModel.creatorTypes_arr[indexPath.section].types?[indexPath.row])
                return cell
            
        }
        else if collectionView.tag == 1{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceTypeCell", for: indexPath) as? ExperienceTypeCell else{return .init()}
            cell.configure(data: viewModel.categories[indexPath.row])
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatorTypeCell", for: indexPath) as? CreatorTypeCell else{return .init()}
            cell.configure(data: viewModel.creatorTypes_arr[1].types?[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
                viewModel.creatorTypes_arr[indexPath.section].types?[indexPath.row].isSelected.toggle()
                typeCV.reloadItems(at: [indexPath])
        }
        else if collectionView.tag == 1{
            viewModel.categories[indexPath.row].isSelected = !viewModel.categories[indexPath.row].isSelected //true
            expTypeCV.reloadData()
        }
        else{
            viewModel.creatorTypes_arr[1].types?[indexPath.row].isSelected.toggle()
            othersCV.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 2{
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 || collectionView.tag == 2{
            let width = (collectionView.frame.size.width - 20) / 2
                            return CGSize(width: width, height: 30)
        }
        else {
            let isSelected = viewModel.categories[indexPath.row].isSelected
            let lblWidth = UILabel().labelSize(width: collectionView.frame.size.width, height: 30, font: isSelected ? UIFont.cabin_SemiBold(size: 12) : UIFont.cabin_Regular(size: 12), text: viewModel.categories[indexPath.row].name ?? "").width
            let totalWidth = lblWidth + 12 + 12
            return CGSize(width: totalWidth, height: 26)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == typeCV || collectionView == expTypeCV{
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeader", for: indexPath) as? TitleHeader{
                if collectionView.tag == 0{
                    sectionHeader.title.text = viewModel.creatorTypes_arr[indexPath.section].headerName ?? ""
                }
                else{
                    sectionHeader.title.text = "Experience Type:"
                }
                return sectionHeader
            }
        }
        return UICollectionReusableView()
    }
}

// MARK: - COLLECTIONVIEW CELL

class CreatorTypeCell : UICollectionViewCell{
    
    @IBOutlet weak var typeBtn: UIButton!
    func configure(data: CreatorType_Filter.TypeDetails?){
        if let selection = data?.isSelected{
            typeBtn.isSelected = selection
            typeBtn.setTitle(data?.typeName, for: .normal)
            typeBtn.titleLabel?.font = selection ? UIFont.cabin_SemiBold(size: 12) : UIFont.cabin_Regular(size: 12)
        }
    }
}
class ExperienceTypeCell: UICollectionViewCell{
    @IBOutlet weak var lbl_value        :AnimatableLabel!
    @IBOutlet weak var containerView    :AnimatableView!
    func configure(data: Category){
        if data.isSelected == true{
            containerView.borderWidth = 1
            containerView.backgroundColor = UIColor.clear
            lbl_value.textColor = UIColor.init(hexString: "#F96A27")
            lbl_value.font = UIFont.cabin_SemiBold(size: 12)
        }
        else{
            containerView.borderWidth = 0
            containerView.backgroundColor = UIColor.init(hexString: "#EFF0F1")
            lbl_value.textColor = UIColor.init(hexString: "#252634")
            lbl_value.font = UIFont.cabin_Regular(size: 12)
        }
        lbl_value.text = data.name ?? ""
    }
}
// MARK: - RANGESEEKSLIDER DELEGATE METHODS
extension FilterVC:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat){
        viewModel.min_price = "\(Int(minValue.rounded()))"
        viewModel.max_price = "\(Int(maxValue.rounded()))"
    }
}
// MARK: - GMSAutocompleteViewController Delegate Methods
extension FilterVC: GMSAutocompleteViewControllerDelegate {
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
        if viewModel.otherLocation == true {
            viewModel.otherLatitude = "\(place.coordinate.latitude)"
            viewModel.otherLongitude = "\(place.coordinate.longitude)"
            viewModel.other_location = locationName.joined(separator: ", ")
            self.otherLocationTF.text = locationName.joined(separator: ", ")
        } else {
            viewModel.filterLatitude = "\(place.coordinate.latitude)"
            viewModel.filterLongitude = "\(place.coordinate.longitude)"
            viewModel.filter_location = locationName.joined(separator: ", ")
            self.locationTF.text = locationName.joined(separator: ", ")
        }

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

// MARK: - STRUCTS
struct CreatorType_Filter{
    let headerName: String?
    var types: [TypeDetails]?
    
    struct TypeDetails{
        let typeID: Int
        let typeName: String
        var isSelected = false
    }
}

struct ExperienceType_Filter{
    let typeName: String?
    var isSelected = false
}
