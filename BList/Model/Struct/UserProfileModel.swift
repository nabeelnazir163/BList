//
//  ProfileModel.swift
//  BList
//
//  Created by iOS Team on 10/05/22.
//

import Foundation

enum ProfileEnum {
    case notifications
    case myBookings
    case help
    case giveFeedback
    case paymentMethod
    case contactUs
    case transaction
    case reviews
    case aboutUs
    case reliability
    case Logout
}

struct ProfileModel {
    let image: String
    let name: String
    let action: ProfileEnum
    
    static func creatorData() -> [ProfileModel] {
        var arr = [ProfileModel]()
        arr.append(ProfileModel(image: "notification", name: "Notifications", action: .notifications))
        arr.append(ProfileModel(image: "booking", name: "My Booking", action: .myBookings))
        arr.append(ProfileModel(image: "help", name: "Get Help", action: .help))
        arr.append(ProfileModel(image: "send_feedback", name: "Give Feedback", action: .giveFeedback))
        arr.append(ProfileModel(image: "payment", name: "Payment method", action: .paymentMethod))
        arr.append(ProfileModel(image: "contact_us", name: "Contact us", action: .contactUs))
        if AppSettings.UserInfo != nil{
            arr.append(ProfileModel(image: "LogOut", name: "LogOut", action: .Logout))
        }
        return arr
    }
    
    static func userData() -> [ProfileModel] {
        var arr = [ProfileModel]()
        arr.append(ProfileModel(image: "notification", name: "Notifications", action: .notifications))
        arr.append(ProfileModel(image: "booking", name: "My Booking", action: .myBookings))
        arr.append(ProfileModel(image: "trasation", name: "Transaction History", action: .transaction))
        arr.append(ProfileModel(image: "help", name: "Help", action: .help))
        arr.append(ProfileModel(image: "reviews", name: "Reviews", action: .reviews))
        arr.append(ProfileModel(image: "send_feedback", name: "Send Feedback", action: .giveFeedback))
        arr.append(ProfileModel(image: "payment", name: "Payment method", action: .paymentMethod))
        arr.append(ProfileModel(image: "contact_us", name: "Contact us", action: .contactUs))
        arr.append(ProfileModel(image: "about_us", name: "About us", action: .aboutUs))
        arr.append(ProfileModel(image: "Reliability", name: "Reliability/Safety Features", action: .reliability))
        if AppSettings.UserInfo != nil{
            arr.append(ProfileModel(image: "LogOut", name: "LogOut", action: .Logout))
        }
       
        return arr
    }
}

struct FeedbackOption {
    let optionName: String?
    var isSelected = false
}
// MARK: - UserProfileResponseModel
struct UserProfileResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: ProfileDetails?
    let experienceData, bookingData: [ExpDetails]?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data, experienceData, bookingData
        case httpStatus = "http_status"
    }
    // MARK: - ProfileDetails
    struct ProfileDetails: Codable {
        let id, firstName, lastName, email: String?
        let chatToken, phonecode, phone, password: String?
        let dob, gender, bio, facebookURL: String?
        let twitterURL, instagramURL, linkedinURL, websiteURL: String?
        let profileImg, identityType, identityDocument, identityVerified: String?
        let userIdentityDocument: String?
        let userIdentityVerified: String?
        let creatorBusinessIdentity: String?
        let businessIdentityVeriied: String?
        let businessImages: String?
        let coverImg, role, creatorType, otp: String?
        let otpVerify: String?
        let status, deviceName, deviceToken: String?
        let socialID, socialType: String?
        let stripeCustomerID, commission, isNotification, createdAt: String?
        let deletedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case email
            case chatToken = "chat_token"
            case phonecode, phone, password, dob, gender, bio
            case facebookURL = "facebook_url"
            case twitterURL = "twitter_url"
            case instagramURL = "instagram_url"
            case linkedinURL = "linkedin_url"
            case websiteURL = "website_url"
            case profileImg = "profile_img"
            case identityType = "identity_type"
            case identityDocument = "identity_document"
            case identityVerified = "identity_verified"
            case userIdentityDocument = "user_identity_document"
            case userIdentityVerified = "user_identity_verified"
            case creatorBusinessIdentity = "creator_business_identity"
            case businessIdentityVeriied = "business_identity_veriied"
            case businessImages = "business_images"
            case coverImg = "cover_img"
            case role
            case creatorType = "creator_type"
            case otp
            case otpVerify = "otp_verify"
            case status
            case deviceName = "device_name"
            case deviceToken = "device_token"
            case socialID = "social_id"
            case socialType = "social_type"
            case stripeCustomerID = "stripe_customer_id"
            case commission
            case isNotification = "is_notification"
            case createdAt = "created_at"
            case deletedAt = "deleted_at"
        }
    }
    
    // MARK: - ExpDetails
    struct ExpDetails: Codable {
        let id, userID, expName, expCategory: String?
        let expType, location, latitude, longitude: String?
        let willingTravel, willingMessage, expDate, expStartDate: String?
        let expEndDate, expStartTime, expEndTime, language: String?
        let expSummary, expDescribe, describeLocation, expDuration: String?
        let isExpDuration, expCreator, usersCollab, creatorPresence: String?
        let creatorPresence1: String?
        let services, guestBring, ageLimit, guestLimit: String?
        let minGuestAmount: String?
        let maxGuestAmount: String?
        let handicapAccessible, handicapDescription, activityLevel, uploadFiles: String?
        let uploadVideoURL, coverImg, expMode, onlineType: String?
        let maxAgeLimit, maxGuestLimit, clothingRecommendations, petAllowed: String?
        let isPromote, isTimeDuration, slotDuration, isAvailable: String?
        let expTimeSlot: String?
        let isAgree: String?
        let isCancel: String?
        let status, weeks, selDate, blockDates: String?
        let timeSlots, expCity, expState, expCountry: String?
        let createdAt, deletedAt, expImage: String?
        let totalRatingsCount: Int?
        let averageRating, categoryName, categoryImage, categoryColor: String?
        let categoryDescription: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case expName = "exp_name"
            case expCategory = "exp_category"
            case expType = "exp_type"
            case location, latitude, longitude
            case willingTravel = "willing_travel"
            case willingMessage = "willing_message"
            case expDate = "exp_date"
            case expStartDate = "exp_start_date"
            case expEndDate = "exp_end_date"
            case expStartTime = "exp_start_time"
            case expEndTime = "exp_end_time"
            case language
            case expSummary = "exp_summary"
            case expDescribe = "exp_describe"
            case describeLocation = "describe_location"
            case expDuration = "exp_duration"
            case isExpDuration = "is_exp_duration"
            case expCreator = "exp_creator"
            case usersCollab = "users_collab"
            case creatorPresence = "creator_presence"
            case creatorPresence1 = "creator_presence_1"
            case services
            case guestBring = "guest_bring"
            case ageLimit = "age_limit"
            case guestLimit = "guest_limit"
            case minGuestAmount = "min_guest_amount"
            case maxGuestAmount = "max_guest_amount"
            case handicapAccessible = "handicap_accessible"
            case handicapDescription = "handicap_description"
            case activityLevel = "activity_level"
            case uploadFiles = "upload_files"
            case uploadVideoURL = "upload_video_url"
            case coverImg = "cover_img"
            case expMode = "exp_mode"
            case onlineType = "online_type"
            case maxAgeLimit = "max_age_limit"
            case maxGuestLimit = "max_guest_limit"
            case clothingRecommendations = "clothing_recommendations"
            case petAllowed = "pet_allowed"
            case isPromote = "is_promote"
            case isTimeDuration = "is_time_duration"
            case slotDuration = "slot_duration"
            case isAvailable = "is_available"
            case expTimeSlot = "exp_time_slot"
            case isAgree = "is_agree"
            case isCancel = "is_cancel"
            case status, weeks
            case selDate = "sel_date"
            case blockDates = "block_dates"
            case timeSlots = "time_slots"
            case expCity = "exp_city"
            case expState = "exp_state"
            case expCountry = "exp_country"
            case createdAt = "created_at"
            case deletedAt = "deleted_at"
            case expImage, totalRatingsCount
            case averageRating = "AverageRating"
            case categoryName = "category_name"
            case categoryImage = "category_image"
            case categoryColor = "category_color"
            case categoryDescription = "category_description"
        }
    }
}


