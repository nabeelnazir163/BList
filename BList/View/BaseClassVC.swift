//
//  BaseClassVC.swift
//  Agni
//
//  Created by appsdeveloper Developer on 01/03/22.
//

import Foundation
import UIKit
import Loaf
import JGProgressHUD


class BaseClassVC: UIViewController {
    
    private lazy var progressHUD : JGProgressHUD = {
        let progressHUD = JGProgressHUD()
        progressHUD.textLabel.text = "Loading"
        progressHUD.animation = JGProgressHUDFadeZoomAnimation()
        progressHUD.interactionType = JGProgressHUDInteractionType.blockAllTouches
        return progressHUD
    }()
    
    // MARK:- CORE METHODS
    
    func showAlertCompletion(alertText : String, alertMessage : String,completion:@escaping(() -> ())) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {(alert) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertCompletionWithTwoOption(alertText : String, alertMessage : String,completion:@escaping((Bool) -> ())) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: {(alert) in
            completion(true)
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .default, handler: {(alert) in
            completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let color = UIColor(patternImage: image!)
        return color
    }
    
    func contentViews(views: [Any], isHidden: Bool) {
        views.forEach { each in
            if let each = each as? UIView {
                each.alpha = isHidden ? 0 : 1
            } else if let each = each as? UIButton {
                each.alpha = isHidden ? 0 : 1
            } else if let each = each as? UIImageView {
                each.alpha = isHidden ? 0 : 1
            } else if let each = each as? UILabel {
                each.alpha = isHidden ? 0 : 1
            }
        }
    }
    
    func setUpVM(model:ViewModel, hideKeyboardWhenTapAround:Bool = true){
        if hideKeyboardWhenTapAround{
            hideKeyboardWhenTappedAround()
        }
        var viewModel = model
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let _ = viewModel.isLoading ? self?.showProgressHUD() : self?.hideProgressHUD()
            }
        }
        viewModel.showAlertClosure = {  [weak self] in
            if let error = viewModel.error {
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.showErrorMessages(message: error)
                }
            }
        }
    }
    

    func showErrorMessages(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: .custom(.init(backgroundColor: .gray, icon: UIImage(named: "moon"))), sender: self).show(.short)
        }
    }
    func showSuccessMessages(message:String) {
        DispatchQueue.main.async {
            Loaf(message, state: .custom(.init(backgroundColor: .gray, icon: UIImage(named: "moon"))), sender: self).show(.short)
        }
    }
    func showProgressHUD() {
        progressHUD.show(in: self.view)
    }
    func hideProgressHUD() {
        progressHUD.dismiss()
    }
    
    func downloadImage(from urlString: String) async -> UIImage?{
        guard let url = URL(string: urlString) else{
            return nil}
        let session = URLSession.shared
        let data_response = try? await session.data(from: url)
        guard let data = data_response?.0 else{return nil}
        return UIImage(data: data)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getDataFormFile() -> ([CountiesWithPhoneModel],String)
    {
        var country_code = [CountiesWithPhoneModel]()
        if let jsonFile = Bundle.main.path(forResource: "countries", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:Any]]
                {
                    for list in json{
                        let data = CountiesWithPhoneModel.init(id: list["id"] as? Int ?? 0, dial_code: (list["phoneCode"] as? Int ?? 0), countryName: (list["name"] as? String ?? ""), code: (list["sortname"] as? String ?? ""))
                        country_code.append(data)
                    }
                    return (country_code,"")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return ([],"error")
    }
    
    func getCountries() -> [Countries] {
        var countries = [Countries]()
        if let jsonFile = Bundle.main.path(forResource: "countries+states", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:Any]] {
                    for list in json{
                        let data = Countries.init(countryName: (list["name"] as! String), numericCode: (list["numeric_code"] as! String))
                        countries.append(data)
                    }
                    return (countries)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    
    func getStates(country: String) ->[States] {
        var states = [States]()
        if let jsonFile = Bundle.main.path(forResource: "countries+states", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:Any]] {
                    if let firstIndex = json.firstIndex(where: { data in
                        data["name"] as? String == country
                    }){
                        guard let statesJson = json[firstIndex]["states"] as? [[String:Any]] else {return []}
                        for state in statesJson{
                            let data = States.init(stateName: (state["name"] as! String), stateCode: (state["state_code"] as! String))
                            states.append(data)
                        }
                    }
                    return (states)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return []
    }
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func popVC(until specifiedVC: AnyClass){
        for vc in navigationController?.viewControllers ?? []{
            if vc.isKind(of: specifiedVC.self){
                self.navigationController?.popToViewController(vc, animated: false)
            }
        }
    }
    
}

extension BaseClassVC {
    func setBackgroundObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        let notificationCenter1 = NotificationCenter.default
        notificationCenter1.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    @objc func appMovedToForeground() {
        print("App moved to Foreground!")
    }
}

// MARK: - ENUM
enum DataType{
    case dic_arr
    case dic
}

// MARK: - KEY FUNCTIONS
func createAttributedStr(text1: String, text2: String, font1: UIFont, font2: UIFont, textColor1: UIColor = UIColor.white, textColor2: UIColor = UIColor.white) -> NSMutableAttributedString {
    let mutableStr = NSMutableAttributedString()
    let attStr1 = NSAttributedString(string: text1, attributes: [.font: font1, .foregroundColor: textColor1])
    let attStr2 = NSAttributedString(string: text2, attributes: [.font: font2, .foregroundColor: textColor2])
    mutableStr.append(attStr1)
    mutableStr.append(attStr2)
    return mutableStr
}

/// This method converts json to dictionary
func convert(text: String, dataType: DataType = .dic) -> (dic_arr:[[String: Any]]?, dic:[String: Any]?) {
    if let data = text.data(using: .utf8) {
        do {
            switch dataType {
            case .dic_arr:
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                    let dic_arr = jsonObject.map { $0 as! [String: Any] }
                    return (dic_arr, nil)
                }
            case .dic:
                if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    return (nil, dic)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    return (nil,nil)
}

func makeAttributedString(text1:String, text2:String, completeText:String, color1: String, color2: String, font1: UIFont, font2: UIFont) -> NSMutableAttributedString{
    
    let attrString = NSMutableAttributedString(string: completeText)
    let range1 = (completeText as NSString).range(of: text1)
    let range2 = (completeText as NSString).range(of: text2)
    
    attrString.addAttribute(NSAttributedString.Key.font, value: font1, range: range1)
    attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: color1)!, range: range1)
    
    attrString.addAttribute(NSAttributedString.Key.font, value: font2, range: range2)
    attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: color2)!, range: range2)
    return attrString
}
