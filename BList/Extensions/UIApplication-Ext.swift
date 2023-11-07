//
//  UIApplication-Ext.swift
//  BList
//
//  Created by iOS Team on 11/07/22.
//

import Foundation
import UIKit


// MARK: - UIAPPLICATION
extension UIApplication {
    class func window() -> UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
    
    class func rootViewController() -> UIViewController {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first!
            if let rootNavVC = window.rootViewController as? UINavigationController {
                return rootNavVC.topViewController!
            } else {
                return window.rootViewController!
            }
        } else {
            let window = UIApplication.shared.keyWindow!
            if let rootNavVC = window.rootViewController as? UINavigationController {
                return rootNavVC.topViewController!
            } else {
                return window.rootViewController!
            }
        }
    }
}
