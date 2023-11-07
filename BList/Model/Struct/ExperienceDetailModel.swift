//
//  ExperienceDetailModel.swift
//  BList
//
//  Created by iOS TL on 09/08/22.
//

import Foundation
import CoreLocation

// MARK: - ExperienceDetailModel
struct ExperienceDetailModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: ExperienceModel?
    var httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - DataClass
struct ExperienceModel: Codable {
    var totalRatingsCount: Int?
    var averageRating: String?
    var expDetail: ExpDetail?
    var ratingInfo: [RatingInfo]?
    var nearbyExp: [ExperienceDetails]?
    
    enum CodingKeys: String, CodingKey {
        case totalRatingsCount
        case averageRating = "AverageRating"
        case expDetail, ratingInfo, nearbyExp
    }
}

// MARK: - ExpDetail
struct ExpDetail: Codable{
    let expID, userID, expName, expCategory: String?
    let expType, location, willingTravel, willingMessage: String?
    let expDate, expStartDate, expEndDate, expStartTime: String?
    let expEndTime, language, expSummary, expDescribe: String?
    var currentDate: String?
    var coordinates = [CLLocationCoordinate2D]()
    var formattedLanguage: String?
    var formattedOnlineTypes: [String]?
    var formattedLocations: String?
   
    let describeLocation, expDuration, expDurationHours, expDurationMinutes, expCreator, creatorPresence: String?
    let creatorPresence1: String?
    let services, minAgeLimit, maxAgeLimit, minGuestLimit: String?
    let maxGuestLimit, amount, handicapAccessible, handicapDescription: String?
    let activityLevel, expMode, onlineType, clothingRecommendations: String?
    let petAllowed, isAvailable, isCancel, guestBring: String?
    let isAgree: String?
    let isExpDuration: String?
    let weeks, selectedDates, blockDates, timeSlots, images, coverImg: String?
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
    let username, userImage, latitude, longitude, createdAt: String?
 
    enum CodingKeys: String, CodingKey {
        case expID = "exp_id"
        case userID = "user_id"
        case expName = "exp_name"
        case expCategory = "exp_category"
        case expType = "exp_type"
        case location
        case willingTravel = "willing_travel"
        case willingMessage = "willing_message"
        case expDate = "exp_date"
        case expStartDate = "exp_start_date"
        case expEndDate = "exp_end_date"
        case expStartTime = "exp_start_time"
        case expEndTime = "exp_end_time"
        case language
        case createdAt = "created_at"
        case expDurationHours = "exp_duration_hours"
        case expDurationMinutes = "exp_duration_minutes"
        case expSummary = "exp_summary"
        case expDescribe = "exp_describe"
        case describeLocation = "describe_location"
        case expDuration = "exp_duration"
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
        case isAvailable = "is_available"
        case isCancel = "is_cancel"
        case guestBring = "guest_bring"
        case isAgree = "is_agree"
        case isExpDuration = "is_exp_duration"
        case weeks
        case selectedDates = "selected_date"
        case blockDates = "block_dates"
        case timeSlots = "time_slots"
        case coverImg = "cover_img"
        case images, username, userImage, latitude, longitude
    }
}


// MARK: - RatingInfo
struct RatingInfo: Codable {
    var username: String?
    var userImage: String?
    var ratingMessage: String?
    var date: String?
}
