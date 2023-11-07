//
//  AppSettings.swift
//  BList
//
//  Created by iOS Team on 04/07/22.
//

import Foundation
import UIKit
import CoreLocation

fileprivate enum DefaultKey : String {
    case userData
    case currentLocation
    case token
    case isCancelVerification
    case firebaseToken
    case mapAddress
}

struct AppSettings {
    static var UserInfo: User? {
        get{
            if let decodedData = UserDefaults.standard.value(forKey: DefaultKey.userData.rawValue) as? Data {
                do {
                    let info = try JSONDecoder().decode(User.self, from: decodedData)
                    return info
                } catch {
                    print("Failed unarchiving user data")
                    return nil
                }
            } else {
                return nil
            }
        }
        set{
            do {
                let defaults = UserDefaults.standard
                let key = DefaultKey.userData.rawValue
                if newValue == nil {
                    UserDefaults.standard.set(nil, forKey: key)
                } else {
                    let encodedData = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(encodedData, forKey: key)
                }
                
                defaults.synchronize()
            } catch {
                print("Failed archiving user data")
            }
        }
    }
    
    static var Token: String {
        get {
            if let decodedData = UserDefaults.standard.value(forKey: DefaultKey.token.rawValue) as? String {
                return decodedData
            } else {
                return ""
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = DefaultKey.token.rawValue
            UserDefaults.standard.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
    
    static var fireBaseToken: String {
        get {
            if let decodedData = UserDefaults.standard.value(forKey: DefaultKey.firebaseToken.rawValue) as? String {
                return decodedData
            } else {
                return ""
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = DefaultKey.firebaseToken.rawValue
            UserDefaults.standard.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
    
    static var currentLocation: [String:Double]? {
        get {
            let location = UserDefaults.standard.value(forKey: DefaultKey.currentLocation.rawValue) as? [String:Double]
                return location
        }
        set {
            let defaults = UserDefaults.standard
            let key = DefaultKey.currentLocation.rawValue
            UserDefaults.standard.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
    
    static var verificationAppeared: Bool? {
        get {
            let location = UserDefaults.standard.value(forKey: DefaultKey.isCancelVerification.rawValue) as? Bool
                return location
        }
        set {
            let defaults = UserDefaults.standard
            let key = DefaultKey.isCancelVerification.rawValue
            UserDefaults.standard.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
    
    
    static var AddressMap: AddressMapModel? {
        get{
            if let decodedData = UserDefaults.standard.value(forKey: DefaultKey.mapAddress.rawValue) as? Data {
                do {
                    let info = try JSONDecoder().decode(AddressMapModel.self, from: decodedData)
                    return info
                } catch {
                    print("Failed unarchiving user data")
                    return nil
                }
            } else {
                return nil
            }
        }
        set{
            do {
                let defaults = UserDefaults.standard
                let key = DefaultKey.mapAddress.rawValue
                if newValue == nil {
                    UserDefaults.standard.set(nil, forKey: key)
                } else {
                    let encodedData = try JSONEncoder().encode(newValue)
                    UserDefaults.standard.set(encodedData, forKey: key)
                }
                
                defaults.synchronize()
            } catch {
                print("Failed archiving user data")
            }
        }
    }
}
