//
//  CreateHomeViewModel.swift
//  BList
//
//  Created by mac11 on 03/08/22.
//

import Foundation

// MARK: - CreateHomeViewModel
struct CreateHomeViewModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: HomeData?
    var httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - HomeData
struct HomeData: Codable {
    let creatorIdentityVerified, businessIdentityVeriied, userIdentityVerified: String?
    let creatorType, role: String?
    let experiences: [Experience]?
    let wishlists: [Wishlist]?
    enum CodingKeys: String, CodingKey {
        case creatorIdentityVerified = "creator_identity_verified"
        case businessIdentityVeriied = "business_identity_veriied"
        case userIdentityVerified = "user_identity_verified"
        case role
        case creatorType = "creator_type"
        case experiences, wishlists
    }
    
    // MARK: - Wishlist
    struct Wishlist: Codable {
        let postContent: String?
        let image: String?
        let userName: String?
        let userImage: String?
        let createdAt: String?
    }
}

// MARK: - Experience
struct Experience: Codable {
    let experienceID, userID, experienceName, expCategory: String?
    let expType, location, willingTravel, willingMessage: String?
    let expDate, expStartDate, expEndDate, expStartTime, expEndTime, blockDates: String?
    let language, expSummary, expDescribe: String?
    let describeLocation, expDuration, expDurationHours, expDurationMinutes, expCreator, creatorPresence: String?
    let creatorPresence1, latitude, longitude, isCancel: String?
    let services, minAgeLimit, maxAgeLimit, minGuestLimit: String?
    let maxGuestLimit, amount, handicapAccessible, handicapDescription: String?
    let activityLevel, expMode, onlineType, clothingRecommendations: String?
    let petAllowed, usersCollab, guestBring, image, coverPic: String?
    let userImage: String?
    let creatorType, status, isAgree: String?
    let isExpDuration, isTimeDuration, slotAvailability, expTimeSlots: String?
    var timeSlotsArray: [String]? {
        return expTimeSlots?.components(separatedBy: ",")
    }
    let weeks: String?
    var expImages:[String]? {
        return image?.components(separatedBy: ",")
    }
    enum CodingKeys: String, CodingKey {
        case experienceID = "experienceId"
        case userID = "user_id"
        case experienceName = "experience_name"
        case expCategory = "exp_category"
        case expType = "exp_type"
        case location, latitude, longitude
        case isCancel = "is_cancel"
        case willingTravel = "willing_travel"
        case willingMessage = "willing_message"
        case expDate = "exp_date"
        case expStartDate = "exp_start_date"
        case expEndDate = "exp_end_date"
        case expStartTime = "exp_start_time"
        case expEndTime = "exp_end_time"
        case language
        case blockDates = "block_dates"
        case expSummary = "exp_summary"
        case expDescribe = "exp_describe"
        case describeLocation = "describe_location"
        case expDuration = "exp_duration"
        case isTimeDuration = "is_time_duration"
        case expTimeSlots = "time_slots"
        case slotAvailability = "is_available"
        case expDurationHours = "exp_duration_hours"
        case expDurationMinutes = "exp_duration_minutes"
        case expCreator = "exp_creator"
        case creatorPresence = "creator_presence"
        case creatorPresence1 = "creator_presence_1"
        case services
        case minAgeLimit = "min_age_limit"
        case maxAgeLimit = "max_age_limit"
        case minGuestLimit = "min_guest_limit"
        case maxGuestLimit = "max_guest_limit"
        case amount
        case handicapAccessible = "handicap_accessible"
        case handicapDescription = "handicap_description"
        case activityLevel = "activity_level"
        case expMode = "exp_mode"
        case onlineType = "online_type"
        case clothingRecommendations = "clothing_recommendations"
        case petAllowed = "pet_allowed"
        case usersCollab = "users_collab"
        case guestBring = "guest_bring"
        case image, userImage
        case coverPic = "cover_img"
        case creatorType = "creator_type"
        case status
        case isAgree = "is_agree"
        case isExpDuration = "is_exp_duration"
        case weeks
    }
}

// MARK: - WishlistDetails
struct WishlistDetails: Codable {
    let id, wishlistLatitude, wishlistLongitude, wishlistComment: String?
    let name, img, distance: String?
    let userID, createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, img, distance
        case wishlistLatitude = "wishlist_latitude"
        case wishlistLongitude = "wishlist_longitude"
        case wishlistComment = "wishlist_comment"
        case userID = "user_id"
        case createdAt = "created_at"
    }
    
}
// MARK: - PromoteExperienceResponseModel
struct PromoteExperienceResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: PromotionDetails?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    // MARK: - PromotionDetails
    struct PromotionDetails: Codable {
        let id, userID, experienceID, promoteAgeFrom: String?
        let promoteAgeTo, promoteGender, promoteLatitude, promoteLongitude: String?
        let promoteMinRadius, promoteMaxRadius, promoteDays, promoteBudget: String?
        let promoteCardID: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case experienceID = "experience_id"
            case promoteAgeFrom = "promote_age_from"
            case promoteAgeTo = "promote_age_to"
            case promoteGender = "promote_gender"
            case promoteLatitude = "promote_latitude"
            case promoteLongitude = "promote_longitude"
            case promoteMinRadius = "promote_min_radius"
            case promoteMaxRadius = "promote_max_radius"
            case promoteDays = "promote_days"
            case promoteBudget = "promote_budget"
            case promoteCardID = "promote_card_id"
        }
    }
}
// MARK: - SeeAllExperiencesResponseModel
struct SeeAllExperiencesResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [ExperienceDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - ExperienceDetails
struct ExperienceDetails: Codable {
    let experienceName, expType, latitude, longitude: String?
    let categoryName, expID: String?
    let image: String?
    let amount, expMode, username, coverImg, userImage: String?
    let status: String?
    var favouriteStatus: Int?
    let totalRatingsCount: Int?
    let averageRating: String?
    let distance: [String]?
    
    enum CodingKeys: String, CodingKey {
        case experienceName = "experience_name"
        case expType = "exp_type"
        case latitude, longitude
        case categoryName = "category_name"
        case expID = "expId"
        case image, amount
        case expMode = "exp_mode"
        case username, userImage, status, favouriteStatus, totalRatingsCount
        case averageRating = "AverageRating"
        case distance
        case coverImg = "cover_img"
    }
}

// MARK: - GetTransactionsResponseModel
struct GetTransactionsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [TransactionDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - TransactionDetails
    struct TransactionDetails: Codable {
        let id, userID, experienceID, noAdults: String?
        let noChildern: String?
        let noInfant: String?
        let fromDate, toDate, fromTime, toTime: String?
        let bookDateTime: String?
        let requestDate, requestTime, isRequestTime: String?
        let paymentMethod, paymentCardID: String?
        let notes: String?
        let isAcceptance, status, notifyStatus, paymentStatus: String?
        let createdAt, amount, transactionID: String?
        let totalRatingsCount: Int?
        let averageRating, expName: String?
        let image: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case experienceID = "experience_id"
            case noAdults = "no_adults"
            case noChildern = "no_childern"
            case noInfant = "no_infant"
            case fromDate = "from_date"
            case toDate = "to_date"
            case fromTime = "from_time"
            case toTime = "to_time"
            case bookDateTime = "book_date_time"
            case requestDate = "request_date"
            case requestTime = "request_time"
            case isRequestTime = "is_request_time"
            case paymentMethod = "payment_method"
            case paymentCardID = "payment_card_id"
            case notes
            case isAcceptance = "is_acceptance"
            case status
            case notifyStatus = "notify_status"
            case paymentStatus = "payment_status"
            case createdAt = "created_at"
            case amount
            case transactionID = "transaction_id"
            case totalRatingsCount
            case averageRating = "AverageRating"
            case expName = "exp_name"
            case image
        }
    }
    
}

// MARK: - GetReviewsResponseModel
struct GetReviewsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [ExperienceDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - ExperienceDetails
    struct ExperienceDetails: Codable {
        let bookingID, experienceID, bookingDate, status: String?
        let experienceName, creatorID, images, minGuestAmount: String?
        let isRating, overallRating, expDescribe, expStartDate: String?
        let expEndDate, creatorName: String?
        let creatorImg: String?
        let categoryName, categoryImage, categoryColor, categoryDescription: String?
        
        enum CodingKeys: String, CodingKey {
            case bookingID = "booking_id"
            case experienceID = "experience_id"
            case bookingDate = "booking_date"
            case status
            case experienceName = "experience_name"
            case creatorID = "creator_id"
            case images
            case minGuestAmount = "min_guest_amount"
            case isRating = "is_rating"
            case overallRating = "overall_rating"
            case expDescribe = "exp_describe"
            case expStartDate = "exp_start_date"
            case expEndDate = "exp_end_date"
            case creatorName = "creator_name"
            case creatorImg = "creator_img"
            case categoryName = "category_name"
            case categoryImage = "category_image"
            case categoryColor = "category_color"
            case categoryDescription = "category_description"
        }
    }
    
}

