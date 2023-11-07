//
//  Constants.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/11/22.
//

import UIKit

var paymentTypes = PaymentType.allCases

let daysInWeek = [
    Day(dayId: 2, dayName: "Monday", selection: false),
    Day(dayId: 3, dayName: "Tuesday", selection: false),
    Day(dayId: 4, dayName: "Wednesday", selection: false),
    Day(dayId: 5, dayName: "Thursday", selection: false),
    Day(dayId: 6, dayName: "Friday", selection: false),
    Day(dayId: 7, dayName: "Saturday", selection: false),
    Day(dayId: 1, dayName: "Sunday", selection: false)]

let activityLevels = [
    ActivityLevel(activityLevel: "None", isSelected: true),
    ActivityLevel(activityLevel: "Moderate", isSelected: false),
    ActivityLevel(activityLevel: "Strenuous", isSelected: false),
    ActivityLevel(activityLevel: "Extreme", isSelected: false),
    ActivityLevel(activityLevel: "Light", isSelected: false),
    ActivityLevel(activityLevel: "N/A", isSelected: false)
]

let languages = [
    Language(id: 0, name: "English", isSelected: false),
    Language(id: 0, name: "Català", isSelected: false),
    Language(id: 0, name: "Español", isSelected: false),
    Language(id: 0, name: "Français", isSelected: false),
    Language(id: 0, name: "Italiano", isSelected: false),
    Language(id: 0, name: "日本語", isSelected: false),
    Language(id: 0, name: "한국어", isSelected: false),
    Language(id: 0, name: "Português", isSelected: false)
]

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.yyyyMMdd.rawValue
    return formatter
}()

let calendar = Calendar(identifier: .gregorian)

let options = [
    Option(optionName: "Edit Experience", optionImg: "edit (2)", selection: false),
    Option(optionName: "Activate", optionImg: "checked", selection: false),
    Option(optionName: "Promote", optionImg: "megaphone", selection: false)
]

let creatorTypes = [
    CreatorType_Filter(headerName: "Type", types: [
//        CreatorType_Filter.TypeDetails(typeID: 4, typeName: "Inperson"),
//        CreatorType_Filter.TypeDetails(typeID: 5, typeName: "Online"),
//        CreatorType_Filter.TypeDetails(typeID: 2, typeName: "Private"),
//        CreatorType_Filter.TypeDetails(typeID: 1, typeName: "Group")
        CreatorType_Filter.TypeDetails(typeID: 1, typeName: "Inperson"),
        CreatorType_Filter.TypeDetails(typeID: 2, typeName: "Online"),
        CreatorType_Filter.TypeDetails(typeID: 3, typeName: "Private"),
        CreatorType_Filter.TypeDetails(typeID: 4, typeName: "Group")
    ]),
    CreatorType_Filter(headerName: "Creator Type", types: [
        CreatorType_Filter.TypeDetails(typeID: 1, typeName: "Individual Creators"),
        CreatorType_Filter.TypeDetails(typeID: 2, typeName: "Verified Pros"),
        CreatorType_Filter.TypeDetails(typeID: 3, typeName: "Venues")
//        CreatorType_Filter.TypeDetails(typeID: 1, typeName: "Individual Creators"),
//        CreatorType_Filter.TypeDetails(typeID: 3, typeName: "Verified Pros"),
//        CreatorType_Filter.TypeDetails(typeID: 2, typeName: "Venues")
    ]),
]

struct K {
    struct NotificationKeys {
        static let locationUpdate = "LocationUpdate"
        static let autoCheckIn = "AutoCheckIn"
        static let autoTrack = "AutoTrack"
        static let removeConnection = "RemoveConnection"
    }
    
    struct Colors {
        static let orange = "AppOrange"
        static let _676A71 = "#676A71"
    }
    
    static func getDummyRatings() -> [GetAnalyticsResponseModel.MyExperience.RatingDetails] {
        [
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Communication", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Accuracy", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Value", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Atmosphere", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Location", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Presentation", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Creativity", ratingValue: 0.0),
            GetAnalyticsResponseModel.MyExperience.RatingDetails(ratingCat: "Uniqueness", ratingValue: 0.0),
        ]
    }
}

let rateExpQualities = [
    RatingCategory(categoryName: "Communication"),
    RatingCategory(categoryName: "Accuracy"),
    RatingCategory(categoryName: "Value"),
    RatingCategory(categoryName: "Atmosphere"),
    RatingCategory(categoryName: "Location"),
    RatingCategory(categoryName: "Presentation"),
    RatingCategory(categoryName: "Creativity"),
    RatingCategory(categoryName: "Uniqueness")
]

let feedbackOptions: [FeedbackOption] = [
    FeedbackOption(optionName: "Creators"),
    FeedbackOption(optionName: "Users"),
    FeedbackOption(optionName: "Experiences"),
    FeedbackOption(optionName: "App Design"),
    FeedbackOption(optionName: "User Interface")
]
