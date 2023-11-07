//
//  BookingDetailModel.swift
//  BList
//
//  Created by mac23 on 08/08/22.
//

import Foundation
import CoreLocation

// MARK: - BookingDetailModel
struct BookingDetailModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    var data: BookingDetails?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - BookingDetails
struct BookingDetails: Codable {
    let bookingDate, status, experienceID, noAdults: String?
    let noChildern, noInfants, paymentMethod, bookID, id, notes: String?
    let userID, expName, expCategory, expType: String?
    let location, willingTravel, willingMessage, expDate: String?
    let expStartDate, expEndDate, language, expSummary: String?
    let expDescribe, describeLocation, expDuration, expCreator: String?
    let latitude, longitude, usersCollab, creatorPresence: String?
    let creatorPresence1: String?
    let services, guestBring, ageLimit, guestLimit: String?
    let minGuestAmount, maxGuestAmount, handicapAccessible, handicapDescription: String?
    let activityLevel, uploadFiles: String?
    let expMode, onlineType, maxAgeLimit, maxGuestLimit: String?
    let clothingRecommendations: String?
    let petAllowed, isPromote: String?
    let isAgree: String?
    let isCancel, createdAt, deletedAt: String?
    var ratingInfo: [RatingInfo]?
    var nearbyExp: [ExperienceDetails]?
    var totalRatingsCount: Int?
    var averageRating: String?
    let userName,userImage: String?
    var onlinePlatforms: [String]? {
        return onlineType?.components(separatedBy: ",")
    }
    var coordinates:[CLLocationCoordinate2D]?{
        get{
            let latitudes = (latitude ?? "").components(separatedBy: ",")
            let longitudes = (longitude ?? "").components(separatedBy: ",")
            
            if latitudes.count == longitudes.count{
                var coordinates = [CLLocationCoordinate2D]()
                for i in 0..<latitudes.count{
                    coordinates.append(CLLocationCoordinate2D.init(latitude: Double(latitudes[i]) ?? 0, longitude: Double(longitudes[i]) ?? 0))
                }
                let locationCoordinates = coordinates
                return coordinates
            }
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case bookingDate = "booking_date"
        case status
        case experienceID = "experience_id"
        case noAdults = "no_adults"
        case noChildern = "no_childern"
        case noInfants = "no_infants"
        case paymentMethod = "payment_method"
        case bookID = "bookId"
        case id, notes
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
        case language
        case expSummary = "exp_summary"
        case expDescribe = "exp_describe"
        case describeLocation = "describe_location"
        case expDuration = "exp_duration"
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
        case isAgree = "is_agree"
        case isCancel = "is_cancel"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case userName = "username"
        case userImage
    }
}
