//
//  CAddNewExpVC.swift
//  BList
//
//  Created by admin on 27/05/22.
//

import UIKit
import IBAnimatable
import SDWebImage
class CAddNewExpVC: BaseClassVC {
    
    weak var delegate : changeModelType?
    @IBOutlet weak var collection_collab: UICollectionView!
    @IBOutlet weak var stack_collab: UIStackView!
    @IBOutlet weak var stack_Individual: UIStackView!
    @IBOutlet weak var textView_summary: UITextView!
    @IBOutlet weak var textView_experience: UITextView!
    @IBOutlet weak var textView_Location: UITextView!
    @IBOutlet weak var summary_Count:UILabel!
    @IBOutlet weak var experience_Count:UILabel!
    @IBOutlet weak var describeLbl:UILabel!
    weak var creatorVM : CreatorViewModel!
    @IBOutlet var presenceBtns: [UIButton]!
    @IBOutlet var creatorBtns: [AnimatableButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorVM.modelType = .CreateExperience
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for btn in presenceBtns{
            if creatorVM.customerPresence_alone.value == "yes"{
                btn.isSelected = btn.tag == 101 ? true : false
            }
            if creatorVM.creatorWillbePresent.value == "yes"{
                btn.isSelected = btn.tag == 102 ? true : false
            }
        }
        creatorTypeSelection(tag: Int(creatorVM.expCreator.value) ?? 0)
    }
    
    func setData(){
        textView_summary.text = self.creatorVM.expSummary.value
        textView_experience.text = self.creatorVM.expDescription.value
        textView_Location.text = self.creatorVM.expLocationDescription.value
        self.updateCharacterCount()
    }
    
    func updateCharacterCount() {
        let summaryCount = self.textView_summary.text.wordsCount()
        let descriptionCount = self.textView_experience.text.wordsCount()
        let describeCount = self.textView_Location.text.wordsCount()
        self.summary_Count.text    = "\((0) + summaryCount)/50"
        self.describeLbl.text      =  "\((0) + describeCount)/500"
        self.experience_Count.text = "\((0) + descriptionCount)/500"
    }

    
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addMoreUser(_ sender :UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectMemberForCollabVC") as! SelectMemberForCollabVC
        vc.delegate = self
        vc.viewModel = creatorVM
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        self.present(vc, animated:true, completion: nil)
    }
    @IBAction func submit(_ sender : UIButton){
        if creatorVM.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewExpDetailVC") as! AddNewExpDetailVC
            vc.delegate = self
            vc.viewModel = creatorVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: creatorVM.brokenRules.first?.message ?? "")
        }
    }
    
    @IBAction func btnAction(_ sender :AnimatableButton){
        creatorTypeSelection(tag: sender.tag)
    }
    
    func creatorTypeSelection(tag: Int){
        creatorVM.expCreator.value = "\(tag)"
        for btn in creatorBtns{
            if btn.tag == tag{
                btn.borderColor = AppColor.orange
                btn.setTitleColor(AppColor.orange, for: .normal)
            }
            else{
                btn.borderColor = UIColor.init(hexString: "#EFF0F1")
                btn.setTitleColor(UIColor.init(hexString: "#707070"), for: .normal)
            }
        }
        stack_collab.isHidden = tag == 1 ? true : false
        stack_Individual.isHidden = tag == 1 ? false : true
        collection_collab.reloadData()
    }
    @IBAction func cretaorPresence(_ sender :UIButton){
        sender.isSelected = !sender.isSelected
        if sender.tag == 101{
            // Customer will enjoy experience alone
            self.creatorVM.customerPresence_alone.value = sender.isSelected ? "yes" : "no"
        }
        else{
            // Creator will be present
            self.creatorVM.creatorWillbePresent.value = sender.isSelected ? "yes" : "no"
        }
    }
    // customer will enjoy experience alone or creator will present
    func setPresenceVal(){
        
    }
}
extension CAddNewExpVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text != nil else  {
            return
        }
        self.updateCharacterCount()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.wordsCount()
        if textView.tag == 1{
            self.creatorVM.expSummary.value = newText
            return numberOfChars <= 50
        }
        else if textView.tag == 2 {
            self.creatorVM.expDescription.value = newText
            return numberOfChars <= 500
        }
        else if textView.tag == 3{
            self.creatorVM.expLocationDescription.value = newText
            return numberOfChars <= 500
        }
        return true
    }
}
extension CAddNewExpVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let commissionEnteredCreatorsList = creatorVM.commissionEnteredList.filter({$0.commissionEntered && $0.selection})
        return commissionEnteredCreatorsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollabUserCell", for: indexPath) as! CollabUserCell
        let commissionEnteredCreator = creatorVM.commissionEnteredList.filter({$0.commissionEntered && $0.selection})
        if commissionEnteredCreator[indexPath.row].image ?? "" == ""{
            cell.img.image = UIImage.init(named: "place_holder")
        }
        else{
            cell.img.setImage(link: commissionEnteredCreator[indexPath.row].image ?? "")
        }
        
        cell.lbl_percantage.text = "\(commissionEnteredCreator[indexPath.row].commission ?? "")%"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 70)
    }
    
}
extension CAddNewExpVC:changeModelType{
    func changeModel() {
        creatorVM.modelType = .CreateExperience
    }
}
extension CAddNewExpVC:refreshDelegate{
    func refresh() {
        collection_collab.reloadData()
    }
}
class CollabUserCell: UICollectionViewCell {
    @IBOutlet weak var view_Animatable: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_percantage: UILabel!
    
}
