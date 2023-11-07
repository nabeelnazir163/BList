//
//  NewExperienceVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import IBAnimatable

class NewExperienceVC: BaseClassVC {
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet var views: [AnimatableView]!
    var creatorVM: CreatorViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorVM.modelType = .kindOfExperience
        for each in views {
            let tap = UITapGestureRecognizer(target: self, action: #selector(actionViews(tap:)))
            each.addGestureRecognizer(tap)
        }
        if let expDetails = creatorVM.expDetails{
            setUpDataModel(expDetails: expDetails)
        }
        else{
            creatorVM = CreatorViewModel(type: .kindOfExperience)
        }
    }
    func setUpDataModel(expDetails: Experience){
        setUpUI(index: expDetails.expMode == "Online" ? 0 : 1)
        creatorVM.experienceTitle.value = expDetails.experienceName ?? ""
        creatorVM.experienceType.value = expDetails.expType ?? ""
        creatorVM.latitudes = (expDetails.latitude ?? "").components(separatedBy: ",")
        creatorVM.longitudes = (expDetails.longitude ?? "").components(separatedBy: ",")
        creatorVM.willingToTravel.value = expDetails.willingTravel ?? ""
        creatorVM.willingMessage.value = expDetails.willingMessage ?? ""
        creatorVM.chooseLanguage = (expDetails.language ?? "").components(separatedBy: ",").map({$0.decode()})
        creatorVM.hasStartEndDate.value = expDetails.expDate ?? ""
        creatorVM.expStartDate.value = expDetails.expStartDate ?? ""
        creatorVM.expEndDate.value = expDetails.expEndDate ?? ""
        creatorVM.expStartTime.value = expDetails.expStartTime ?? ""
        creatorVM.expEndTime.value = expDetails.expEndTime ?? ""
        creatorVM.exp_duration_hours.value = expDetails.expDurationHours ?? ""
        creatorVM.exp_duration_minutes.value = expDetails.expDurationMinutes ?? ""
        creatorVM.timeSlots.removeAll()
        for timeSlot in expDetails.timeSlotsArray ?? [] {
            let timeSlotDuration = timeSlot.components(separatedBy: "-")
            creatorVM.timeSlots.append(SlotList(slotStartTime: timeSlotDuration.first, slotEndTime: timeSlotDuration.last, isSelected: false))
        }
        
        let days = (expDetails.weeks ?? "").components(separatedBy: ",")
        for day in days {
            if let index = creatorVM.days.firstIndex(where: {$0.dayName == day}){
                creatorVM.days[index].selection = true
            }
        }
        creatorVM.blockDates = (expDetails.blockDates ?? "").components(separatedBy: ",")
        creatorVM.expSummary.value = expDetails.expSummary ?? ""
        creatorVM.expDescription.value = expDetails.expDescribe ?? ""
        creatorVM.expLocationDescription.value = expDetails.describeLocation ?? ""
        creatorVM.expCreator.value = expDetails.expCreator ?? ""
        creatorVM.customerPresence_alone.value = expDetails.creatorPresence ?? "" // Customer Presence
        creatorVM.creatorWillbePresent.value = expDetails.creatorPresence1 ?? ""
        creatorVM.services.value = expDetails.services ?? ""
        creatorVM.requireToBring.value = expDetails.guestBring ?? ""
        creatorVM.clothingRecommendation.value = expDetails.clothingRecommendations ?? ""
        creatorVM.minAgeLimit.value = expDetails.minAgeLimit ?? ""
        creatorVM.maxAgeLimit.value = expDetails.maxAgeLimit ?? ""
        creatorVM.minGuestLimit.value = expDetails.minGuestLimit ?? ""
        creatorVM.maxGuestlimit.value = expDetails.maxGuestLimit ?? ""
        creatorVM.experienceAmount.value = expDetails.amount ?? ""
        creatorVM.isPetAllow.value = expDetails.petAllowed ?? ""
        creatorVM.handicapAccessible.value = expDetails.handicapAccessible ?? ""
        creatorVM.handicapDescription.value = expDetails.handicapDescription ?? ""
        creatorVM.isCancel.value = expDetails.isCancel ?? ""
        creatorVM.hasTimeDuration.value = expDetails.isTimeDuration ?? "0" == "1" ? "yes" : "no"
        creatorVM.slotAvailability.value = expDetails.slotAvailability ?? "0" == "1" ? "yes" : "no"
        creatorVM.activityLevels_arr[0].isSelected = false
        if let index = creatorVM.activityLevels_arr.firstIndex(where: { $0.activityLevel == (expDetails.activityLevel ?? "").capitalized
        }){
            creatorVM.activityLevels_arr[index].isSelected = true
        }
        Task{
            creatorVM.media = []
            if let expImages = expDetails.expImages {
                for img in expImages {
                    if let image = await downloadImage(from: BaseURLs.experience_Image.rawValue + (img)){
                        let media = Media(mediaType: "Image", image: image, video: nil)
                        creatorVM.media.append(media)
                    }
                }
            }
            if let coverPic = expDetails.coverPic {
                if let image = await downloadImage(from: BaseURLs.experience_Image.rawValue + (coverPic)){
                    creatorVM.coverPhoto = image
                }
            }
        }
        creatorVM.privacyPolicyAgreement.value = expDetails.isAgree ?? ""
    }
    func setUpUI(index:Int){
        if index == 0{
            images[0].image = UIImage.init(named: "Online_active")
            images[1].image = UIImage.init(named: "Inperson_inactive")
        }
        else{
            images[1].image = UIImage.init(named: "Inperson_active")
            images[0].image = UIImage.init(named: "Online_inactive")
        }
        creatorVM.kindOfExperience.0 = index == 0 ? "Online" : "In Person"
        views.forEach({$0.borderColor = UIColor(hexString: "#EFF0F1")})
        views[index].borderColor = UIColor(named: "AppOrange")
        labels.forEach({$0.textColor = UIColor(named: "#190000")})
        labels[index].textColor = UIColor(named: "AppOrange")
        if creatorVM.kindOfExperience.0 == "Online"{
            let vc = UIStoryboard.loadAddNewExperienceVC()
            vc.creatorVM = creatorVM
            vc.closureWithData = {[weak self] data in
                guard let self = self else{return}
                self.creatorVM.kindOfExperience.1 = data
                self.actionContinue()
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
        else{
            actionContinue()
        }
    }
    @objc func actionViews(tap: UITapGestureRecognizer) {
        let tag = tap.view?.tag ?? -1
        setUpUI(index: tag)
    }
    
    func actionContinue() {
        if creatorVM.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DescribeYourExperienceVC") as! DescribeYourExperienceVC
            vc.delegate = self
            vc.creatorVM = creatorVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: creatorVM.brokenRules.first?.message ?? "")
        }
    }
    
}
extension NewExperienceVC:DismissViewDelegate{
    func dismissView(_ type: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DescribeYourExperienceVC") as! DescribeYourExperienceVC
        vc.creatorVM = self.creatorVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension NewExperienceVC:changeModelType{
    func changeModel() {
        creatorVM.modelType = .kindOfExperience
    }
}
