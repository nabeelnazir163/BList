//
//  TimeSlotViewModel.swift
//  BList
//
//  Created by iOS Team on 21/10/22.
//

import Foundation
import CoreImage

// MARK: - Welcome
struct TimeSlotViewModel: APIModel {
    var success: Int?
    var error: Bool?
    var message: String?
    var data: [TimeSlotData]?
    var httpStatus: Int?

    enum CodingKeys: String, CodingKey {
        case success, error, message, data
        case httpStatus = "http_status"
    }
}

// MARK: - Datum
struct TimeSlotData: Codable {
    var date: String?
    var isSelected : Bool?
    var slotTimes: [String]?
}

// MARK: - Slot
struct SlotList: Codable {
    var slotStartTime, slotEndTime: String?
    var isSelected : Bool?
    enum CodingKeys: String, CodingKey {
        case slotStartTime = "slot_start_time"
        case slotEndTime = "slot_end_time"
    }
}
