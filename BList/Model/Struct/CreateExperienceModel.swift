//
//  CreateExperienceModel.swift
//  BList
//
//  Created by iOS TL on 29/07/22.
//

import Foundation

// MARK: - CreateExperienceModel
struct CreateExperienceModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: experience_data?
    var httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - experience_data
struct experience_data: Codable {
    var userID, expName: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case expName = "exp_name"
    }
}
