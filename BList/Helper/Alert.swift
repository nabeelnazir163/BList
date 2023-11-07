//
//  Alert.swift
//  Fixv Customer
//
//  Created by Rahul Chopra on 06/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import Foundation
import UIKit
import Loaf

var appName = Bundle.main.infoDictionary!["CFBundleName"] as! String

class Alert {
    class func show(message: String, actionTitle1: String? = nil, actionTitle2: String? = nil, actionTitle3: String? = nil, destructiveIndex: Int? = nil, cancelIndex: Int? = nil, alertStyle: UIAlertController.Style = .alert, completionOK: (() -> ())? = nil, completionCancel: (() -> ())? = nil) {
        let alert = UIAlertController(title: appName, message: message, preferredStyle: alertStyle)
        let actionOk = UIAlertAction(title: actionTitle1 ?? "Ok", style: .default) { (_) in
            if completionOK != nil {
                completionOK!()
            }
        }
        alert.addAction(actionOk)
        
        if actionTitle2 != nil {
            var style = UIAlertAction.Style.default
            if destructiveIndex != nil {
                if destructiveIndex! == 1 {
                    style = .destructive
                }
            } else {
                if cancelIndex != nil {
                    if cancelIndex! == 1 {
                        style = .cancel
                    }
                }
            }
            
            let actionCancel = UIAlertAction(title: actionTitle2 ?? "Cancel", style: style) { (_) in
                if completionCancel != nil {
                    completionCancel!()
                }
            }
            alert.addAction(actionCancel)
        }
        
        if actionTitle3 != nil {
            var style = UIAlertAction.Style.default
            if destructiveIndex != nil {
                if destructiveIndex! == 2 {
                    style = .destructive
                }
            } else {
                if cancelIndex != nil {
                    if cancelIndex! == 2 {
                        style = .cancel
                    }
                }
            }
            
            let actionCancel = UIAlertAction(title: actionTitle3 ?? "Cancel", style: style) { (_) in
                
            }
            alert.addAction(actionCancel)
        }
        
        if UIApplication.rootViewController().presentedViewController.debugDescription.contains("Loaf") {
            UIApplication.rootViewController().presentedViewController?.dismiss(animated: true, completion: {
                self.presentAlert(alert: alert)
            })
        } else {
            self.presentAlert(alert: alert)
        }
    }
  
    class func showMultiple(strings: [String], modalPresentationStyle: UIModalPresentationStyle? = nil, completion: ((Int) -> ())) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        for (i, string) in strings.enumerated() {
            alert.addAction(UIAlertAction(title: string, style: .default, handler: { (_) in
                print("Tap Index : \(i)")
            }))
        }
        
        UIApplication.rootViewController().present(alert, animated: true, completion: nil)
    }
    
    private class func presentAlert(alert: UIAlertController) {
        if UIApplication.rootViewController().presentedViewController != nil {
            let navVC = UINavigationController(rootViewController: alert)
//            navVC.setViewControllers([alert], animated: true)
            navVC.modalPresentationStyle = .fullScreen
            UIApplication.rootViewController().presentedViewController!.present(navVC, animated: true, completion: nil)
        } else {
            UIApplication.rootViewController().present(alert, animated: true, completion: nil)
        }
    }
}
