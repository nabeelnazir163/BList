//
//  ApiEndPintManager.swift
//  GunInstructor
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

// MARK:- Registration Apis
extension NetworkManager {
    func login(email:String = "", password:String = "",phonecode:String = "",isEmail:Bool = true, completion: @escaping ((Result<UserModel,APIError>) -> Void)) {
        var param = [String:String]()
        if isEmail{
            param = [
                "email"                  : email.trim(),
                "password"               : password.trim(),
                "device_name"            : "ios",
                "device_token"           : AppSettings.fireBaseToken]
        }
        else{
            param = [
                "email"                  : email.trim(),
                "password"               : password.trim(),
                "phonecode"              : phonecode,
                "device_name"            : "ios",
                "device_token"           : AppSettings.fireBaseToken]
        }
        handleAPICalling(request: .logIn(param: param), completion: completion)
    }
    
    func SignUp(fname: String, lname: String, email:String = "", password:String, confirmPassword: String, phone: String, dob: String, gender: String, role: String,creator_type:String, phonecode: String, completion: @escaping ((Result<UserModel,APIError>) -> Void)) {
        let param = [
            "first_name"             : fname.trim(),
            "last_name"              : lname.trim(),
            "email"                  : email.trim(),
            "password"               : password.trim(),
            "confirm_password"       : confirmPassword.trim(),
            "phone"                  : phone.trim(),
            "phonecode"              : phonecode,
            "dob"                    : dob,
            "gender"                 : gender,
            "role"                   : role, // 1 --> User, 2--> Creator
            "creator_type"           : creator_type, // 1 --> Individual, 2 --> Venue
            "device_name"            : "ios",
            "device_token"           : AppSettings.fireBaseToken]
        handleAPICalling(request: .signup(param: param), completion: completion)
    }
    
    func Forgot_Password(email:String = "", completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = ["email" : email]
        handleAPICalling(request: .forgotPassword(param: param), completion: completion)
    }
    
    func otpVerification(otp:String = "", completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = [
            "id":AppSettings.UserInfo?.id ?? "",
            "otp":otp
        ]
        handleAPICalling(request: .verifyOtp(param: param), completion: completion)
    }
    
    func socialLogin(social_type:SignUpType = .Facebook,social_id:String = "", fname: String, lname: String, email: String, creator_type: String, role: String, gender: String, dob: String, phone: String,completion: @escaping ((Result<UserModel,APIError>) -> Void)){
        let param = [
            "social_type":social_type.rawValue,
            "social_id":social_id,
            "email": email,
            "first_name": fname,
            "last_name": lname,
            "phone": phone,
            "dob": dob,
            "gender": gender,
            "role": role, // 1 --> User, 2 --> Creator
            "creator_type": creator_type,
            "device_name": "ios",
            "device_token": AppSettings.fireBaseToken
        ] as [String : Any]
        handleAPICalling(request: .socialLogin(param: param), completion: completion)
    }
    
    func getProfileDetails(completion: @escaping ((Result<UserModel,APIError>) -> Void)) {
        let param = [
            "userid":AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .getProfileDetail(param: param), completion: completion)
    }
    func updateProfile(profile_img : UIImage?, firstName: String, lastName: String, email: String, phone: String, dob: String, bio: String, facebook_url: String, twitter_url: String, instagram_url: String, linkedIn_url: String, website_url: String, identity_type: String, identity_document: UIImage?, completion: @escaping ((Result<UserModel,APIError>) -> Void)) {
        
        let param = [
            "userid"        : AppSettings.UserInfo?.id ?? "",
            "first_name"    : firstName,
            "last_name"     : lastName,
            "email"         : email,
            "phone"         : phone,
            "dob"           : dob,
            "bio"           : bio,
            "facebook_url"  : facebook_url,
            "twitter_url"   : twitter_url,
            "instagram_url" : instagram_url,
            "linkedin_url"  : linkedIn_url,
            "website_url"   : website_url,
            "identity_type" : identity_type
        ] as [String : Any]
        
        handleAPICalling(request: .updateProfile(param: param, profileImg: profile_img, identityDocument: identity_document), completion: completion)
    }
    
    func getTransactions(completion: @escaping ((Result<GetTransactionsResponseModel,APIError>) -> Void)) {
       
        handleAPICalling(request: .getTransactions, completion: completion)
    }
    
    func getReviews(completion: @escaping ((Result<GetReviewsResponseModel,APIError>) -> Void)) {
        let param = [
            "user_id": AppSettings.UserInfo?.id ?? ""
        ] as [String : Any]
        handleAPICalling(request: .getReviews(param: param), completion: completion)
    }
    
    func giveRating(experience_id: String, booking_id: String, message: String, rate: [RatingCategory], tip_amount: String, overall: String, completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        var dic_arr = [[String:String]]()
        for rate in rate {
            var dic = [String:String]()
            dic["name"] = rate.categoryName ?? ""
            dic["count"] = rate.ratingValue
            dic_arr.append(dic)
        }
        let param = [
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "experience_id" : experience_id,
            "booking_id"    : booking_id,
            "message"       : message,
            "rate"          : dic_arr,
            "tip_amount"    : tip_amount,
            "overall"       : overall
        ] as [String : Any]
        handleAPICalling(request: .giveRating(param: param), completion: completion)
    }
    
    func uploadDocument(image : UIImage?,completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        
        let param = [
            "userid": AppSettings.UserInfo?.id ?? ""
        ] as [String : Any]
        handleAPICalling(request: .verifyIdentity(userID: param, image: image), completion: completion)
    }
    
    func creatorHome(completion: @escaping ((Result<CreateHomeViewModel,APIError>) -> Void)) {
        let param = [
            "user_id":AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .creatorHome(param: param), completion: completion)
    }
    
    func shareFeedback(feedback_options: String, message: String, completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = [
            "feedback_options": feedback_options,
            "message" : message
        ]
        handleAPICalling(request: .shareFeedback(param: param), completion: completion)
    }
    
    func addCoverPhoto(coverPic: UIImage?, completion: @escaping ((Result<UserModel,APIError>) -> Void)) {
        handleAPICalling(request: .addCoverPhoto(image: coverPic), completion: completion)
    }
    
    func profileDetails(completion: @escaping ((Result<UserProfileResponseModel,APIError>) -> Void)) {
        handleAPICalling(request: .profileDetails, completion: completion)
    }
    
    //MARK: -  Log out Api implementation
    
    func logout_Api(completion: @escaping ((Result<CreateHomeViewModel,APIError>) -> Void)){
        let param = [
            "user_id":AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .logout(param: param), completion: completion)
    }
}



// MARK:- Settings Apis
extension NetworkManager {
    
}


// MARK: - Creator Apis
extension NetworkManager {
    func getCategories(completion: @escaping ((Result<CategoryListModel,APIError>) -> Void)) {
        handleAPICalling(request: .categories(param: [:]), completion: completion)
    }
    func allCreatorList(completion: @escaping ((Result<AllCreatorModel,APIError>) -> Void)) {
        handleAPICalling(request: .allCreators, completion: completion)
    }
    func searchCreator(creator:String,completion: @escaping ((Result<AllCreatorModel,APIError>) -> Void)) {
        let param = [
            "search":creator]
        handleAPICalling(request: .searchCreator(param: param), completion: completion)
    }
    
    ////exp_start_time
    //exp_end_time
    func addExperience(exp_name:String = "",exp_type:String = "", latitudes: [String], longitudes:[String], cities:[String], states:[String], countries:[String], willing_travel:String = "", willing_message:String = "", exp_date:String = "",exp_start_date:String = "",exp_end_date:String = "", exp_start_time:String = "",exp_end_time:String = "", exp_duration_hours: String = "", exp_duration_minutes:String = "", expSlots: [SlotList], availableDates:[String], blockedDates:[String], exp_summary:String = "",exp_describe:String = "",describe_location:String = "",exp_creator:String = "",customerPresence_alone:String = "",services:String = "",guest_bring:String = "",age_limit:String = "",guest_limit:String = "",min_guest_amount:String = "",handicap_accessible:String = "",handicap_description:String = "",activity_level:[ActivityLevel],exp_mode:String = "",privacyPolicyAgreement:String = "",creatorWillbePresent:String = "",is_cancel :String = "",dicElement : [String:String] = [:],images:[UIImage?] = [],coverPhoto:UIImage?,max_age_limit:String = "",pet_allowed:String = "",max_guest_limit:String = "",clothing_recommendations:String = "",categoryIDs:[String],hasTimeDuration:String = "",slotAvailability:String = "",online_type:[String],weeks:[String], videoURL: URL?, creatorType: String, completion: @escaping ((Result<CreateExperienceModel,APIError>) -> Void)){
        let timeSlots:[String] = expSlots.map{
            return ($0.slotStartTime ?? "") + "-" + ($0.slotEndTime ?? "")
        }
        let activityLevelSelected = activity_level.filter{$0.isSelected == true}.first?.activityLevel.lowercased()
        var param = [
            "creator_type"              :   creatorType,
            "weeks"                     :   weeks.joined(separator: ","),
            "online_type"               :   online_type.joined(separator: ","),
            "user_id"                   :   AppSettings.UserInfo?.id ?? "",
            "exp_name"                  :   exp_name.trim(),
            "exp_type"                  :   exp_type, // 1 -> Both, 2 -> Private, 3 -> Group
            "exp_category"              :   categoryIDs.joined(separator: ","),
            "lat"                       :   latitudes.joined(separator: ","),
            "long"                      :   longitudes.joined(separator: ","),
            "country"                   :   countries.joined(separator: ","),
            "state"                     :   states.joined(separator: ","),
            "city"                      :   cities.joined(separator: ","),
            "willing_travel"            :   willing_travel,
            "willing_message"           :   willing_message.trim(),
            "exp_date"                  :   exp_date,// yes: experience has start and end date
            "is_time_duration"          :   hasTimeDuration == "yes" ? 1 : 0, // yes: experience has duration exp: 4hours
            "exp_start_time"            :   exp_start_time,
            "exp_end_time"              :   exp_end_time,
            "is_available"              :   slotAvailability == "yes" ? 1 : 0,// Timeslot duration yes or no
            "exp_start_date"            :   exp_start_date,
            "exp_end_date"              :   exp_end_date,
            "exp_duration_hours"        :   exp_duration_hours,
            "exp_duration_minutes"      :   exp_duration_minutes,
            "selectdate"                :   availableDates.joined(separator: ","),
            "blockdt"                   :   blockedDates.joined(separator: ","),
            "exp_slot"                  :   timeSlots.joined(separator: ","),
            "exp_time_slot"             :   "",
            "exp_summary"               :   exp_summary.trim(),
            "exp_describe"              :   exp_describe.trim(),
            "describe_location"         :   describe_location.trim(),
            "exp_creator"               :   exp_creator,
            "creator_presence"          :   customerPresence_alone, // Yes --> Customer will experience alone
            "creator_presence_1"        :   creatorWillbePresent, // Yes --> Creator will be present
            "services"                  :   services.trim(),
            "guest_bring"               :   guest_bring.trim(),
            "min_age_limit"             :   age_limit,
            "min_guest_limit"           :   guest_limit,
            "max_age_limit"             :   max_age_limit,
            "max_guest_limit"           :   max_guest_limit,
            "amount"                    :   min_guest_amount,
            "handicap_accessible"       :   handicap_accessible,
            "handicap_description"      :   handicap_description.trim(),
            "activity_level"            :   activityLevelSelected ?? "",
            "exp_mode"                  :   exp_mode,
            "is_cancel"                 :   is_cancel,
            "pet_allowed"               :   pet_allowed,
            "clothing_recommendations"  :   clothing_recommendations.trim(),
            "is_agree"                  :   privacyPolicyAgreement
        ] as [String:Any]
        param.merge(dict: dicElement)
        handleAPICalling(request: .addExperience(param: param, images: images, coverPhoto: coverPhoto, videoURL: videoURL), completion: completion)
    }
    
    func updateExperience(expID:String = "", exp_name:String = "",exp_type:String = "", latitudes: [String], longitudes:[String], willing_travel:String = "", willing_message:String = "", exp_date:String = "",exp_start_date:String = "",exp_end_date:String = "", exp_start_time:String = "",exp_end_time:String = "", exp_duration_hours: String = "", exp_duration_minutes:String = "", expSlots: [SlotList], availableDates:[String], blockedDates:[String], exp_summary:String = "",exp_describe:String = "",describe_location:String = "",exp_creator:String = "",customerPresence_alone:String = "",services:String = "",guest_bring:String = "",age_limit:String = "",guest_limit:String = "",min_guest_amount:String = "",handicap_accessible:String = "",handicap_description:String = "",activity_level:[ActivityLevel],exp_mode:String = "",privacyPolicyAgreement:String = "",creatorWillbePresent:String = "",is_cancel :String = "",dicElement : [String:String] = [:],images:[UIImage?] = [],coverPhoto:UIImage?,max_age_limit:String = "",pet_allowed:String = "",max_guest_limit:String = "",clothing_recommendations:String = "",categoryIDs:[String],hasTimeDuration:String = "",is_available:String = "",online_type:[String],weeks:[String], videoURL: URL?, completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let timeSlots:[String] = expSlots.map{
            return ($0.slotStartTime ?? "") + "-" + ($0.slotEndTime ?? "")
        }
        let activityLevelSelected = activity_level.filter{$0.isSelected == true}.first?.activityLevel.lowercased()
        var param = [
            "exp_id"                    :   expID,
            "weeks"                     :   weeks.joined(separator: ","),
            "online_type"               :   online_type.joined(separator: ","),
            "user_id"                   :   AppSettings.UserInfo?.id ?? "",
            "exp_name"                  :   exp_name.trim(),
            "exp_type"                  :   exp_type, // 1 -> Both, 2 -> Private, 3 -> Group
            "exp_category"              :   categoryIDs.joined(separator: ","),
            "lat"                       :   latitudes.joined(separator: ","),
            "long"                      :   longitudes.joined(separator: ","),
            "willing_travel"            :   willing_travel,
            "willing_message"           :   willing_message.trim(),
            "exp_date"                  :   exp_date,// yes: experience has start and end date
            "exp_start_date"            :   exp_start_date,
            "exp_end_date"              :   exp_end_date,
            "exp_duration_hours"        :   exp_duration_hours,
            "exp_duration_minutes"      :   exp_duration_minutes,
            "selectdate"                :   availableDates.joined(separator: ","),
            "blockdt"                   :   blockedDates.joined(separator: ","),
            "exp_slot"                  :   timeSlots.joined(separator: ","),
            "exp_time_slot"             :   "",
            "exp_summary"               :   exp_summary.trim(),
            "exp_describe"              :   exp_describe.trim(),
            "describe_location"         :   describe_location.trim(),
            "exp_creator"               :   exp_creator,
            "creator_presence"          :   customerPresence_alone, // Yes --> Customer will experience alone
            "creator_presence_1"        :   creatorWillbePresent, // Yes --> Creator will be present
            "services"                  :   services.trim(),
            "guest_bring"               :   guest_bring.trim(),
            "min_age_limit"             :   age_limit,
            "min_guest_limit"           :   guest_limit,
            "max_age_limit"             :   max_age_limit,
            "max_guest_limit"           :   max_guest_limit,
            "amount"                    :   min_guest_amount,
            "handicap_accessible"       :   handicap_accessible,
            "handicap_description"      :   handicap_description.trim(),
            "activity_level"            :   activityLevelSelected ?? "",
            "exp_mode"                  :   exp_mode,
            "is_cancel"                 :   is_cancel,
            "pet_allowed"               :   pet_allowed,
            "clothing_recommendations"  :   clothing_recommendations.trim(),
            "is_available"              :   is_available == "yes" ? 1 : 0,// Timeslot duration yes or no
            "exp_start_time"            :   exp_start_time,
            "exp_end_time"              :   exp_end_time,
            "is_time_duration"          :   hasTimeDuration == "yes" ? 1 : 0, // yes: experience has duration exp: 4hours
            "is_agree"                  :   privacyPolicyAgreement
        ] as [String:Any]
        param.merge(dict: dicElement)
        handleAPICalling(request: .updateExperience(param: param, images: images, coverPhoto: coverPhoto, videoURL: videoURL), completion: completion)
    }
    func switchToUserProfile(completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = [
            "user_id":AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .switchToUserProfile(param: param), completion: completion)
    }
    func switchToCreatorProfile(type : String,completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = [
            "user_id":AppSettings.UserInfo?.id ?? "",
            "type":type
        ]
        print(param)
        handleAPICalling(request: .switchToCreatorProfile(param: param), completion: completion)
    }
    func addCreatorCommission(_ creatorId :String = "",comission :String = "",completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        let param = [
            "creator_id":creatorId,
            "commission":comission
        ]
        handleAPICalling(request: .addCreatorCommission(param: param), completion: completion)
    }
}

// MARK: - User Apis....
extension NetworkManager {
    func userHome(latitude: String, longitude: String, catID: String, city: String, state: String, country: String, completion: @escaping ((Result<UserHomeModel,APIError>) -> Void)) {
        let param = [
            "lat"       : latitude,
            "long"      : longitude,
            "catId"     : catID,
            "city"      : city,
            "state"     : state,
            "country"   : country
        ]
        handleAPICalling(request: .userHome(param: param), completion: completion)
    }
    
    func getBookingList(completion: @escaping ((Result<BookingListModel,APIError>) -> Void)) {
        let param = ["user_id":AppSettings.UserInfo?.id ?? ""]
        handleAPICalling(request: .bookingList(param: param), completion: completion)
    }
    
    func getUsers(expID:String, completion: @escaping ((Result<GetUsersResponseModel,APIError>) -> Void)) {
        let param = ["expId":expID]
        handleAPICalling(request: .getUsers(param: param), completion: completion)
    }
    
    func searchUsers(keyword:String, completion: @escaping ((Result<GetUsersResponseModel,APIError>) -> Void)) {
        let param = ["keyword":keyword]
        handleAPICalling(request: .searchUsers(param: param), completion: completion)
    }
    
    func getFavouritesList(completion: @escaping ((Result<FavouritesListModel,APIError>) -> Void)) {
        let param = ["user_id":AppSettings.UserInfo?.id ?? ""]
        handleAPICalling(request: .getFavouritesList(param: param), completion: completion)
    }
    
    func makeFavourite(expId: String,completion: @escaping ((Result<DoFavouriteModel,APIError>) -> Void)) {
        let param = [
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "experience_id" : expId
        ]
        handleAPICalling(request: .doFavourite(param: param), completion: completion)
    }
    
    func makeUnFavourite(expId: String,completion: @escaping ((Result<DoFavouriteModel,APIError>) -> Void)) {
        let param = [
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "experience_id" : expId
        ]
        handleAPICalling(request: .removeFavourite(param: param), completion: completion)
    }
    
    func getExperienceDetail(expId: String, completion: @escaping ((Result<ExperienceDetailModel,APIError>) -> Void)) {
        handleAPICalling(request: .experienceDetail(expId), completion: completion)
    }
    
    func getBookingDetail(bookingId: String, completion: @escaping ((Result<BookingDetailModel,APIError>) -> Void)) {
        let param = ["booking_id": bookingId]
        handleAPICalling(request: .bookingDetails(param: param), completion: completion)
    }
    
    func active_DeactiveExperience(_ experienceId : String = "",_ isActivate :Bool = false, completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let param = ["experience_id": experienceId]
        if isActivate{
            handleAPICalling(request: .activateExperience(param: param), completion: completion)
        }else{
            handleAPICalling(request: .deActivateExperience(param: param), completion: completion)
        }
    }
    
    func deleteExperience(experienceId : String = "", completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let param = ["expId": experienceId]
        handleAPICalling(request: .deleteExperience(param: param), completion: completion)
    }
    
    func add_Booking(experience_id: String,no_adults:Int = 0,no_childern:Int = 0,no_infant:Int = 0,from_date:String = "",to_date:String = "",payment_method:String = "",notes:String = "",book_date_time:[[String:AnyObject]] = [],request_date:String = "",request_time :String = "", card_id: String, cvv: String, completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let param = [
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "experience_id" : experience_id,
            "no_adults"     : no_adults,
            "no_childern"   : no_childern,
            "no_infant"     : no_infant,
            "from_date"     : from_date,
            "to_date"       : to_date,
            "payment_method": payment_method,
            "notes"         : notes,
            "book_date_time": book_date_time.toJSONArray(),
            "request_time"  : request_time,
            "request_date"  : request_date,
            "card_id"       : card_id,
            "cvv"           : cvv
        ] as [String : Any]
        handleAPICalling(request: .add_bookings(param: param), completion: completion)
    }
    
    func getCardsList(completion: @escaping ((Result<CardListingModel,APIError>) -> Void)){
        handleAPICalling(request: .getCardsList(param: [:]), completion: completion)
        
    }
    
    func addCard(cardNumber: String,cardExpDate:String,cardCity:String,cardState:String,cardCountry:String, cardHolderName:String,cardZipCode:String,completion: @escaping ((Result<CardDetailsModel,APIError>) -> Void)){
        let param = [
            "cardnumber"   : cardNumber,
            "cardexpdate"  : cardExpDate,
            "cardcity"     : cardCity,
            "cardstate"    : cardState,
            "cardcountry"  : cardCountry,
            "cardname"     : cardHolderName,
            "cardzipcode"  : cardZipCode
        ] as [String : Any]
        handleAPICalling(request: .addCard(param: param), completion: completion)
    }
    
    func promoteExp(expId: String = "", fromAge: String = "", toAge: String = "", gender: String = "", latitude: String = "", longitude: String = "", minradius: String = "", maxradius: String = "", runtime: String = "", budget: String = "", cardId: String = "", cvv: String = "", completion: @escaping ((Result<PromoteExperienceResponseModel,APIError>) -> Void)){
        let param = [
            "expId"         : expId,
            "fromAge"       : fromAge,
            "toAge"         : toAge,
            "gender"        : gender,
            "latitude"      : latitude,
            "longitude"     : longitude,
            "minradius"     : minradius,
            "maxradius"     : maxradius,
            "runtime"       : runtime,
            "budget"        : budget,
            "card_id"       : cardId,
            "cvv"           : cvv
        ]
        handleAPICalling(request: .promoteExp(param: param), completion: completion)
    }
    
    func searchExperience(categoryId: String, search:String,completion: @escaping ((Result<SearchExperienceResponseModel,APIError>) -> Void)){
        let param = [
            "search"        : search,
            "expId"         : categoryId
        ] as [String : Any]
        handleAPICalling(request: .searchExp(param: param), completion: completion)
    }
    
    func filter(type: String = "",creator_type:String = "",min_price:String = "",max_price:String = "",date:String = "", location:String = "",experience_type:String = "",time:Bool = false,before_time:String = "",after_time:String = "",latitudes:String,longitudes:String,completion: @escaping ((Result<FilterResultsResponseModel,APIError>) -> Void)){
        let param = [
            "type"              : type,
            "creator_type"      : creator_type,
            "min_price"         : min_price,
            "max_price"         : max_price,
            "date"              : date,
            "location"          : location,
            "lat"               : latitudes,
            "long"              : longitudes,
            "experience_type"   : experience_type,
            "time"              : time ? "1" : "0", // (0 for anytime, 1 for before_time and after_time)
            "before_time"       : before_time, //  (04:00 AM/09:00 PM)
            "after_time"        : after_time
        ] as [String : Any]
        handleAPICalling(request: .filter(param: param), completion: completion)
    }
    
    func otherFilter(creator_type:String = "",creatorId:String = "", keyword:String = "",location:String = "",latitude:String,longitude:String,completion: @escaping ((Result<FilterResultsResponseModel,APIError>) -> Void)){
        let param = [
            "creator_type"      : creator_type,
            "creatorId"         : creatorId,
            "keyword"           : keyword,
            "location"          : location,
            "lat"               : latitude,
            "long"              : longitude
        ] as [String : Any]
        handleAPICalling(request: .otherFilter(param: param), completion: completion)
    }
    
    func postMsg(postContent:String = "", latitude: String = "", longitude: String = "", completion: @escaping ((Result<WishlistAddedResponseModel,APIError>) -> Void)){
        let param = [
            "user_id"           : AppSettings.UserInfo?.id ?? "",
            "lat"               : latitude,
            "long"              : longitude,
            "comment"           : postContent
        ]
        handleAPICalling(request: .postMsg(param: param), completion: completion)
    }
    
    func searchWishlists(latitude: String, longitude: String, keyword: String, completion: @escaping ((Result<GetWishlistsResponseModel,APIError>) -> Void)){
        let param = [
            "lat"       : latitude,
            "long"      : longitude,
            "search"    : keyword
            
        ] as [String : Any]
        handleAPICalling(request: .searchWishList(param: param), completion: completion)
    }
    
    func getNotifications(completion: @escaping ((Result<GetNotificationsResponseModel,APIError>) -> Void)){
        handleAPICalling(request: .getNotifications, completion: completion)
    }
    
    func getAnalytics(_ completion: @escaping ((Result<GetAnalyticsResponseModel,APIError>) -> Void)){
        handleAPICalling(request: .getAnalytics, completion: completion)
    }
    
    func getExperiences(of selectedDate: String, _ completion: @escaping ((Result<GetExperiencesBasedOnDateResponseModel,APIError>) -> Void)){
        let param = [
            "date" : selectedDate
        ] as [String : Any]
        handleAPICalling(request: .getExperiences(param: param), completion: completion)
    }
    
    func updateBlockDates(expID: String, blockDates: String, _ completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let param = [
            "expId" : expID,
            "blockdt": blockDates
        ] as [String : Any]
        handleAPICalling(request: .updateBlockDates(param: param), completion: completion)
    }
    
    func cancelBookings(expID: String, _ completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)){
        let param = [
            "expId" : expID
        ] as [String : Any]
        handleAPICalling(request: .cancelBooking(param: param), completion: completion)
    }
    
    func searchComments(latitude: String, longitude: String, keyword: String, completion: @escaping ((Result<GetPostsResponseModel,APIError>) -> Void)){
        let param = [
            "lat"       : latitude,
            "long"      : longitude,
            "search"    : keyword
        ] as [String : Any]
        handleAPICalling(request: .searchComments(param: param), completion: completion)
    }
    func gpsCheck(autoCheckIn: Int, selectedUserIds: [String]?, manualCheckIn: Int, autoTrack: Int, emergencyEmail: String, emergencyName: String, emergencyPhone: String, bookingId: String, emergency: [EmergencyContactModel],completion: @escaping ((Result<CommonApiModel,APIError>) -> Void)) {
        
        var emergencyDict = [[String:Any]]()
        for each in emergency {
            var dict = [String:Any]()
            dict["emergency_name"] = each.name
            dict["emergency_email"] = each.email
            dict["emergency_phone"] = each.phone
            emergencyDict.append(dict)
        }
        
        var jsonString = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: emergencyDict, options: [])
            jsonString =  String(data: data, encoding: .utf8) ?? ""
        } catch {
            print(error)
        }
        
        let param = [
            "user_id"           : AppSettings.UserInfo?.id ?? "",
            "user_list"         : selectedUserIds?.joined(separator: ",") ?? "",
            "auto_checkin"      : "\(autoCheckIn)",
            "manual_checkin"    : "\(manualCheckIn)",
            "auto_track"        : "\(autoTrack)",
            "emergency_email"   : "",
            "emergency_name"    : "",
            "emergency_phone"   : "",
            "bookingId"         : bookingId,
            "emergency"         : jsonString
        ]
        handleAPICalling(request: .gpsCheck(param: param), completion: completion)
    }
    func postComment(lat: String, long: String, comment: String, image: UIImage?, completion: @escaping ((Result<AddPostResponseModel,APIError>) -> Void)) {
        let param = [
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "post_content"  : comment,
            "lat"           : lat,
            "long"          : long
        ]
        
        let image = [
            "post_image" : image as Any
        ] as [String : Any]
        handleAPICalling(request: .postComment(param: param, image: image), completion: completion)
    }
    func getPostComments(post_id: String, completion: @escaping ((Result<GetPostCommentsResponseModel,APIError>) -> Void)) {
        let param = [
            "post_id"       : post_id
        ]
        handleAPICalling(request: .getPostComments(param: param), completion: completion)
    }
    func likeComment(postID: String, completion: @escaping ((Result<PostLikeOrUnlikeResponseModel,APIError>) -> Void)) {
        let param = [
            "post_id" : postID,
            "user_id" : AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .likeComment(param: param), completion: completion)
    }
    func disLikeComment(postID: String, completion: @escaping ((Result<PostLikeOrUnlikeResponseModel,APIError>) -> Void)) {
        let param = [
            "post_id" : postID,
            "user_id" : AppSettings.UserInfo?.id ?? ""
        ]
        handleAPICalling(request: .disLikeComment(param: param), completion: completion)
    }
    func replyComment(post_id: String, comment:String, completion: @escaping ((Result<ReplyCommentResponseModel,APIError>) -> Void)) {
        let param = [
            "post_id"       : post_id,
            "user_id"       : AppSettings.UserInfo?.id ?? "",
            "comment"       : comment
        ]
        handleAPICalling(request: .replyComment(param: param), completion: completion)
    }
    func newCreatedExperiences(lat:String, long:String, city:String, state:String, country:String, completion: @escaping ((Result<SeeAllExperiencesResponseModel,APIError>) -> Void)) {
        let param = [
            "lat"       : lat,
            "long"      : long,
            "city"      : city,
            "state"     : state,
            "country"   : country
        ]
        handleAPICalling(request: .newCreatedExperiences(param: param), completion: completion)
    }
    func topExperiences(lat:String, long:String, city:String, state:String, country:String, completion: @escaping ((Result<SeeAllExperiencesResponseModel,APIError>) -> Void)) {
        let param = [
            "lat"       : lat,
            "long"      : long,
            "city"      : city,
            "state"     : state,
            "country"   : country
        ]
        handleAPICalling(request: .topExperiences(param: param), completion: completion)
    }
    func blistFeatureList(lat:String, long:String, city:String, state:String, country:String, completion: @escaping ((Result<SeeAllExperiencesResponseModel,APIError>) -> Void)) {
        let param = [
            "lat"       : lat,
            "long"      : long,
            "city"      : city,
            "state"     : state,
            "country"   : country
        ]
        handleAPICalling(request: .blistFeatureList(param: param), completion: completion)
    }
    
}
// MARK: - Chat Apis
extension NetworkManager {
    func getChatMessages(of userID:String, completion: @escaping ((Result<GetChatMessagesResponseModel,APIError>) -> Void)){
        let param = ["otherId"       : userID]
        handleAPICalling(request: .chatList(param: param), completion: completion)
    }
    
    func acceptOrRejectBooking(status: Int, booking: String, completion: @escaping ((Result<AcceptOrRejectBookingResponseModel,APIError>) -> Void)){
        let param = ["status"       : "\(status)",// 1=Accept, 0=Reject
                     "booking"      : booking]
        handleAPICalling(request: .acceptOrRejectBooking(param: param), completion: completion)
    }
    
    func uploadImage(image: UIImage?, completion: @escaping ((Result<SendImageResponseModel,APIError>) -> Void)){
    let param = [
        "img" : image!] as [String: Any]
        handleAPICalling(request: .uploadImage(param:[:], image: param), completion: completion)
    }
}
