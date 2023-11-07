//
//  UserViewModel.swift
//  BList
//
//  Created by mac11 on 04/08/22.
//

import Foundation
import UIKit
import CoreLocation

class UserViewModel :NSObject, ViewModel {
    var modelType           : ApiType
    var brokenRules         : [BrokenRule]    = [BrokenRule]()
    var experienceTitle     : Dynamic<String> = Dynamic("")
    var kindOfExperience    : (String,[String])  = ("",[])
    var startDate           : Dynamic<String> = Dynamic("")
    var willingMessage      : Dynamic<String> = Dynamic("")
    var endDate             : Dynamic<String> = Dynamic("")
    var experienceType      : Dynamic<String> = Dynamic("")
    var willingToTravel     : Dynamic<String> = Dynamic("no")
    var isStartEndDate      : Dynamic<String> = Dynamic("no")
    var chooseLanguage       = [String]()
    var expSummary          : Dynamic<String> = Dynamic("")
    var experience          : Dynamic<String> = Dynamic("")
    var location            : Dynamic<String> = Dynamic("")
    var duration            : Dynamic<String> = Dynamic("")
    var createPresence_alone: Dynamic<String> = Dynamic("")
    var createPresence_present: Dynamic<String> = Dynamic("")
    var exp_creator         : Dynamic<String> = Dynamic("1")
    var item                : Dynamic<String> = Dynamic("")
    var requireToBring      : Dynamic<String> = Dynamic("")
    var ageLimit            : Dynamic<String> = Dynamic("")
    var guestLimit          : Dynamic<String> = Dynamic("")
    var minGuestAmount      : Dynamic<String> = Dynamic("")
    var maxGuestAmount      : Dynamic<String> = Dynamic("")
    var handicapAccessible  : Dynamic<String> = Dynamic("no")
    var handicap_description: Dynamic<String> = Dynamic("")
    var activity_level      : Dynamic<String> = Dynamic("none")
    var privacyPolicy       : Dynamic<String> = Dynamic("no")
    var is_cancel           : Dynamic<String> = Dynamic("")
    var latitude            = ""
    var longitude           = ""
    var country             = ""
    var state               = ""
    var city                = ""
    var locationName        = ""
    
    // COMMENT
    var comment             = ""
    var commentImg          : UIImage?
    var commentID           = ""
    var replyComment        : Dynamic<String> = Dynamic("")
    
    // FILTER
    var catID               = ""
    var type                = ""
    var creator_type        = ""
    var min_price           = ""
    var max_price           = "10"
    var date                = ""
    var filter_location     = ""
    var other_location      = ""
    var experience_type     = [String]()
    var expIds              = [String]()
    var time                = true
    var before_time         = ""
    var after_time          = ""
    var maxDate             = Date()
    var filterLatitude      = ""
    var filterLongitude     = ""
    var otherLatitude       = ""
    var otherLongitude      = ""
    var latitudes           = [String]()
    var longitudes          = [String]()
    var countries           = [String]()
    var states              = [String]()
    var cities              = [String]()
    var creatorId           : Dynamic<String> = Dynamic("")
    var keyword             : Dynamic<String> = Dynamic("")
    var otherLocation       = false
    var noOfChild           = 0{
        didSet{
            calculateGuestCount()
        }
    }
    var noOfInfant          = 0{
        didSet{
            calculateGuestCount()
        }
    }
    var noOfAdult           = 0{
        didSet{
            calculateGuestCount()
        }
    }
    var guestCount          = 0
    var startDateSlot       : Dynamic<String> = Dynamic("")
    var endDateSlot         : Dynamic<String> = Dynamic("")
    var startTimeSlot       : Dynamic<String> = Dynamic("")
    var endTimeSlot         : Dynamic<String> = Dynamic("")
    var requestDate         = ""
    var requestTime         = ""
    var notes               : Dynamic<String> = Dynamic("")
    var cardNumber          : Dynamic<String> = Dynamic("")
    var cardHolderName      : Dynamic<String> = Dynamic("")
    var cardCity            : Dynamic<String> = Dynamic("")
    var zipCode             : Dynamic<String> = Dynamic("")
    var cardExpDate         : Dynamic<String> = Dynamic("")
    var search              : Dynamic<String> = Dynamic("")
    var postContent         : Dynamic<String> = Dynamic("")
    var cvv                 = ""
    var card_id             = ""
    var cardState           = ""
    var cardCountry         = ""
    var categoryId          = ""
    
    // GPS Check
    var name                : Dynamic<String> = Dynamic("")
    var phoneCode           = "+91"
    var phone               : Dynamic<String> = Dynamic("")
    var emailId             : Dynamic<String> = Dynamic("")
    var autoCheckIn         = 0
    var manualCheckIn       = 0
    var autoTrack           = 0
    
    var users_collab        = [String]()
    var location_arr        = [String]()
    var images              = [UIImage]()
    var isEmail = true
    var termsCheck          : Int = 0
    var verificationCode    = String()
    var socialID            = String()
    var userImage           : UIImage?
    var postImage           : UIImage?
    var time_SlotList       = [TimeSlotData]()
    var selectedTimeSlot    = [[String:AnyObject]]()
    var creatorTypes_arr    = creatorTypes
    var fav_unfavExp        : DoFavouriteModel.ExpDetails?
    var searchExpModel      : SearchExperienceResponseModel?
    var categories          = [Category]()
    var postComments        = [PostDetails]()
    var filteredExperienceResults : [FilterResultsResponseModel.FilteredExperienceDetails]?
    var seeAllExperiences   = [ExperienceDetails]()
    var cardsList = [CardDetails](){
        didSet{
            print(cardsList)
        }
    }
    var cardDetails: CardDetails?
    var homeData                = [UserHomeData]()
    var bookingTypes            : BookingListModel.BookingTypes?
    var favouritesList          = [FavouritesListModel.ExpDetails]()
    var bookingDetails          : BookingDetails?
    var expDetail               : ExperienceModel?
    var experiences             : [SearchExperienceResponseModel.ExperienceDetails]?
    var wishLists               = [WishlistDetails]()
    var posts                   = [postDetails]()
    var searchedUsers           = [GetUsersResponseModel.Users]()
    var selectedUsers           = [GetUsersResponseModel.Users]()
    var selectedUserIds         = [String]()
    var isValid             : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didGetApiResponse: (() -> Void)?
    var didFinishFetch: ((ApiType) -> ())?
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
    
    
}
extension UserViewModel {
    private func Validate() {
        switch modelType {
        case .UserHome:
            break
        case .ChooseAvailableDate:
            if selectedTimeSlot.isEmpty {
                self.brokenRules.append(BrokenRule(propertyName: "NoSlots", message: "Choose a time slot"))
            }
            if let minGuest = Int(expDetail?.expDetail?.minGuestLimit ?? "0"), guestCount < minGuest{
                self.brokenRules.append(BrokenRule(propertyName: "MinGuestLimit", message: "Add minimum \(minGuest) guests"))
            }
        case .ChooseMember:
            if let minGuest = Int(expDetail?.expDetail?.minGuestLimit ?? "0"), guestCount < minGuest{
                self.brokenRules.append(BrokenRule(propertyName: "MinGuestLimit", message: "Add minimum \(minGuest) guests"))
            }
        case .AddCard:
            if cardNumber.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardNumber", message: "Please enter your card number"))
            }
            if cardNumber.value.replacingOccurrences(of: " ", with: "").count != 16 {
                self.brokenRules.append(BrokenRule(propertyName: "InValidCard", message: "Please enter valid card number"))
            }
            if cardHolderName.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardHolderName", message: "Please enter card holder name"))
            }
            if cardExpDate.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardExpDate", message: "Please enter card expiry date"))
            }
            if cardCountry.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardCountry", message: "Please select your country"))
            }
            if cardState.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardState", message: "Please select your state"))
            }
            if cardCity.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardCity", message: "Please enter your city"))
            }
            if zipCode.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoZipCode", message: "Please enter your zipcode"))
            }
        case .Filter:
            /*
             if let typeIds = creatorTypes_arr[0].types?.filter({$0.isSelected == true}).map({String($0.typeID)}).joined(separator: ","){
                 self.type = typeIds
             }
             else{
                 self.brokenRules.append(BrokenRule(propertyName: "NoType", message: "Please select a type"))
             }
             if let creatorType = creatorTypes_arr[1].types?.filter({$0.isSelected == true}).map({String($0.typeID)}).joined(separator: ","){
                 self.creator_type = String(creatorType)
             }
             else{
                 self.brokenRules.append(BrokenRule(propertyName: "NoCreatorType", message: "Please select a creator type"))
             }
             
             if min_price.isEmptyOrWhitespace(){
                 self.brokenRules.append(BrokenRule(propertyName: "NoMinPrice", message: "Please select a minimum price"))
             }
             if max_price.isEmptyOrWhitespace(){
                 self.brokenRules.append(BrokenRule(propertyName: "NoMaxPrice", message: "Please select a maximum price"))
             }
             if date.isEmptyOrWhitespace(){
                 self.brokenRules.append(BrokenRule(propertyName: "NoDate", message: "Please select a date"))
             }
             if location.value.isEmptyOrWhitespace(){
                 self.brokenRules.append(BrokenRule(propertyName: "NoLocation", message: "Please enter location"))
             }
             if categories.filter({$0.isSelected == true}).first == nil{
                 self.brokenRules.append(BrokenRule(propertyName: "NoExperienceType", message: "Please select an experience type"))
             }
             else{
                 experience_type = categories.filter({$0.isSelected == true}).map({$0.id ?? ""})
             }
             */
            
            
            if time == false && before_time.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoBeforeTime", message: "Please enter before time"))
            }
            if time == false && after_time.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoAfterTime", message: "Please enter after time"))
            }
        case .OtherFilter:
            break
            
        case .AddBooking:
            if cardsList.isEmpty{
                self.brokenRules.append(BrokenRule(propertyName: "NoCard", message: "Please add a card to make payment"))
            }
            if card_id.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoCardID", message: "Please select a card to make payment"))
            }
            
        case .GPSCheck:
            if name.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoName", message: "Enter name"))
            }
            if phone.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoPhone", message: "Enter phone"))
            }
            if emailId.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter email"))
            }
            if !emailId.value.isValidEmail(){
                self.brokenRules.append(BrokenRule(propertyName: "InvalidEmail", message: "Enter valid email"))
            }
            
        default:
            break
        }
    }
}
// MARK: - Network call
extension UserViewModel {
    func calculateGuestCount(){
        guestCount = noOfChild + noOfInfant + noOfAdult
    }
    func userHome(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.userHome(latitude: latitude, longitude: longitude, catID: catID, city: "", state: "", country: country) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
//            self.didGetApiResponse?()
            switch result{
            case .success(let res):
                self.homeData = res.data ?? []
                DispatchQueue.main.async {
                    if let expID = res.autoCheckEnableExpID, !expID.isEmptyOrWhitespace() {
                        let expID = ["expId": expID]
                        NotificationCenter.default.post(name: NSNotification.Name(K.NotificationKeys.autoCheckIn), object: expID)
                    }
                    self.didFinishFetch?(.UserHome)
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
    func getBookings(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getBookingList(){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.bookingTypes = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetBookingList)
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
    
    func searchUsers() {
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.searchUsers(keyword: keyword.value){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.searchedUsers = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SearchUsers)
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
    func getExperienceDetail(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getExperienceDetail(expId: expIds.last ?? "") { [weak self](result) in
            guard let self = self else {return}
            
            switch result{
            case .success(let res):
                self.expDetail = res.data
                self.expDetail?.expDetail?.formattedOnlineTypes = (res.data?.expDetail?.onlineType ?? "").components(separatedBy: ",")
                let formattedDate = (res.data?.expDetail?.language ?? "").components(separatedBy: ",").map{$0.decode()}.joined(separator: ", ")
                self.expDetail?.expDetail?.formattedLanguage = formattedDate
                if res.data?.expDetail?.expDate ?? "no" == "no"{
                    self.expDetail?.expDetail?.currentDate = DateConvertor.shared.convert(date: Date(), format: .EEEddMMM).dateInString
                }
                let latitudes = (res.data?.expDetail?.latitude ?? "").components(separatedBy: ",")
                let longitudes = (res.data?.expDetail?.longitude ?? "").components(separatedBy: ",")
                
                if latitudes.count == longitudes.count{
                    var coordinates = [CLLocationCoordinate2D]()
                    for i in 0..<latitudes.count{
                        coordinates.append(CLLocationCoordinate2D.init(latitude: Double(latitudes[i]) ?? 0, longitude: Double(longitudes[i]) ?? 0))
                    }
                    let locationCoordinates = coordinates
                    self.expDetail?.expDetail?.coordinates = coordinates
                    Task{
                        var locations = [String]()
                        for try await location in Locations(coordinates: locationCoordinates){
                            if let city_state_country = location.city_state_country {
                                locations.append(LocationManager.shared.appendAddress(components: city_state_country))
//                                break
                            }
                        }
                        self.expDetail?.expDetail?.formattedLocations = locations.joined(separator: " | ")
                        self.isLoading = false
                        self.didFinishFetch?(.ExperienceDetails)
                    }
                }
                else{
                    self.isLoading = false
                    self.didFinishFetch?(.ExperienceDetails)
                }
                
                
                
                /*
                 let locations:[String] = self.expDetail?.expDetail?.location?.components(separatedBy: "|") ?? []
                 for i in 0...locations.count-1{
                 let location_Components = locations[i].components(separatedBy: ", ")
                 if location_Components.count > 2{
                 if Int(location_Components.last ?? "") != nil{
                 self.expDetail?.expDetail?.formattedLocations.append(location_Components[location_Components.count-3 ... location_Components.count-2].joined(separator: ", "))
                 self.expDetail?.expDetail?.coordinates.append(CLLocationCoordinate2D.init(latitude: Double(latitudes[i]) ?? 0, longitude: Double(longitudes[i]) ?? 0))
                 }
                 else{
                 self.expDetail?.expDetail?.formattedLocations.append(location_Components[location_Components.count-2 ... location_Components.count-1].joined(separator: ", "))
                 self.expDetail?.expDetail?.coordinates.append(CLLocationCoordinate2D.init(latitude: Double(latitudes[i]) ?? 0, longitude: Double(longitudes[i]) ?? 0))
                 }
                 }
                 
                 }*/
            case .failure(let err):
                self.isLoading = false
                switch err {
                case .errorReport(let desc, _):
                    print(desc)
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    func getFavouritesList(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getFavouritesList(){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.favouritesList = res.data ?? []
                    self.didFinishFetch?(.FavouriteExperiencesList)
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
    func makeFavourite(expId: String){
        //isLoading = true
        let model = NetworkManager.sharedInstance
        model.makeFavourite(expId: expId){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.fav_unfavExp = res.data
                self.error = "Experience added to favourites"
                DispatchQueue.main.async {
                    self.didFinishFetch?(.MakeFavourite)
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
    
    func makeUnFavourite(expId: String){
        //isLoading = true
        let model = NetworkManager.sharedInstance
        model.makeUnFavourite(expId: expId){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.fav_unfavExp = res.data
                self.error = "Experience removed from favourites"
                DispatchQueue.main.async {
                    self.didFinishFetch?(.MakeUnFavourite)
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
    
    func getBookingDetail(bookingId:String){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getBookingDetail(bookingId: bookingId){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.bookingDetails = res.data
                    self.didFinishFetch?(.GetBookingDetails)
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
    
    func add_Bookig(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.add_Booking(experience_id: expDetail?.expDetail?.expID ?? "", no_adults: noOfAdult, no_childern: noOfChild, no_infant: noOfInfant, from_date: startDateSlot.value, to_date: endDateSlot.value, payment_method: "card", notes: notes.value,book_date_time: selectedTimeSlot,request_date: requestDate,request_time: requestTime, card_id: card_id, cvv: cvv) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.error = res.message ?? ""
                if res.success == 1 {
                    DispatchQueue.main.async {
                        self.didFinishFetch?(.AddBooking)
                    }
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
    
    func cardList(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getCardsList() { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.cardsList = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetCardsList)
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
    
    func addCard(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.addCard(cardNumber: cardNumber.value, cardExpDate: cardExpDate.value, cardCity: cardCity.value, cardState: cardState, cardCountry: cardCountry, cardHolderName: cardHolderName.value, cardZipCode: zipCode.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if let cardDetails = res.data{
                    self.cardsList.append(cardDetails)
                }
                DispatchQueue.main.async {
                    self.didFinishFetch?(.AddCard)
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
    
    func searchExperience(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.searchExperience(categoryId: categoryId, search: search.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if let selectedCategory = self.searchExpModel?.categories?.filter({$0.isSelected == true}).first{
                    self.searchExpModel = res
                    if let index = self.searchExpModel?.categories?.firstIndex(where: { cat in
                        cat.id == selectedCategory.id
                    }){
                        self.searchExpModel?.categories?[index].isSelected = true
                    }
                }
                else{
                    self.searchExpModel = res
                }
                self.experiences = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SearchExperience)
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
    
    func filter(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.filter(type: type, creator_type: creator_type, min_price: min_price, max_price: max_price, date: date, location: filter_location,experience_type: categories.filter({$0.isSelected == true}).map({$0.id ?? ""}).joined(separator: ","), time: time, before_time: before_time, after_time: after_time, latitudes: filterLatitude, longitudes: filterLongitude) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.filteredExperienceResults = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.Filter)
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
    
    func otherFilter(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.otherFilter(creator_type: creator_type, creatorId: creatorId.value, keyword: keyword.value, location: other_location, latitude: otherLatitude, longitude: otherLongitude) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.filteredExperienceResults = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.OtherFilter)
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
    
    func getCategories(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getCategories { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if !self.categories.isEmpty{
                    if let filterSelectedCat = self.categories.filter({$0.isSelected}).first{
                        self.categories = res.data ?? []
                        if let index = res.data?.firstIndex(where: { cat in
                            cat.id == filterSelectedCat.id
                        }){
                            self.categories[index] = filterSelectedCat
                        }
                    }
                }
                else{
                    self.categories = res.data ?? []
                }
                DispatchQueue.main.async {
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
    
    func postMsg(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.postMsg(postContent: postContent.value, latitude: latitude, longitude: longitude) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if let post = res.data{
                    self.wishLists.append(post)
                }
                DispatchQueue.main.async {
                    self.didFinishFetch?(.PostContent)
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
        model.searchWishlists(latitude: latitude, longitude: longitude, keyword: "") { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.wishLists = res.data ?? []
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
    
    func searchComments(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.searchComments(latitude: latitude, longitude: longitude, keyword: keyword.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.posts = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SearchComments)
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
    func gpsCheck(bookingId: String, emergency: [EmergencyContactModel]){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.gpsCheck(autoCheckIn: autoCheckIn, selectedUserIds: selectedUserIds, manualCheckIn: manualCheckIn, autoTrack: autoTrack, emergencyEmail: emailId.value, emergencyName: name.value, emergencyPhone: phoneCode + phone.value, bookingId: bookingId, emergency: emergency){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.error = res.message ?? ""
                    self.didFinishFetch?(.GPSCheck)
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
    func postComment(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.postComment(lat: latitude, long: longitude, comment: comment, image: commentImg){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if let comment = res.data{
                    self.posts.append(comment)
                }
                DispatchQueue.main.async {
                    self.didFinishFetch?(.PostComment)
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
    func getPostComments(postID: String){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.getPostComments(post_id: postID){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.postComments = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.getPostComments)
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
    func likeComment(postID: String){
        //isLoading = true
        let model = NetworkManager.sharedInstance
        model.likeComment(postID: postID){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.LikeComment)
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
    func disLikeComment(postID: String){
        //isLoading = true
        let model = NetworkManager.sharedInstance
        model.disLikeComment(postID: postID){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.DisLikeComment)
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
    func replyComment(postID: String){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.replyComment(post_id: postID, comment: replyComment.value){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                if let comment = res.data{
                    self.postComments.append(comment)
                }
                DispatchQueue.main.async {
                    self.didFinishFetch?(.ReplyComment)
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
    func newCreatedExperiences(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.newCreatedExperiences(lat: latitude, long: longitude, city: city, state: state, country: country){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.seeAllExperiences = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.NewCreatedExperiences)
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
    func topExperiences(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.topExperiences(lat: latitude, long: longitude, city: city, state: state, country: country){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.seeAllExperiences = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.TopExperiences)
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
    func blistFeatureList(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.blistFeatureList(lat: latitude, long: longitude, city: city, state: state, country: country){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.seeAllExperiences = res.data ?? []
                DispatchQueue.main.async {
                    self.didFinishFetch?(.BlistFeatureList)
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
