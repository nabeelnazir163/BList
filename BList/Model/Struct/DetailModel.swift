//
//  DetailModel.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import Foundation

enum ExpDetailType {
    case activityLevel
    case group
    case duration
    case noOfGuest
    case language
    case ageRange
    case handicap
    case petAllow
    case creatorPresent
    case experinceMode
}

struct DetailModel {
    var heading: String
    var subheading: String
    var type: ExpDetailType
    
    static func data() -> [DetailModel] {
        var arr = [DetailModel]()
        arr.append(DetailModel(heading: "Activity Level", subheading: "Moderate", type: .activityLevel))
        arr.append(DetailModel(heading: "Private/Group/Both", subheading: "Private", type: .group))
        arr.append(DetailModel(heading: "Duration", subheading: "1h 20 Minute", type: .duration))
        arr.append(DetailModel(heading: "No of Guests", subheading: "Attending 10 Max 02", type: .noOfGuest))
        arr.append(DetailModel(heading: "Languages Offered", subheading: "English", type: .language))
        arr.append(DetailModel(heading: "Age Range", subheading: "20 to 50 years", type: .ageRange))
        arr.append(DetailModel(heading: "Handicap Accessible", subheading: "Yes", type: .handicap))
        arr.append(DetailModel(heading: "Pets allowed", subheading: "Yes", type: .petAllow))
        arr.append(DetailModel(heading: "Creator Present", subheading: "Yes", type: .creatorPresent))
        arr.append(DetailModel(heading: "Experience Mode", subheading: "", type: .experinceMode))
        return arr
    }
}
