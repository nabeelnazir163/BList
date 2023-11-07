//
//  Country_State_CityModel.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/11/22.
//

import UIKit
struct CountiesWithPhoneModel {
    var id : Int?
    var dial_code :Int?
    var countryName : String?
    var code :String?
}

struct CityCodable:Codable {
    var id, name :String?
}

struct Countries{
    var countryName: String?
    var numericCode : String?
}
struct States{
    var stateName: String?
    var stateCode: String?
}
struct Cities{
    var cityName: String?
}

struct Day{
    let dayId: Int
    let dayName: String
    var selection: Bool
}
