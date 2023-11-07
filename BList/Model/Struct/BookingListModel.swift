//
//  BookingListModel.swift
//  BList
//
//  Created by mac23 on 08/08/22.
//

import Foundation

// MARK: - BookingListModel
struct BookingListModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: BookingTypes?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - BookingDetails
    struct BookingTypes: Codable {
        let pastBooking: [BookingDetails]?
        let futureBooking: [BookingDetails]?
    }
    
    // MARK: - BookingDetails
    struct BookingDetails: Codable {
        let id, userID, experienceID, noAdults: String?
        let noChildern, noInfant, fromDate, toDate: String?
        let fromTime, toTime, bookDateTime, requestDate: String?
        let requestTime, isRequestTime, paymentMethod, paymentCardID: String?
        let notes, isAcceptance, status, createdAt: String?
        let expName, minGuestAmount, uploadFiles, expStartDate, expEndDate, averageRating: String?
        let totalRatingsCount: Int?
        var expImage: String{
            get{
                let images = (uploadFiles ?? "").components(separatedBy: ",")
                return images.first ?? ""
            }
        }
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
            case createdAt = "created_at"
            case expName = "exp_name"
            case uploadFiles = "upload_files"
            case expStartDate = "exp_start_date"
            case expEndDate = "exp_end_date"
            case minGuestAmount = "min_guest_amount"
            case totalRatingsCount
            case averageRating = "AverageRating"
        }
    }
}



// MARK: - Welcome
struct Welcome: Codable {
    let success: Int
    let error: Bool
    let message: String
    let data: [Datum]
    let httpStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - GetUsersResponseModel
struct GetUsersResponseModel: APIModel, Equatable {
    
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [Users]?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - Users
    struct Users: Codable, Equatable {
        let id, firstName, lastName, email: String?
            let profileImg, name: String?

            enum CodingKeys: String, CodingKey {
                case id
                case firstName = "first_name"
                case lastName = "last_name"
                case email
                case profileImg = "profile_img"
                case name
            }
    }
}



// MARK: - Datum
struct Datum: Codable {
    let bookingDate, status, experienceID, noAdults: String
    let noChildern, paymentMethod, bookID, id: String
    let userID, expName, expCategory, expType: String
    let location, willingTravel, willingMessage, expDate: String
    let expStartDate, expEndDate, language, expSummary: String
    let expDescribe, describeLocation, expDuration, expCreator: String
    let usersCollab, creatorPresence: String
    let creatorPresence1: String?
    let services, guestBring, ageLimit, guestLimit: String
    let minGuestAmount, maxGuestAmount, handicapAccessible, handicapDescription: String
    let activityLevel, uploadFiles: String
    let expMode, onlineType, maxAgeLimit, maxGuestLimit: String?
    let clothingRecommendations: String?
    let petAllowed, isPromote: String
    let isAgree: String?
    let isCancel, createdAt, deletedAt: String
    
    enum CodingKeys: String, CodingKey {
        case bookingDate = "booking_date"
        case status
        case experienceID = "experience_id"
        case noAdults = "no_adults"
        case noChildern = "no_childern"
        case paymentMethod = "payment_method"
        case bookID = "bookId"
        case id
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
    }
}
