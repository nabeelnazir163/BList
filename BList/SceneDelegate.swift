//
//  SceneDelegate.swift
//  BList
//
//  Created by iOS Team on 06/05/22.
//

import UIKit
import FBSDKCoreKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if AppSettings.UserInfo != nil{
            if AppSettings.UserInfo?.role == "1"{
                UIStoryboard.setTo(type: .user, vcName: "UTabBarVC")
            }
            else{
                UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
            }
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        LocationManager.shared.getCurrentLocation(continuousUpdate: true, { location in
            let loc_dic = [
                "lat" : location.coordinate.latitude,
                "long": location.coordinate.longitude
            ]
            print("Latitude --> \(location.coordinate.latitude)")
            print("Longitude --> \(location.coordinate.longitude)")
            AppSettings.currentLocation = loc_dic
            AppSettings.AddressMap = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.NotificationKeys.locationUpdate), object: nil)
        })
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }
}
