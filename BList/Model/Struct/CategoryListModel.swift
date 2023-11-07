//
//  CategoryListModel.swift
//  BList
//
//  Created by iOS Team on 21/07/22.
//

import Foundation

// MARK: - CategoryListModel
struct CategoryListModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: [Category]?
    var httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}
