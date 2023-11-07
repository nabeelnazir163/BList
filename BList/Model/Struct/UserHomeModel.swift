//
//  UserHomeModel.swift
//  BList
//
//  Created by mac11 on 04/08/22.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - UserHomeModel
struct UserHomeModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [UserHomeData]?
    let autoCheckin, manualCheckin, autoTrack, autoCheckEnableExpID: String?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
        case autoCheckin = "auto_checkin"
        case manualCheckin = "manual_checkin"
        case autoTrack = "auto_track"
        case autoCheckEnableExpID = "auto_check_enable_exp_id"
    }
}

// MARK: - UserHomeData
struct UserHomeData: Codable {
    var name: String?
    var type: Int?
    var items: [HomeItem]?
}

// MARK: - Item
struct HomeItem: Codable {
    var experienceName, expType, categoryName, expID: String?
    let latitude, longitude:String?
    var image: String?
    var amount: String?
    var username: String?
    var userImage: String?
    var status: String?
    let expMode: String?
    var totalRatingsCount: Int?
    var averageRating: String?
    var favouriteStatus: Int?
    let distance: [String]?
    let coverPhoto: String?
    var expTypeName: String{
        get{
            //1 => Both , 2 => Private, 3 => Group, 4 => Inperson, 5=>Online, 0=>All
            switch expType{
            case "0": return "All"
            case "1": return "Both"
            case "2": return"Private"
            case "3": return"Group"
            case "4": return"Inperson"
            case "5": return"Online"
            default: return ""
            }
        }
    }
    enum CodingKeys: String, CodingKey {
        case experienceName = "experience_name"
        case categoryName = "category_name"
        case expID = "expId"
        case image, amount, username, userImage, status,favouriteStatus
        case expType = "exp_type"
        case averageRating = "AverageRating"
        case totalRatingsCount
        case latitude, longitude
        case expMode = "exp_mode"
        case distance
        case coverPhoto = "cover_img"
    }
}
// MARK: - SearchExperienceResponseModel
struct SearchExperienceResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: [ExperienceDetails]?
    var categories: [Category]?
    let httpStatus: Int?
    
    // MARK: - ExperienceDetails
    struct ExperienceDetails: Codable {
        let id, expName, expCategory, location: String?
        let latitude, longitude, uploadFiles, minGuestAmount, expMode: String?
        let maxGuestAmount: String?
        let totalRatingsCount: Int?
        let averageRating: String?
        var favouriteStatus: Int?
        var coordinates = [CLLocationCoordinate2D]()
        
        enum CodingKeys: String, CodingKey {
            case id
            case expName = "exp_name"
            case expCategory = "exp_category"
            case location, latitude, longitude
            case uploadFiles = "upload_files"
            case minGuestAmount = "min_guest_amount"
            case maxGuestAmount = "max_guest_amount"
            case totalRatingsCount
            case averageRating = "AverageRating"
            case favouriteStatus
            case expMode = "exp_mode"
        }
    }
    enum CodingKeys: String, CodingKey {
        case success, error, message, data, categories
        case httpStatus = "http_status"
    }
}
// MARK: - Category
struct Category: Codable {
    let id, name, image, color, description, createdAt: String?
    var isSelected = false
    enum CodingKeys: String, CodingKey {
        case id, name, image, color, description
        case createdAt = "created_at"
    }
}
// MARK: - FilterResultsResponseModel
struct FilterResultsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [FilteredExperienceDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - FilteredExperienceDetails
    struct FilteredExperienceDetails: Codable {
        let id, userID, expName, expCategory: String?
        let expType, location, latitude, longitude: String?
        let willingTravel, willingMessage, expDate, expStartDate: String?
        let expEndDate, expStartTime, expEndTime, language: String?
        let expSummary, expDescribe, describeLocation, expDuration: String?
        let isExpDuration: String?
        let expCreator, usersCollab, creatorPresence: String?
        let creatorPresence1: String?
        let services, guestBring, ageLimit, guestLimit: String?
        let minGuestAmount: String?
        let maxGuestAmount: String?
        let handicapAccessible, handicapDescription, activityLevel, uploadFiles: String?
        let expMode, onlineType, maxAgeLimit, maxGuestLimit: String?
        let clothingRecommendations, petAllowed, isPromote, isTimeDuration: String?
        let slotDuration: String?
        let isAvailable, expTimeSlot, isAgree, isCancel: String?
        let status, weeks, selDate, blockDates: String?
        let timeSlots, createdAt, deletedAt, expID: String?
        let categoryName, experienceName, username, amount, coverImg: String?
        var favouriteStatus: Int?
        
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
            case createdAt = "created_at"
            case deletedAt = "deleted_at"
            case expID = "expId"
            case categoryName = "category_name"
            case experienceName = "experience_name"
            case coverImg = "cover_img"
            case username, amount, favouriteStatus
        }
    }
    
}

// MARK: - WishlistAddedResponseModel
struct WishlistAddedResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let data: WishlistDetails?
    let message: String?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, data, message
        case httpStatus = "http_status"
    }
}
// MARK: - GetWishlistsResponseModel
struct GetWishlistsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [WishlistDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
// MARK: - GetPostsResponseModel
struct GetPostsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: [postDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - GetExperiencesBasedOnDateResponseModel
struct GetExperiencesBasedOnDateResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [Experience]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - Experience
    struct Experience: Codable {
        let id, userID, expName, fromDate, expDate: String?
        let toDate, uploadFiles, coverPhoto, price, weeks: String?
        var blockDates: String?
        let isBooking: Int?
        var weekDayIDs:[Int]{
            var weekDayIDs = [Int]()
            if let weekDays = weeks?.components(separatedBy: ",") {
                for week in weekDays {
                    if let dayID = DayInWeek(rawValue: week)?.dayId() {
                        weekDayIDs.append(dayID)
                    }
                }
                weekDayIDs = weekDayIDs.sorted(by: {$0 < $1})
            }
            return weekDayIDs
        }
        let image: String?
        var isSelection = false
        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case expName = "exp_name"
            case fromDate = "from_date"
            case toDate = "to_date"
            case uploadFiles = "upload_files"
            case price, weeks
            case blockDates = "block_dates"
            case image
            case expDate = "exp_date"
            case coverPhoto = "cover_img"
            case isBooking = "isBooking"
        }
    }
}




// MARK: - AddPostResponseModel
struct AddPostResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: postDetails?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
// MARK: - postDetails
struct postDetails: Codable {
    let id, userID, postContent, postImage: String?
    let postLat, postLong, status, createdAt: String?
    var yourLike: String?
    var likesCount, dislikesCount: Int?
    let commentsCount: Int?
    let name, image, distance: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postContent = "post_content"
        case postImage = "post_image"
        case postLat = "post_lat"
        case postLong = "post_long"
        case status
        case createdAt = "created_at"
        case yourLike = "your_like"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case dislikesCount = "dislikes_count"
        case name, image, distance
    }
}
// MARK: - PostLikeOrUnlikeResponseModel
struct PostLikeOrUnlikeResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: PostDetails?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    // MARK: - PostDetails
    struct PostDetails: Codable {
        let userID, postID, doLike: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case postID = "post_id"
            case doLike = "do_like"
        }
    }
}

// MARK: - GetPostCommentsResponseModel
struct GetPostCommentsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: [PostDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
}
// MARK: - PostDetails
struct PostDetails: Codable {
    let id, userID, postID, comment, createdAt: String?
    let name, profileImg: String?
    let yourLike: Int?
    let postContent, postImage: String?
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postID = "post_id"
        case comment
        case createdAt = "created_at"
        case name
        case yourLike = "your_like"
        case postContent = "post_content"
        case postImage = "post_image"
        case profileImg = "profile_img"
    }
}
struct ReplyCommentResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: PostDetails?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}


// MARK: - GetAnalyticsResponseModel
struct GetAnalyticsResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: Analytics?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - Analytics
    struct Analytics: Codable {
        let lastSevenDays, lastThirtyDays, lastOneYear: String?
        let topExperience: [TopExperience]?
        let myExperience: [MyExperience]?
    }
    
    // MARK: - MyExperience
    struct MyExperience: Codable {
        let id, userID, expName, expCategory: String?
        let expType, location, latitude, longitude: String?
        let willingTravel, willingMessage, expDate, expStartDate: String?
        let expEndDate, expStartTime, expEndTime, language: String?
        let expSummary, expDescribe, describeLocation, expDuration: String?
        let isExpDuration: String?
        let expCreator, usersCollab, creatorPresence: String?
        let creatorPresence1: String?
        let services, guestBring, ageLimit, guestLimit: String?
        let minGuestAmount: String?
        let maxGuestAmount: String?
        let handicapAccessible, handicapDescription, activityLevel, uploadFiles: String?
        let uploadVideoURL, coverImg, expMode, onlineType: String?
        let maxAgeLimit, maxGuestLimit, clothingRecommendations, petAllowed: String?
        let isPromote, isTimeDuration: String?
        let slotDuration: String?
        let isAvailable, expTimeSlot, isAgree, isCancel: String?
        let status, weeks, selDate, blockDates: String?
        let timeSlots, createdAt, deletedAt, categoryName: String?
        let categoryImage: String?
        let totalRatingsCount: Int?
        let averageRating: String?
        let message, rate: String?
        
        //        let totalFavorite: Int?
        //        let ageRange: String?
        //        let similar: [String: String]?
        var rate_arr: [RatingDetails]? {
            guard rate?.isEmpty == false else {return nil}
            let rate_dic = convert(text: rate ?? "", dataType: .dic_arr).dic_arr ?? []
            var rateArr = [RatingDetails]()
            for dic in rate_dic {
                rateArr.append(RatingDetails(ratingCat: dic["name"] as? String, ratingValue: Float((dic["count"] as? String) ?? "0.0")))
            }
            return rateArr
        }
        var isSelected = false
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
            case createdAt = "created_at"
            case deletedAt = "deleted_at"
            case categoryName = "category_name"
            case categoryImage = "category_image"
            case totalRatingsCount
            case averageRating = "AverageRating"
            case message, rate
            //case totalFavorite, ageRange, similar
        }
        struct RatingDetails {
            let ratingCat: String?
            let ratingValue: Float?
            var ratingColor: UIColor? {
                RatingColor(rawValue: ratingCat ?? "")?.colorInfo()
            }
        }
        enum RatingColor: String {
            case communication = "Communication"
            case accuracy = "Accuracy"
            case value = "Value"
            case atmosphere = "Atmoshphere"
            case location = "Location"
            case presentation = "Presentation"
            case creativity = "Creativity"
            case uniqueness = "Uniqueness"
            
            func colorInfo() -> UIColor {
                switch self {
                case .communication: return UIColor(hexString: "#F96A27")
                case .accuracy: return UIColor(hexString: "#27DCF9")
                case .value: return UIColor(hexString: "#27ACF9")
                case .atmosphere: return UIColor(hexString: "#F9AC27")
                case .location: return UIColor(hexString: "#F9DD27")
                case .presentation: return UIColor(hexString: "#F97B27")
                case .creativity: return UIColor(hexString: "#9027F9")
                case .uniqueness: return UIColor(hexString: "#27C7F9")
                }
            }
        }
    }
    
    // MARK: - TopExperience
    struct TopExperience: Codable {
        let experienceName, expType, latitude, longitude: String?
        let categoryName, expID: String?
        let image: String?
        let minGuestAmount, expMode, username, expStartDate: String?
        let expEndDate, expDate: String?
        let userImage: String?
        let status, selDate, timeSlots_Str: String?
        let totalBooking, totalEarning: Int?
        var timeSlots_arr:[String]? {
            return timeSlots_Str?.components(separatedBy: ",")
        }
        
        enum CodingKeys: String, CodingKey {
            case experienceName = "experience_name"
            case expType = "exp_type"
            case latitude, longitude
            case categoryName = "category_name"
            case expID = "expId"
            case image
            case minGuestAmount = "min_guest_amount"
            case expMode = "exp_mode"
            case username
            case expStartDate = "exp_start_date"
            case expEndDate = "exp_end_date"
            case expDate = "exp_date"
            case userImage, status
            case selDate = "sel_date"
            case timeSlots_Str = "time_slots"
            case totalBooking, totalEarning
        }
    }
}




