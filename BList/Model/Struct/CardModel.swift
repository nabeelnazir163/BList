//
//  CardModel.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/11/22.
//

import UIKit
// MARK: - CardListing
struct CardListingModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [CardDetails]?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
// MARK: - CardDetailsModel
struct CardDetailsModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: CardDetails?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
// MARK: - CardDetails
struct CardDetails: Codable {
    let id, cardName, cardNumber, cardExpireDate: String?
    let cardCity, cardState, cardCountry, userID: String?
    var selected: Bool = false
    enum CodingKeys: String, CodingKey {
        case id
        case cardName = "card_name"
        case cardNumber = "card_number"
        case cardExpireDate = "card_expire_date"
        case cardCity = "card_city"
        case cardState = "card_state"
        case cardCountry = "card_country"
        case userID = "user_id"
    }
}
