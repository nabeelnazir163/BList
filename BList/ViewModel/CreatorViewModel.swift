//
//  CreatorViewModel.swift
//  BList
//
//  Created by iOS Team on 21/07/22.
//

import Foundation
import UIKit

class CreatorViewModel :NSObject, ViewModel {
    
    var modelType                   : ApiType
    var brokenRules                 : [BrokenRule]    = [BrokenRule]()
    var experienceTitle             : Dynamic<String> = Dynamic("")
    var kindOfExperience            : (String,[String])  = ("",[])
            
    var expStartDate                : Dynamic<String> = Dynamic("")
    var expEndDate                  : Dynamic<String> = Dynamic("")
    var expStartTime                : Dynamic<String> = Dynamic("")
    var expEndTime                  : Dynamic<String> = Dynamic("")
            
    var exp_duration_days           : Dynamic<String> = Dynamic("")
    var exp_duration_hours          : Dynamic<String> = Dynamic("")
    var exp_duration_minutes        : Dynamic<String> = Dynamic("")
    
    var days:[Day] = daysInWeek
    //var weekIds = [Int]()
    var timeSlots                   = [SlotList]()
    var mentionedWeekDatesInString  = [String]()
    var blockDates                  = [String]()
    var blockedDaysString           = [String]()
    var blockedDays                 = [Date]()
    var selectedDate                = ""
    
    
    var willingMessage              : Dynamic<String> = Dynamic("")
    var experienceType              : Dynamic<String> = Dynamic("")
    var willingToTravel             : Dynamic<String> = Dynamic("no")
    var isPetAllow                  : Dynamic<String> = Dynamic("no")
    var hasStartEndDate             : Dynamic<String> = Dynamic("no")
    var hasTimeDuration             : Dynamic<String> = Dynamic("no")
    var slotAvailability            : Dynamic<String> = Dynamic("no")
    var chooseLanguage              = [String]()
    
    var clothingRecommendation      : Dynamic<String> = Dynamic("")
    var expSummary                  : Dynamic<String> = Dynamic("")
    var expDescription              : Dynamic<String> = Dynamic("")
    var expLocationDescription      : Dynamic<String> = Dynamic("")
    var state                       = ""
    var country                     = ""
    
    // Add Commission
    var creatorId                   = ""
    var commission                  = ""
    var customerPresence_alone      : Dynamic<String> = Dynamic("no")
    var creatorWillbePresent        : Dynamic<String> = Dynamic("no")
    var expCreator                  : Dynamic<String> = Dynamic("1")
    var services                    : Dynamic<String> = Dynamic("")
    var requireToBring              : Dynamic<String> = Dynamic("")
    var minAgeLimit                 : Dynamic<String> = Dynamic("")
    var maxAgeLimit                 : Dynamic<String> = Dynamic("")
    var minGuestLimit               : Dynamic<String> = Dynamic("")
    var maxGuestlimit               : Dynamic<String> = Dynamic("")
    var experienceAmount            : Dynamic<String> = Dynamic("")
    var handicapAccessible          : Dynamic<String> = Dynamic("no")
    var handicapDescription         : Dynamic<String> = Dynamic("")
    var privacyPolicyAgreement      : Dynamic<String> = Dynamic("no")
    var isCancel                    : Dynamic<String> = Dynamic("")
    var creator                     : Dynamic<String> = Dynamic("")
    var budget                      : Dynamic<String> = Dynamic("")
    var keyword                     : Dynamic<String> = Dynamic("")
    var cvv                         = ""
    var gender                      = [String]()
    var minradius                   = ""
    var maxradius                   = ""
    var runtime                     = ""
    var expId                       = ""
    var cardId                      = ""
    var users_collab            = [String]()
    var activityLevels_arr      = activityLevels
    var location_arr            = [String]()
    var latitudes               = [String]()
    var longitudes              = [String]()
    var cities                  = [String]()
    var states                  = [String]()
    var countries               = [String]()
    var location_coordinates    = [String]()
    var media                   = [Media]()
    var coverPhoto              : UIImage?
    var isEmail                 = true
    var termsCheck              : Int = 0
    var verificationCode        = String()
    var socialID                = String()
    var userImage               : UIImage?
    var isValid                 : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: ((ApiType) -> ())?
    var didActivateDeactivateResult: (() -> ())?
    init(type:ApiType) {
        modelType = type
    }
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    //Firebase Auth User ID
    var userID : String? {
        didSet {
            guard let _ = userID else { return }
            self.didFinishFetch?(.None)
        }
    }
    var isSocialAccountVerified = false
    var userModel               : UserModel?
    var categories              = [Category]()
    var allCreatorList          = [CreatorData]()
    var commissionEnteredList   = [CreatorData]()
    var commonApiModel          : CommonApiModel?
    var identityVerified        : String?
    var experiences             : [Experience]?
    var expDetails              : Experience?
    var wishLists               : [WishlistDetails]?
    var analytics               : GetAnalyticsResponseModel.Analytics?
    var analyticsData           : [AnalyticsData]?
    var expBasedOnDate          : [GetExperiencesBasedOnDateResponseModel.Experience]?
}
extension CreatorViewModel {
    private func Validate() {
        switch modelType {
        case .SelectKindOfExperience:
            if kindOfExperience.0 == "" || (kindOfExperience.0 != "" && kindOfExperience.1.count == 0){
                self.brokenRules.append(BrokenRule(propertyName: "NoExperience", message: "Please select kind of experience which you want to create"))
            }
        case .DescribeExperience:
            if experienceTitle.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoExperienceTitle", message: "Enter your experience title"))
            }
            if categories.filter({$0.isSelected == true}).count == 0{
                self.brokenRules.append(BrokenRule(propertyName: "NoCategory", message: "please select atleast 1 category"))
            }
            if experienceType.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoExperienceType", message: "Please select experience type"))
            }
            if kindOfExperience.0 != "Online" && location_arr.count == 0{
                self.brokenRules.append(BrokenRule(propertyName: "NoLocation", message: "Please enter location"))
            }
            if willingToTravel.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoWillingTravel", message: "Please select willing to travel"))
            }
        case .ChooseLanguage:
            if chooseLanguage.count == 0 {
                self.brokenRules.append(BrokenRule(propertyName: "NoLanguage", message: "Please select langauage"))
            }
        case .CreateExperienceWithDateAndTime:
            if hasStartEndDate.value == "yes" && expStartDate.value == ""{
                self.brokenRules.append(BrokenRule(propertyName: "NoStart", message: "Please select start date"))
            }
            if hasStartEndDate.value == "yes" && expEndDate.value == ""{
                self.brokenRules.append(BrokenRule(propertyName: "NoEnd", message: "Please select end date"))
            }
            if hasStartEndDate.value == "yes" && expStartTime.value == ""{
                self.brokenRules.append(BrokenRule(propertyName: "NoStart", message: "Please select start time"))
            }
            if hasStartEndDate.value == "yes" && expEndTime.value == ""{
                self.brokenRules.append(BrokenRule(propertyName: "NoStart", message: "Please select end time"))
            }
            if hasTimeDuration.value == "yes" && exp_duration_hours.value.isEmptyOrWhitespace() && exp_duration_minutes.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoStart", message: "Please enter experience duration hours and minutes"))
            }
            if slotAvailability.value == "yes" && timeSlots.count == 0{
                self.brokenRules.append(BrokenRule(propertyName: "NoStart", message: "Please enter experience time slots"))
            }
            if days.filter({$0.selection == true}).first == nil{
                self.brokenRules.append(BrokenRule(propertyName: "NoAvailableDays", message: "Please select avaialble days"))
            }
        case .CreateExperience:
            if expSummary.value == "" || expSummary.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoSummary", message: "Please enter experience summary"))
            }
            if expDescription.value == "" || expDescription.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoxperienceDescripton", message: "Please enter experience description"))
            }
            if expLocationDescription.value == "" || expLocationDescription.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoLocation", message: "Please describe location"))
            }
        case .ItemDetail:
            if services.value == "" || services.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoItem", message: "Please enter Item"))
            }
            if requireToBring.value == "" || requireToBring.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoRequired", message: "Please enter guest required to brings"))
            }
            if clothingRecommendation.value == "" || clothingRecommendation.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoClothingRecommendation", message: "Please enter clothing recommendation"))
            }
            if minAgeLimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoAge", message: "Please enter min age limit"))
            }
            if maxAgeLimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoMaxAge", message: "Please enter max age limit"))
            }
            if Int(minAgeLimit.value) ?? 0 > Int(maxAgeLimit.value) ?? 0{
                self.brokenRules.append(BrokenRule(propertyName: "InvalidMinAge", message: "Minimum age limit is exceeding maximum age limit"))
            }
            if minGuestLimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoGuestLimit", message: "Please enter min guest limit"))
            }
            if maxGuestlimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoMaxGuestLimit", message: "Please enter max guest limit"))
            }
            if Int(minGuestLimit.value) ?? 0 > Int(maxGuestlimit.value) ?? 0{
                self.brokenRules.append(BrokenRule(propertyName: "InvalidMinGuestLimit", message: "Minimum guest limit is exceeding maximum guest limit"))
            }
            if experienceAmount.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoExperienceAmount", message: "Please enter experience amount"))
            }
        case .Policy:
            if isCancel.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoPolicy", message: "Please select a cancellation policy"))
            }
            if privacyPolicyAgreement.value == "no"{
                self.brokenRules.append(BrokenRule(propertyName: "NoPolicy", message: "Please agree to the policy agreement to publish"))
            }
        case .PromoteExperience:
            if minAgeLimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoFromAge", message: "Please enter minimum age"))
            }
            if maxAgeLimit.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoToAge", message: "Please enter maximum age"))
            }
            if Int(minAgeLimit.value) ?? 0 > Int(maxAgeLimit.value) ?? 0{
                self.brokenRules.append(BrokenRule(propertyName: "InvalidMinAge", message: "Minimum age should be less than maximum age"))
            }
            if gender.count == 0{
                self.brokenRules.append(BrokenRule(propertyName: "NoGender", message: "Please select gender"))
            }
            if location_arr.isEmpty && minradius.isEmptyOrWhitespace() && maxradius.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoLocationOrRange", message: "Please enter either location or pick raidus target"))
            }
            if runtime.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoRuntime", message: "Please select runtime"))
            }
            if budget.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoBudget", message: "Please enter budget"))
            }
        default:
            break
        }
    }
}
// MARK: - Network call
extension CreatorViewModel {
    func getCategories(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getCategories { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.categories = res.data ?? []
                    self.didFinishFetch?(.Categories)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func allCreator_List(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.allCreatorList  { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.filterCommissionEnteredList()
                self.allCreatorList = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.CreatorsList)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func searchCreator(){
//        isLoading = true
        let model = NetworkManager.sharedInstance
        model.searchCreator(creator: creator.value)  { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.filterCommissionEnteredList()
                self.allCreatorList = res.data?.filter({$0.role == "2"}) ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SearchCreator)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func filterCommissionEnteredList(){
        let filteredList = self.allCreatorList.filter({$0.commissionEntered})
        if filteredList.count > 0{
            for creator in filteredList{
                if let index = self.commissionEnteredList.firstIndex(where: { creatorData in
                    creatorData.id == creator.id
                }){
                    self.commissionEnteredList[index] = creator
                }
                else{
                    self.commissionEnteredList.append(creator)
                }
            }
        }
    }
    
    func addExperience(){
        var users_collab    = [String:String]()
        var language        = [String:String]()
        let daysInWeekArr = days.filter{$0.selection}.map{$0.dayName}
        let categoryIDs  = (categories.filter{$0.isSelected}).map{$0.id ?? ""}
        var hours = ""
        var minutes = ""
        if hasTimeDuration.value == "yes"{
            hours = exp_duration_hours.value == "" ? "" : (exp_duration_hours.value == "1" ? "\(exp_duration_hours.value) hour" :"\(exp_duration_hours.value) hours")//"\(txt_hours.text!) hours"
            minutes = exp_duration_minutes.value == "" ? "" : (exp_duration_minutes.value == "1" ? "\(exp_duration_minutes.value) minute" :"\(exp_duration_minutes.value) minutes")
        }
        blockDates.forEach { blockedDate in
            mentionedWeekDatesInString.removeAll { selectedDate in
                selectedDate == blockedDate
            }
        }
        if self.users_collab.count == 0{
            users_collab = ["users_collab[]":""]
        }
        else{
            users_collab = convertdata(self.users_collab, key: "users_collab")
        }
        language = convertdata(self.chooseLanguage, key: "language")
        users_collab.merge(dict: language)
        if hasStartEndDate.value == "no"{
            expStartDate.value.removeAll()
            expEndDate.value.removeAll()
            expStartTime.value.removeAll()
            expEndTime.value.removeAll()
        }
        let creatorType = AppSettings.UserInfo?.creatorType ?? ""
        let ttype = creatorType == "1" ? "individual_creator" : (creatorType == "2" ? "venues" : "")
        
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.addExperience(exp_name: experienceTitle.value, exp_type: experienceType.value, latitudes: latitudes, longitudes: longitudes, cities: cities, states: states, countries: countries, willing_travel: willingToTravel.value, willing_message: willingMessage.value, exp_date: hasStartEndDate.value, exp_start_date: expStartDate.value, exp_end_date: expEndDate.value, exp_start_time: expStartTime.value,exp_end_time: expEndTime.value, exp_duration_hours: hours, exp_duration_minutes: minutes, expSlots: timeSlots, availableDates: mentionedWeekDatesInString, blockedDates: blockDates, exp_summary: expSummary.value, exp_describe: expDescription.value, describe_location: expLocationDescription.value, exp_creator: expCreator.value, customerPresence_alone: customerPresence_alone.value, services: services.value, guest_bring: requireToBring.value, age_limit: minAgeLimit.value, guest_limit: minGuestLimit.value, min_guest_amount: experienceAmount.value, handicap_accessible: handicapAccessible.value, handicap_description: handicapDescription.value, activity_level: activityLevels_arr, exp_mode: kindOfExperience.0, privacyPolicyAgreement: privacyPolicyAgreement.value, creatorWillbePresent: creatorWillbePresent.value, is_cancel: isCancel.value, dicElement: users_collab, images: media.filter({$0.mediaType == "Image"}).map({$0.image}), coverPhoto: coverPhoto,max_age_limit: maxAgeLimit.value,pet_allowed: isPetAllow.value,max_guest_limit: maxGuestlimit.value,clothing_recommendations: clothingRecommendation.value,categoryIDs:categoryIDs,hasTimeDuration: hasTimeDuration.value,slotAvailability: slotAvailability.value, online_type: kindOfExperience.1,weeks: daysInWeekArr, videoURL: media.filter({$0.mediaType == "Video"}).map{$0.video!}.first, creatorType: ttype) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.PostExperience)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func updateExperience(){
        var users_collab    = [String:String]()
        var language        = [String:String]()
        let daysInWeekArr = days.filter{$0.selection}.map{$0.dayName}
        let categoryIDs  = (categories.filter{$0.isSelected}).map{$0.id ?? ""}
        var hours = ""
        var minutes = ""
        if hasTimeDuration.value == "yes"{
            hours = exp_duration_hours.value == "" ? "" : (exp_duration_hours.value == "1" ? "\(exp_duration_hours.value) hour" :"\(exp_duration_hours.value) hours")//"\(txt_hours.text!) hours"
            minutes = exp_duration_minutes.value == "" ? "" : (exp_duration_minutes.value == "1" ? "\(exp_duration_minutes.value) minute" :"\(exp_duration_minutes.value) minutes")
        }
        blockDates.forEach { blockedDate in
            mentionedWeekDatesInString.removeAll { selectedDate in
                selectedDate == blockedDate
            }
        }
        if self.users_collab.count == 0{
            users_collab = ["users_collab[]":""]
        }
        else{
            users_collab = convertdata(self.users_collab, key: "users_collab")
        }
        language = convertdata(self.chooseLanguage, key: "language")
        users_collab.merge(dict: language)
        if hasStartEndDate.value == "no"{
            expStartDate.value.removeAll()
            expEndDate.value.removeAll()
            expStartTime.value.removeAll()
            expEndTime.value.removeAll()
        }
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.updateExperience(expID:expDetails?.experienceID ?? "",exp_name: experienceTitle.value, exp_type: experienceType.value, latitudes: latitudes, longitudes: longitudes, willing_travel: willingToTravel.value, willing_message: willingMessage.value, exp_date: hasStartEndDate.value, exp_start_date: expStartDate.value, exp_end_date: expEndDate.value, exp_start_time: expStartTime.value,exp_end_time: expEndTime.value, exp_duration_hours: hours, exp_duration_minutes: minutes, expSlots: timeSlots, availableDates: mentionedWeekDatesInString, blockedDates: blockDates, exp_summary: expSummary.value, exp_describe: expDescription.value, describe_location: expLocationDescription.value, exp_creator: expCreator.value, customerPresence_alone: customerPresence_alone.value, services: services.value, guest_bring: requireToBring.value, age_limit: minAgeLimit.value, guest_limit: minGuestLimit.value, min_guest_amount: experienceAmount.value, handicap_accessible: handicapAccessible.value, handicap_description: handicapDescription.value, activity_level: activityLevels_arr, exp_mode: kindOfExperience.0, privacyPolicyAgreement: privacyPolicyAgreement.value, creatorWillbePresent: creatorWillbePresent.value, is_cancel: isCancel.value, dicElement: users_collab, images: media.filter({$0.mediaType == "Image"}).map({$0.image}), coverPhoto: coverPhoto, max_age_limit: maxAgeLimit.value,pet_allowed: isPetAllow.value,max_guest_limit: maxGuestlimit.value,clothing_recommendations: clothingRecommendation.value,categoryIDs:categoryIDs,hasTimeDuration: hasTimeDuration.value,is_available: slotAvailability.value, online_type: kindOfExperience.1,weeks: daysInWeekArr, videoURL: media.filter({$0.mediaType == "Video"}).map{$0.video!}.first) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.UpdateExperience)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func addCommission(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.addCreatorCommission(creatorId, comission: commission) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.AddCreatorCommission)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func creatorHomeDetail(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.creatorHome() { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.identityVerified = res.data?.creatorIdentityVerified ?? ""
                self.experiences = res.data?.experiences
                DispatchQueue.main.async {
                    self.didFinishFetch?(.CreatorHome)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func active_deactiveExperience(_  isActivate : Bool,experience_id:String?){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.active_DeactiveExperience(experience_id ?? "", isActivate) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success( _):
                DispatchQueue.main.async {
                    self.didActivateDeactivateResult?()
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func deleteExperience(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.deleteExperience(experienceId: expId) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success( _):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.DeleteExperience)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func promoteExp(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        if minradius == "0" && maxradius == "0"{
            minradius = ""
            maxradius = ""
        }
        model.promoteExp(expId: expId, fromAge: minAgeLimit.value, toAge: maxAgeLimit.value, gender: gender.joined(separator: ","), latitude: latitudes.joined(separator: ","), longitude: longitudes.joined(separator: ","), minradius: minradius, maxradius: maxradius, runtime: runtime, budget: budget.value, cardId: cardId, cvv: cvv) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success( _):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.PromoteExperience)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func searchWishlists(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.searchWishlists(latitude: latitudes.joined(separator: ","), longitude: longitudes.joined(separator: ","), keyword: keyword.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.wishLists = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SearchWishlists)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getNotifications() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getNotifications() { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.getNotifications)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getAnalytics() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getAnalytics() { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result {
            case .success(let res):
                self.analyticsData = [
                    AnalyticsData(sectionName: "", incomeInDays: IncomeInDays(last_7: res.data?.lastSevenDays, last_30: res.data?.lastThirtyDays, last_365: res.data?.lastOneYear)),
                    AnalyticsData(sectionName: "", topExperiences: res.data?.topExperience),
                    AnalyticsData(sectionName: "My Experiences", myExperiences: res.data?.myExperience),
                    AnalyticsData(sectionName: "Demographic Data"),
                    AnalyticsData(sectionName: "Experience Ratings")
                ]
                self.analytics = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetAnalytics)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getExperiences() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getExperiences(of: selectedDate) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.expBasedOnDate = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetExperiencesBasedOnDate)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func updateBlockDates() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.updateBlockDates(expID: expId, blockDates: blockDates.joined(separator: ",")) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.updateBlockDates)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func cancelBookings() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.cancelBookings(expID: expId) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.cancelBooking)
                }
            case .failure(let err):
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
}



