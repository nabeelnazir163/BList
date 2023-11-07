//
//  AppDelegate.swift
//  BList
//
//  Created by iOS Team on 06/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GooglePlaces
import FirebaseCore
import FirebaseMessaging
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var socketVM: ConnectSocketViewModel!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyA5S2wr0I-x6Yp3HibMdjcAdIlZ9Gz0Cw0")
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        if let userInfo = AppSettings.UserInfo{
            if userInfo.role == "1"{
                UIStoryboard.setTo(type: .user, vcName: "UTabBarVC")
            }
            else{
                UIStoryboard.setTo(type: .creator, vcName: "CTabBarVC")
            }
        }
        //FireBase Integration
        FirebaseApp.configure()
        
        // Setting Up Push Notifications
        setupNotifications(on: application)
        Messaging.messaging().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserverAction(_:)), name: NSNotification.Name(K.NotificationKeys.autoCheckIn), object: nil)
        return true
    }
    
    @objc func notificationObserverAction(_ notification: NSNotification) {
        if let expId = notification.userInfo?["expId"] as? String {
            checkIn(expId: expId)
        }
        print("Notification observer called")
    }
    // MARK: UISceneSession Lifecycle
    func applicationWillTerminate(_ application: UIApplication) {
        if socketVM != nil, socketVM.isConnected == true {
            socketVM.removeSocketConnection()
        }
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcm Token --> \(fcmToken ?? "")")
        AppSettings.fireBaseToken = fcmToken ?? ""
    }
}
extension AppDelegate : UNUserNotificationCenterDelegate{
    
    // When app is open then willPresent will call
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("userInfo: \(userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        application.applicationIconBadgeNumber += 1
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        defer{ completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let content = response.notification.request.content
        print("Body: \(content.body)")
        
        if let userInfo = content.userInfo as? [String: Any], let aps = userInfo["aps"] as? [String: Any]{
            print("aps: \(aps)")
            print("userInfo: \(userInfo)")
            let bookingID = userInfo["bookingId"] as? String
            let expID = userInfo["experienceId"] as? String
            let msgType = userInfo["messageType"] as? String
            let notificationTypeID = userInfo["notificationTypeId"] as? String
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate, let navVC = sceneDelegate.window?.rootViewController as? UINavigationController else { return }
            let vc = UIStoryboard.loadFeaturesChooseOptionVC()
            vc.bookingId = bookingID ?? ""
            vc.expId = expID ?? ""
            navVC.setViewControllers([UIStoryboard.loadUTabBarVC(), vc], animated: true)
        }
    }
}

extension AppDelegate{
    func setupNotifications(on application:UIApplication) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options:[ .alert, .sound]){ (granted, error) in
            if let error = error{
                print("Failed to request authorization for notification center: \(error.localizedDescription)")
                return
            }
            guard granted else {
                print("Failed to request authorization for notification center: not granted")
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}

extension AppDelegate {
    func checkIn(expId: String) {
        if socketVM == nil {
            socketVM = ConnectSocketViewModel(type: .user)
        }
        socketVM.expID = expId
        socketVM.socketType = .autoCheckIn
        if socketVM.isConnected == false {
            socketVM.connectLocationsSocket()
        } else {
            self.socketVM.checkIn()
        }
        socketVM.connectedCloser = {
            self.socketVM.checkIn()
        }
        socketVM.updateMessages = {
            
        }
    }
}
