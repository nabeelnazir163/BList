//
//  WebViewVC.swift
//  BList
//
//  Created by iOS Team on 11/07/22.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    var instagramApi = InstagramApi.shared
//    var testUserData: InstagramTestUser?
    var testUserData: InstagramUser?
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clean()
        //Authorize the user
        instagramApi.authorizeApp { (url) in
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url!))
                
            }
        }
    }
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        self.instagramApi.getTestUserIDAndToken(request: request) { [weak self] (instagramTestUser) in
            self?.testUserData = instagramTestUser
            DispatchQueue.main.async {
                self?.dismissViewController()
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    func dismissViewController() {
        //        var param = [String:Any]()

        //        param["user_id"] = UserData.user_ID
        //        param["instagram_user_id"] = self.testUserData?.user_id ?? ""
        //        param["access_token"] = self.testUserData?.access_token ?? ""
        //        print(param)
        //        Hud.show(message: "", view: self.view)
        //        APIManager.sharedInstance.API_GetConnectInstagram(param: param){
        //            (result, error) in
        //            Hud.hide(view: self.view)
        //            if let err = error {
        //                print(err.localizedDescription)
        //                Alert.showSimple(err.localizedDescription)
        //                return
        //            }
        //            if let res = result {
        //                if res.response == "true"{
        //                    UserData.InstaStatus = res.data?.instagramStatus ?? ""
        //                    UserData.InstaUser_ID = res.data?.id ?? ""
        //
        //                    self.dismiss(animated: true)    {
        //                        self.mainVC?.testUserData = self.testUserData!
        //                    }
        //                }
        //                else {
        //                    self.dismiss(animated: true) {
        //                               Alert.showSimple(res.message ?? "")
        //                    }
        //
        //                }
        //            }
        //        }
    }

}
