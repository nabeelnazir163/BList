//
//  Date.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/11/22.
//

import UIKit


/// This function Allows you to get an array of dates from start date to end date
///
///  Make sure to send startDate less than endDate otherwise you will get an empty Date array
/// - Parameters:
///   - startDate: Enter start date here
///   - endDate: Enter end date here
/// - Returns: An array of dates starting from start date to end date
/// - Author: Ajay
/// - Warning: No Warning
func datesRange(from startDate: Date, to endDate: Date) -> [Date] {
    // in case of the "from" date is more than "to" date,
    // it should returns an empty array:
    if startDate > endDate { return [Date]() }

    var tempDate = startDate
    var array = [tempDate]

    while tempDate < endDate {
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }
    return array
}
