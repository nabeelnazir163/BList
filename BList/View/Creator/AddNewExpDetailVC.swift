//
//  AddNewExpDetailVC.swift
//  BList
//
//  Created by iOS Team on 27/05/22.
//

import UIKit

class AddNewExpDetailVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var txt_item             : AnimatedBindingText!{
        didSet { txt_item.bind{[unowned self] in self.viewModel.services.value = $0 } }
    }
    @IBOutlet weak var txt_guestRequirement : AnimatedBindingText!{
        didSet { txt_guestRequirement.bind{[unowned self] in self.viewModel.requireToBring.value = $0 } }
    }
    @IBOutlet weak var txt_age              : AnimatedBindingText!{
        didSet { txt_age.bind{[unowned self] in self.viewModel.minAgeLimit.value = $0 } }
    }
    @IBOutlet weak var txt_Max_age          : AnimatedBindingText!{
        didSet { txt_Max_age.bind{[unowned self] in self.viewModel.maxAgeLimit.value = $0 } }
    }
    @IBOutlet weak var txt_minGuestLimit    : AnimatedBindingText!{
        didSet { txt_minGuestLimit.bind{[unowned self] in self.viewModel.minGuestLimit.value = $0 } }
    }
    @IBOutlet weak var txt_maxGuestLimit    : AnimatedBindingText!{
        didSet { txt_maxGuestLimit.bind{[unowned self] in self.viewModel.maxGuestlimit.value = $0 } }
    }
    @IBOutlet weak var txt_experience_amount: AnimatedBindingText!{
        didSet {
            txt_experience_amount.delegate = self
            txt_experience_amount.bind{[unowned self] in self.viewModel.experienceAmount.value = $0 } }
    }
    @IBOutlet weak var textView_clothing    : UITextView!
    @IBOutlet weak var count_clothLbl       :UILabel!
    @IBOutlet weak var txtView_handicapeDesc: UITextView!
    @IBOutlet var btns_handicape            : [UIButton]!
    @IBOutlet var btns_pets                 : [UIButton]!
    @IBOutlet weak var View_handiDes        : UIView!
    @IBOutlet weak var activityLevelCV      : UICollectionView!{
        didSet{
            activityLevelCV.delegate = self
            activityLevelCV.dataSource = self
        }
    }
    @IBOutlet weak var collectionHeight     : NSLayoutConstraint!
    // MARK: - PROPERTIES
    weak var delegate : changeModelType?
    weak var viewModel : CreatorViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLevelCV.collectionViewLayout = TagFlowLayout()
        activityLevelCV.reloadData()
        activityLevelCV.layoutIfNeeded()
        collectionHeight.constant = activityLevelCV.contentSize.height
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.modelType = .ItemDetail
        setData()
    }
    // MARK: - KEY FUNCTIONS
    func setData(){
        self.txt_item.text = self.viewModel.services.value
        self.txt_guestRequirement.text = self.viewModel.requireToBring.value
        self.txt_experience_amount.text = self.viewModel.experienceAmount.value
        self.txt_age.text = self.viewModel.minAgeLimit.value
        self.txt_Max_age.text = self.viewModel.maxAgeLimit.value
        self.txt_minGuestLimit.text = self.viewModel.minGuestLimit.value
        self.textView_clothing.text = self.viewModel.clothingRecommendation.value
        self.txt_maxGuestLimit.text = self.viewModel.maxGuestlimit.value
        self.txt_experience_amount.text = self.viewModel.experienceAmount.value
        setHandicapOption(self.viewModel.handicapAccessible.value == "yes" ? 0 : 1)
        self.txtView_handicapeDesc.text = self.viewModel.handicapDescription.value
        setPetData(self.viewModel.isPetAllow.value == "yes" ? 0 : 1)
        self.updateCharacterCount()
    }
    func updateCharacterCount() {
        let summaryCount = self.textView_clothing.text.wordsCount()
        self.count_clothLbl.text    = "\((0) + summaryCount)/100"
    }
    
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    // set pets value
    func setPetData(_ tag : Int){
        btns_pets.forEach({$0.setImage(UIImage.init(named: "radio"), for: .normal)})
        btns_pets[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
    }
    //is handicap accessible
    func setHandicapOption(_ tag : Int){
        btns_handicape.forEach({$0.setImage(UIImage.init(named: "radio"), for: .normal)})
        btns_handicape[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
        View_handiDes.isHidden = tag == 0 ? false : true
    }
    
    // MARK: - ACTIONS
    @IBAction func petsAction(_ sender : UIButton){
        setPetData(sender.tag)
        viewModel.isPetAllow.value = sender.currentTitle?.lowercased() ?? ""
    }
    
    @IBAction func handiCapAction(_ sender : UIButton){
        setHandicapOption(sender.tag)
        viewModel.handicapAccessible.value = sender.currentTitle?.lowercased() ?? ""
    }
    
    @IBAction func submit(_ sender : UIButton){
        viewModel.handicapDescription.value = txtView_handicapeDesc.text!
        if viewModel.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddExpPhotosVC") as! AddExpPhotosVC
            vc.creatorVM = viewModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
// MARK: - UITEXTVIEW DELEGATE
extension AddNewExpDetailVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfWords = newText.wordsCount()
        self.viewModel.clothingRecommendation.value = newText
        return numberOfWords <= 100
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text != nil else  {
            return
        }
        self.updateCharacterCount()
    }
}
extension AddNewExpDetailVC:changeModelType{
    func changeModel() {
        viewModel.modelType = .ItemDetail
    }
}
// MARK: - UITEXTFIELD DELEGATE
extension AddNewExpDetailVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_experience_amount{
            if string.isEmpty { return true }
            
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return replacementText.isValidDouble(maxDecimalPlaces: 2)
        }
        return true
    }
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension AddNewExpDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.activityLevels_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityLevelCell", for: indexPath) as? ActivityLevelCell else{return .init()}
        cell.setCell(activityLevel: viewModel.activityLevels_arr[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.activityLevels_arr = viewModel.activityLevels_arr.map{activityLevel in
            var activityLevel = activityLevel
            activityLevel.isSelected = false
            return activityLevel
        }
        viewModel.activityLevels_arr[indexPath.row].isSelected = true
        activityLevelCV.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let button = UIButton()
        button.setTitle(viewModel.activityLevels_arr[indexPath.row].activityLevel, for: .normal)
        button.titleLabel?.font = UIFont.cabin_Regular(size: 14)
        button.setImage(UIImage(named: "radio"), for: .normal)
        return CGSize(width: button.intrinsicContentSize.width + 10, height: 40)
    }
}

// MARK: - COLLECTIONVIEW CELL
class ActivityLevelCell: UICollectionViewCell{
    @IBOutlet weak var activityLevelBtn: UIButton!
    func setCell(activityLevel: ActivityLevel){
        activityLevelBtn.setTitle(activityLevel.activityLevel, for: .normal)
        activityLevelBtn.setImage(activityLevel.isSelected ? UIImage(named: "radio_active") : UIImage(named: "radio") , for: .normal)
    }
}
