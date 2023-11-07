//
//  DateConvertor.swift
//  BList
//
//  Created by iOS TL on 09/08/22.
//

import Foundation
import UIKit

class DateConvertor {
    static let shared = DateConvertor()
    private let dateFormatter = DateFormatter()
    
    /// This function converts one format of date to another format of date
    /// - Parameters:
    ///   - dateInString: The date that you want to convert
    ///   - inputFormat: The current date format
    ///   - outputFormat: The format that we are expecting
    ///   - timezone: It is an optional value. You can send the timeZone. By default system timzone is used.
    ///   - dateStyle: It is an optional value. Pick a dateFormatter style for dateStyle
    ///   - timeStyle: It is an optional value. Pick a dateFormatter style for timeStyle
    /// - Warning: The format for these date and time styles (i.e DateFormatter.Style) is not exact because they depend on the locale, user preference settings, and the operating system version. Do not use these constants if you want an exact format.
    /// - Returns: returns ConvertedDate in  both DateFormat(UTC) and StringFormat
    func convert(dateInString: String, from inputFormat: DateFormat, to outputFormat: DateFormat, timezone: Timezone? = .none, dateStyle: DateFormatter.Style? = nil, timeStyle: DateFormatter.Style? = nil) -> (date:Date?,dateInString:String?) {
        dateFormatter.dateFormat = inputFormat.rawValue
        if let dateStyle{
            dateFormatter.dateStyle = dateStyle
        }
        if let timeStyle{
            dateFormatter.timeStyle = timeStyle
        }
        if let timezone{
            dateFormatter.timeZone = TimeZone(abbreviation: timezone.rawValue)
        }
        guard let date = dateFormatter.date(from: dateInString) else{return (nil,nil)}
        dateFormatter.dateFormat = outputFormat.rawValue
        let dateInStrValue = dateFormatter.string(from: date)
        let dateValue = dateFormatter.date(from: dateInStrValue)
        return (dateValue,dateInStrValue)
    }
    
    /// This function returns string(Date) from local date to UTC date
    func localToUTC(dateInString: String, inputFormat: DateFormat, outputFormat: DateFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        let dt = dateFormatter.date(from: dateInString)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = outputFormat.rawValue
        
        return dateFormatter.string(from: dt ?? Date())
    }
    /// This function returns string(Date) from UTC date to local date
    func UTCToLocal(dateInString: String, inputFormat: DateFormat, outputFormat: DateFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: dateInString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outputFormat.rawValue
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func timeAgo(for dateInString: String?, dateFormat: DateFormat, timezone: Timezone? = .none) -> String{
        dateFormatter.dateFormat = dateFormat.rawValue
        if let timezone{
            dateFormatter.timeZone = TimeZone(abbreviation: timezone.rawValue)
        }
        if let dateInString = dateInString, let date = dateFormatter.date(from: dateInString), #available(iOS 13.0, *){
            return date.timeAgoDisplay()
        }
        return ""
    }
    /// This function converts the date into string format
    func convert(date: Date, format: DateFormat) -> (date:Date?,dateInString:String?){
        dateFormatter.dateFormat = format.rawValue
        let dateInStrValue = dateFormatter.string(from: date)
        let dateValue = dateFormatter.date(from: dateInStrValue)
        return (dateValue,dateInStrValue)
    }
    
    /// This function returns all the dates from the given range
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = calendar.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    /// This function returns  the dates of the week days that you specified through weekIds from startDate to endDate
    ///
    /// Weekday symbols for both ISO 8601 and  Gregorian calendars is ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"] and Weekday ID's for both Gregorian and ISO 8601 calendars is [1,2,3,4,5,6,7]
    ///
    /// In ISO 8601 Calendar each week in a year should have seven days even for the first and last week of the year. If Thursday of the over-lapping week falls on or before 31st Dec then that whole week will be considered as ISO week 52/53 of the previous year or if Thursday falls on or after 1st Jan then it will be considered as ISO week1 of the next year. First weekday of ISO 8601 Calendar starts with Monday( weekId 2)
    ///
    /// In Gregorian Calendar Week numbering always starts from the 1st day of the year and the first and last week of the year doesn’t need to have 7 days. First weekday of Gregorian calendar starts with Sunday( weekId 1)
    /// - Parameters:
    ///   - weekIds: Provide week ids Eg:[1...7]
    ///   - startDate: provide start date
    ///   - endDate: provide end date
    ///   - calendar: provide your own calendar
    func getDates(of weekIds:[Int], from startDate: Date, to endDate: Date, dateFormat: DateFormat, calendar: Calendar = Calendar(identifier: .gregorian)) -> [String]{
        dateFormatter.dateFormat = dateFormat.rawValue
        var dates = [Date]()
        for weekId in weekIds {
            let datecomponent = DateComponents(hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: weekId)
            calendar.enumerateDates(startingAfter: startDate, matching: datecomponent, matchingPolicy: .strict, direction: .forward) { (date, _, stop) in
                guard let date = date, date <= endDate else {
                    stop = true
                    return
                }
                dates.append(date)
            }
        }
        
        return dates.map { dateFormatter.string(from: $0) }
    }
}

// MARK: - DATE EXTENSION
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return calendar.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return calendar.date(byAdding: .day, value: 1, to: noon)!
    }
    var nextYear: Date{
        return calendar.date(byAdding: .year, value: 1, to: noon)!
    }
    var noon: Date {
        return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return calendar.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func startOfMonth(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }
    func startOfNextMonth(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.date(byAdding: .month, value: 1, to: startOfMonth(using: calendar))!
    }
    
    /// This function returns weekID of given date based on the calendar that you are passing
    func weekID(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        calendar.component(.weekday, from: self)
    }
    
    /// This function returns the weekID of first day of week for the given calendar
    func firstDayOfWeek(using calendar: Calendar = Calendar(identifier: .gregorian)) -> Int{
        return calendar.firstWeekday
    }
    
    /// This function adds given minutes to the  date
    /// - Parameter minutes: pass number of minutes that you want to add to the date
    /// - Returns: This functions returns a new date by adding given minutes to the date.
    func adding(minutes: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(minutes*60))
    }
    
    /// This function adds given hours to the  date
    /// - Parameter hours: pass number of hours that you want to add to the date
    /// - Returns: This functions returns a new date by adding given hours to the date.
    func adding(hours: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(hours*3600))
    }
    
    /// This function adds given hours and minutes to the  date
    /// - Parameter hours: pass number of hours that you want to add to the date
    /// - Parameter minutes: pass number of minutes that you want to add to the date
    /// - Returns: This functions returns a new date by adding given hours and minutes to the date.
    func adding(hours: Int, minutes: Int, seconds: Int = 0) -> Date {
        return self.addingTimeInterval(TimeInterval((hours*3600) + (minutes*60)))
    }
    
    /// This function returns the components of a particular date.
    /// - Parameters:
    ///   - components: Provide components that you want to return
    ///   - calendar: You can pass your calendar
    func get(components: Calendar.Component..., calendar: Calendar = Calendar(identifier: .gregorian)) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    /// This function returns a component of a particular date.
    /// - Parameters:
    ///   - component: Provide component that you want to return
    ///   - calendar: You can pass your calendar
    func get(component: Calendar.Component, calendar: Calendar = Calendar(identifier: .gregorian)) -> Int {
        return calendar.component(component, from: self)
    }
    
    
    @available(iOS 13.0, *)
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - ENUMS
enum DateFormat: String{
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"
    case EEEddMMM = "EEE, dd MMM"
    case MMMdyyyy = "MMM d, yyyy"
    case dd_MMM_yyyy = "dd-MMM-yyyy"
    case ddMMMyyyy = "dd MMM, yyyy"
    case ddMMyyyy = "dd/MM/yyyy"
    case hmma = "h:mm a"
    case hhmma = "hh:mm a"
    case HHmm = "HH:mm"
    static let allValues = [yyyyMMdd, EEEddMMM]
}

enum Timezone: String{
    case UTC = "UTC"
}

enum DayInWeek: String{
    case sunday     = "Sunday"
    case monday     = "Monday"
    case tuesday    = "Tuesday"
    case wednesday  = "Wednesday"
    case thursday   = "Thursday"
    case friday     = "Friday"
    case saturday   = "Saturday"
    
    func dayId() -> Int{
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        }
    }
}
