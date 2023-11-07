//
//  UnAuthorizedVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 06/02/23.
//

import UIKit

class UnAuthorizedVC: UIViewController {
    enum ScreenType{
        case unauthorized
        case notLoggedIn
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    var screenType: ScreenType = .unauthorized
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI(){
        switch screenType {
        case .unauthorized:
            titleLbl.text = "Access Denied"
            subTitleLbl.text = "Your account is logged in another account. Please login again."
        case .notLoggedIn:
            titleLbl.text = "Not Logged In"
            subTitleLbl.text = "Please login to continue."
        }
    }
    @IBAction func okBtnAction(_ sender:UIButton){
        AppSettings.Token =  ""
        AppSettings.UserInfo = nil
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        let navVC = window?.rootViewController as? UINavigationController
        navVC?.viewControllers = [UIStoryboard.loadUTabBarVC(),UIStoryboard.loadLoginVC()]
        window?.rootViewController = nil
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
