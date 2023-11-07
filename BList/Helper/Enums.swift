//
//  Enums.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 02/11/22.
//

import UIKit
enum Person{
    case adult
    case children
    case infant
}

enum PaymentType: String, CaseIterable{
    case card   = "Credit & debit card"
    case paypal = "Paypal"
    case crypto = "Crypto (coming soon)"
}

enum LocaleID: String{
    case Hour_12 = "en_US"
    case Hour_24 = "en_GB"
}

enum AccountType:String{
    case creator = "creator"
    case user = "user"
}

enum MapScreenType{
    case singleExp
    case multipleExp
    case trackedUsers
}

enum Option_Enum{
    case Edit_Experience
    case Activate
    case Deactivate
    case Promote
}
