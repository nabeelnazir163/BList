//
//  AllCreatorModel.swift
//  BList
//
//  Created by iOS TL on 28/07/22.
//

import Foundation
// MARK: - Welcome
struct AllCreatorModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: [CreatorData]?
    var httpStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - Datum
struct CreatorData: Codable {
    let id, firstName, lastName, email: String?
    let profileImg, name, image: String?
    var commission, role: String?
    var commissionEntered: Bool = false
    var selection = false
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case profileImg = "profile_img"
        case commission, name, image, role
    }
}
