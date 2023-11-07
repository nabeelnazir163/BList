//
//  FavouriteModel.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 25/11/22.
//

import UIKit
// MARK: - FavouritesListModel
struct FavouritesListModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: [ExpDetails]?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    // MARK: - ExpDetails
    struct ExpDetails: Codable {
        let userID, experienceID, expName, images: String?
        let price: String?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case experienceID = "experience_id"
            case expName = "exp_name"
            case images, price
        }
    }
}
// MARK: - DoFavouriteModel
struct DoFavouriteModel: APIModel {
    let success: Int?
    let error: Bool?
    let message: String?
    let data: ExpDetails?
    let httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
    // MARK: - DataClass
    struct ExpDetails: Codable {
        let userID, experienceID, doFavorite: String?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case experienceID = "experience_id"
            case doFavorite = "do_favorite"
        }
    }
}




