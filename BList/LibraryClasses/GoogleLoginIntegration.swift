//
//  GoogleLoginIntegration.swift
//  ConsignItAway
//
//  Created by appsdeveloper Developer on 21/03/22.
//

import Foundation
import UIKit
import GoogleSignIn

class GoogleLoginIntegration: NSObject {
    
    static let shared = GoogleLoginIntegration()
    var closureDidGetUserDetails: ((GIDGoogleUser) -> ())?
    private var presentedVC: UIViewController?
    
    func signInWith(presentingVC: UIViewController) {
        self.presentedVC = presentingVC
        
        let config = GIDConfiguration(clientID: APIKeys.kGoogleSignInKey)
        
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { user, error in
            if let err = error {
                if let baseVC = self.presentedVC as? BaseClassVC {
                    baseVC.showErrorMessages(message: err.localizedDescription)
                }
            } else {
                self.closureDidGetUserDetails?(user!)
            }
        }
        
//        GIDSignIn.sharedInstance()?.signOut()
//        GIDSignIn.sharedInstance()?.presentingViewController = presentingVC
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            presentedVC?.dismiss(animated: true) {
                Alert.show(message: err.localizedDescription)
            }
        } else {
            self.closureDidGetUserDetails?(user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        presentedVC?.dismiss(animated: true, completion: nil)
    }
}
