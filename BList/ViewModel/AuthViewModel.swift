//
//  UAuthViewModel.swift
//  ConsignItAway
//
//  Created by appsdeveloper Developer on 09/03/22.
//

import Foundation
import UIKit

class AuthViewModel :NSObject, ViewModel {
    
    var modelType           : ApiType
    var brokenRules         : [BrokenRule]    = [BrokenRule]()
    var lname               : Dynamic<String> = Dynamic("")
    var fname               : Dynamic<String> = Dynamic("")
    var phoneCode           : Dynamic<String> = Dynamic("+91")
    var phone               : Dynamic<String> = Dynamic("")
    var email               : Dynamic<String> = Dynamic("")
    var password            : Dynamic<String> = Dynamic("")
    var confirmPasswrd      : Dynamic<String> = Dynamic("")
    var otp                 : Dynamic<String> = Dynamic("")
    var dob                 : Dynamic<String> = Dynamic("")
    var gender              : Dynamic<String> = Dynamic("")
    var bio                 = ""
    var facebook_url        : Dynamic<String> = Dynamic("")
    var twitter_url         : Dynamic<String> = Dynamic("")
    var instagram_url       : Dynamic<String> = Dynamic("")
    var linkedin_url        : Dynamic<String> = Dynamic("")
    var website_url         : Dynamic<String> = Dynamic("")
    var tipAmount           : Dynamic<String> = Dynamic("")
    var reviewMsg           : Dynamic<String> = Dynamic("")
    var feedbackMsg         = ""
    var feedbackOption      = ""
    var facebookEnabled     = false
    var twitterEnabled      = false
    var instagramEnabled    = false
    var linkedInEnabled     = false
    var websiteEnabled      = false
    var identityType        = ""
    var isEmail = true
    var termsCheck          : Int = 0
    var overallRating       = "0.0"
    var tipYes_No           = "No"
    var ratings             = rateExpQualities
    var verificationCode    = String()
    var socialID            = String()
    var profile_image       : UIImage?
    var coverPhoto          : UIImage?
    var document_image      : UIImage?
    var user_ProfileDetails : UserModel?
    var userDetails         : UserProfileResponseModel?
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
    var isSocialAccountVerified = false
    var userModel               : UserModel?
    var commonApiModel          : CommonApiModel?
    var transactions            : [GetTransactionsResponseModel.TransactionDetails]?
    var reviewedExps            : [GetReviewsResponseModel.ExperienceDetails]?
    var options                 = feedbackOptions
    var expId                   = ""
    var bookingId               = ""
}
extension AuthViewModel {
    private func Validate() {
        switch modelType {
        case .SignIn(type: .Email):
            if isEmail{
                if email.value == "" || email.value == " " {
                    self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter Email"))
                }
                if !email.value.isValidEmail() {
                    self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
                }
            } else {
                if phone.value.isEmptyOrWhitespace() || phone.value.count != 10 {
                    self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Phone Number"))
                }
            }
            if password.value == "" || password.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoPassword", message: "Enter password"))
            }
        case .Forget:
            if email.value == "" || email.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter Email"))
            }
            if !email.value.isValidEmail() {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
            }
            if phone.value.isEmptyOrWhitespace() || phone.value.count != 10 {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Phone Number"))
            }
        case .SignUp(type: .Email, userType: .User):
            if fname.value == "" || fname.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoFirstName", message: "Enter your first name"))
            }
            if lname.value == "" || lname.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoLastName", message: "Enter your last name"))
            }
            if email.value == "" || email.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter your email"))
            }
            if !email.value.isValidEmail() {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
            }
            if phone.value.isEmptyOrWhitespace() || phone.value.count != 10 {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Phone Number"))
            }
            if password.value == "" || password.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoPassword", message: "Enter password"))
            }
            if  password.value.count < 8{
                self.brokenRules.append(BrokenRule(propertyName: "InvalidPassword", message: "Password  has to contain Upper case characters ,number , special character,lower case characters.Password Must be at least 8 Char."))
            }
            if confirmPasswrd.value == "" || confirmPasswrd.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoConfirmPassword", message: "Enter confirm password"))
            }
            if password.value != confirmPasswrd.value {
                self.brokenRules.append(BrokenRule(propertyName: "PasswordNotMatch", message: "Password does not match"))
            }
            if dob.value == "" || dob.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoDob", message: "Select your date of birth"))
            }
            if gender.value == "" || gender.value == " " {
                self.brokenRules.append(BrokenRule(propertyName: "NoGender", message: "Select your gender"))
            }
        case .Otp:
            if otp.value == ""{
                self.brokenRules.append(BrokenRule(propertyName: "NoOTP", message: "Enter OTP here"))
            }
            if otp.value.count < 4{
                self.brokenRules.append(BrokenRule(propertyName: "NoOTP", message: "Enter valid OTP"))
            }
        case .UploadDocument:
            if document_image == nil{
                self.brokenRules.append(BrokenRule(propertyName: "NoDocument", message: "Select your document"))
            }
        case .UpdateProfile:
            if fname.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoFirstName", message: "Enter your first name"))
            }
            if lname.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoLastName", message: "Enter your last name"))
            }
            if email.value.isEmptyOrWhitespace() {
                self.brokenRules.append(BrokenRule(propertyName: "NoEmail", message: "Enter your email"))
            }
            if !email.value.isValidEmail() {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Email"))
            }
            if phone.value.isEmptyOrWhitespace() || phone.value.count != 10 {
                self.brokenRules.append(BrokenRule(propertyName: "InValidEmail", message: "Enter Valid Phone Number"))
            }
            if facebookEnabled && facebook_url.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoFacebookURL", message: "Enter facebook url"))
            }
            if twitterEnabled && twitter_url.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoTwitterURL", message: "Enter twitter url"))
            }
            if instagramEnabled && instagram_url.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoInstagramURL", message: "Enter instagram url"))
            }
            if linkedInEnabled && linkedin_url.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoLinkedInURL", message: "Enter linkedin url"))
            }
            if websiteEnabled && website_url.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoWebsiteURL", message: "Enter website url"))
            }
        case .RateExperienceQualities:
            if tipYes_No == "Yes" && tipAmount.value.isEmptyOrWhitespace(){
                self.brokenRules.append(BrokenRule(propertyName: "NoTip", message: "Please add tip amount"))
            }
        default:
            break
        }
    }
}
// MARK: - Network call
extension AuthViewModel {
    func signIn(type:SignUpType, userType: UserType) {
        isLoading = true
        let model = NetworkManager.sharedInstance
        switch userType {
        case .User:
            switch type {
            case .Email:
                let email = isEmail ? email.value : phone.value
                model.login(email: email, password: password.value,phonecode:phoneCode.value,isEmail: isEmail,completion: { [weak self](result) in
                    guard let self = self else {return}
                    self.isLoading = false
                    switch result{
                    case .success(let res):
                        AppSettings.Token = res.data?.token ?? ""
                        AppSettings.UserInfo = res.data
                        self.printUserDetails(res.data)
                        DispatchQueue.main.async {
                            self.didFinishFetch?(.SignIn(type: .Email))
                        }
                    case .failure(let err):
                        switch err {
                        case .errorReport(let desc, _):
                            print(desc)
                            self.error = desc
                        }
                        print(err.localizedDescription)
                    }
                })
            case .Facebook:
                break
            case .Gmail:
                break
            case .Instagram:
                break
            case .AppleID:
                break
            }
        case .Creator:
            break
        }
    }
    func forgot(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.Forgot_Password(email: email.value){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.commonApiModel = res
                    self.didFinishFetch?(.Forget)
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
    func signUp(type:SignUpType, userType: UserType,creator_type : CreatorType = CreatorType.Individual){
        let creatorType = userType == .User ? "" : "\(creator_type.rawValue)"
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.SignUp(fname: fname.value, lname: lname.value, email: email.value, password: password.value, confirmPassword: confirmPasswrd.value, phone:  phone.value, dob: dob.value, gender: gender.value, role: "\(userType.rawValue)", creator_type: creatorType, phonecode: phoneCode.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                AppSettings.Token = res.data?.token ?? ""
                AppSettings.UserInfo = res.data
                self.printUserDetails(res.data)
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SignUp(type: .Email, userType: userType))
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
    func otpVerification(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.otpVerification(otp: otp.value){ [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.Otp)
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
    func socialLogin(type:SignUpType,social_id : String = "", userType: UserType, creator_type: CreatorType = .Individual){
        let creatorType = userType == .User ? "" : "\(creator_type.rawValue)"
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.socialLogin(social_type: type, social_id: social_id, fname: fname.value, lname: lname.value, email: email.value, creator_type: creatorType, role: "\(userType.rawValue)", gender: gender.value, dob: dob.value, phone: phone.value) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    AppSettings.Token = res.data?.token ?? ""
                    AppSettings.UserInfo = res.data
                    self.didFinishFetch?(.SocialLogin(type: type))
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
    func uploadIdentityDocument(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.uploadDocument(image: document_image) { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    AppSettings.UserInfo?.identityVerified = "1"
                    self.didFinishFetch?(.UploadDocument)
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
    func switchToUserProfile(){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.switchToUserProfile { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let _):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SwitchToUserProfile)
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
    func switchToCreatorProfile(_ type:String){
        isLoading = true
        let model = NetworkManager.sharedInstance
        model.switchToCreatorProfile(type: type)  { [weak self](result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let _):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.SwitchToCreatorProfile)
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
    
    func logout(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.logout_Api { [weak self] (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let _):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.LogOut)
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
    func getProfile_Details(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.getProfileDetails() { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.user_ProfileDetails = res
                AppSettings.Token = res.data?.token ?? ""
                AppSettings.UserInfo = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.None)
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
    
    func updateProfile(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.updateProfile(profile_img: profile_image, firstName: fname.value, lastName: lname.value, email: email.value, phone: phone.value, dob: dob.value, bio: bio, facebook_url: facebook_url.value, twitter_url: twitter_url.value, instagram_url: instagram_url.value, linkedIn_url: linkedin_url.value, website_url: website_url.value, identity_type: identityType, identity_document: document_image) { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.user_ProfileDetails = res
                DispatchQueue.main.async {
                    self.didFinishFetch?(.UpdateProfile)
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
    
    func getTransactions(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.getTransactions() { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.transactions = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.TransactionDetails)
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
    
    func getReviews(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.getReviews() { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.reviewedExps = res.data
                DispatchQueue.main.async {
                    self.didFinishFetch?(.getReviews)
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
    
    func giveRating(){
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.giveRating(experience_id: expId,  booking_id: bookingId, message: reviewMsg.value, rate: ratings, tip_amount: tipAmount.value, overall: overallRating) { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GiveRating)
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
    
    func shareFeedback() {
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.shareFeedback(feedback_options: feedbackOption, message: feedbackMsg) { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.didFinishFetch?(.ShareFeedback)
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
    
    func addCoverPhoto() {
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.addCoverPhoto(coverPic: coverPhoto) { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                AppSettings.UserInfo = res.data
                self.user_ProfileDetails?.data?.coverPic = res.data?.coverPic
                DispatchQueue.main.async {
                    self.didFinishFetch?(.AddCoverPic)
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
    
    func profileDetails() {
        self.isLoading = true
        let model = NetworkManager.sharedInstance
        model.profileDetails() { [weak self]  (result) in
            guard let self = self else {return}
            self.isLoading = false
            switch result{
            case .success(let res):
                self.userDetails = res
                DispatchQueue.main.async {
                    self.didFinishFetch?(.GetProfileDetails)
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
