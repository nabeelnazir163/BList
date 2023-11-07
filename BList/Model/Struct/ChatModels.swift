//
//  ChatModels.swift
//  Maara
//
//  Created by Venkata Ajay Sai (Paras) on 11/01/23.
//

import UIKit
import CoreLocation
// MARK: - GetChatMessagesResponseModel
struct GetChatMessagesResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [MessageDetails]?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
// MARK: - MessageDetails
struct MessageDetails: Codable {
    
    let id, roomID, sourceUserID, targetUserID: String?
    let senderType, receiverType, bookingID: String?
    var bookingStatus: String
    let message, status, messageType, modifiedOn: String?
    let createdOn, senderID, receiverID, senderName: String?
    let receiverName, senderImg, receiverImg: String?
    
    enum CodingKeys: String, CodingKey {
        case id, roomID
        case sourceUserID = "source_user_id"
        case targetUserID = "target_user_id"
        case senderType, bookingID, bookingStatus, message, status
        case receiverType = "recieverType"
        case messageType = "MessageType"
        case modifiedOn = "modified_on"
        case createdOn = "created_on"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case senderName, receiverName, senderImg, receiverImg
    }
}
// MARK: - RecentChatResponseModel
struct RecentChatResponseModel: Codable {
    let response, message, type: String?
    let data: [ChatDetails]
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message, type, data
    }
}

// MARK: - Datum
struct ChatDetails: Codable {
    let message, createdOn, readStatus, messageType: String?
    let bookingID, bookingStatus, senderType, recieverType: String?
    let sourceUserID, targetUserID, hash: String?
    let senderOfflineTime, recieverOfflineTime: String?
    let unreadCount: Int?
    let senderName, senderID, senderProfilePicture, receiverName: String?
    let receiverID, receiverProfilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case createdOn = "created_on"
        case readStatus
        case messageType = "MessageType"
        case bookingID, bookingStatus, senderType, recieverType
        case sourceUserID = "source_user_id"
        case targetUserID = "target_user_id"
        case hash, senderOfflineTime, recieverOfflineTime, unreadCount, senderName
        case senderID = "sender_id"
        case senderProfilePicture = "sender_profile_picture"
        case receiverName
        case receiverID = "receiver_id"
        case receiverProfilePicture = "receiver_profile_picture"
    }
}


// MARK: - SendMessageResponseModel
struct SendMessageResponseModel: Codable {
    let response, message, type: String?
    let data: MessageDetails?
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message, type, data
    }
    // MARK: - MessageDetails
    struct MessageDetails: Codable {
        let id, roomID, sourceUserID, targetUserID: String
        let senderType, recieverType, bookingID, bookingStatus: String
        let message, status, messageType, modifiedOn: String
        let createdOn: String
        
        enum CodingKeys: String, CodingKey {
            case id, roomID
            case sourceUserID = "source_user_id"
            case targetUserID = "target_user_id"
            case senderType, recieverType, bookingID, bookingStatus, message, status
            case messageType = "MessageType"
            case modifiedOn = "modified_on"
            case createdOn = "created_on"
        }
    }
}

// MARK: - AcceptOrRejectBookingResponseModel
struct AcceptOrRejectBookingResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: AcceptanceDetails?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - AcceptanceDetails
struct AcceptanceDetails: Codable {
    let id, userID, experienceID, noAdults: String?
    let noChildern, noInfant: String?
    let fromDate, toDate, fromTime, toTime: String?
    let bookDateTime: String?
    let requestDate, requestTime, isRequestTime: String?
    let paymentMethod, paymentCardID: String?
    let notes: String?
    let isAcceptance, status, createdAt: String?
    
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
    }
}

// MARK: - SendImageResponseModel
struct SendImageResponseModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: ImageData?
    let httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    
    // MARK: - ImageData
    struct ImageData: Codable {
        let imgURL: String
        
        enum CodingKeys: String, CodingKey {
            case imgURL = "imgUrl"
        }
    }
}


// MARK: - GetUserLocationsResponseModel
struct GetUserLocationsResponseModel: Codable {
    let response, message, latitude, longitude: String?
    let username, image, userID: String?
    var coordinate: CLLocationCoordinate2D? {
        if let lat = latitude, let latInDouble = Double(lat), let long = longitude, let longInDouble = Double(long) {
            return CLLocationCoordinate2D(latitude:latInDouble, longitude:longInDouble)
        }
        return nil
    }
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message
        case latitude = "Latitude"
        case longitude = "Longitude"
        case username, image, userID
    }
}

// MARK: - BookedUsersResponseModel
struct BookedUsersResponseModel: Codable {
    let response, message: String?
    let data: [ChatDetails]?

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message, data
    }
    
    // MARK: - ChatDetails
    struct ChatDetails: Codable {
        let firstName, profileImg, id, createdOn: String?
        let message: String?
        let status: String?
        let bookingID, bookingStatus, senderName, senderID: String?
        let senderProfilePicture, receiverName, receiverID, receiverProfilePicture: String?

        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case profileImg = "profile_img"
            case id
            case createdOn = "created_on"
            case message, status, bookingID, bookingStatus, senderName
            case senderID = "sender_id"
            case senderProfilePicture = "sender_profile_picture"
            case receiverName
            case receiverID = "receiver_id"
            case receiverProfilePicture = "receiver_profile_picture"
        }
    }

}

