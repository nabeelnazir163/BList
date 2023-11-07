//
//  Extensions.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/11/22.
//

import UIKit

// MARK: - UICOLOR
extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}

// MARK: - DICTIONARY
extension Dictionary where Key == String, Value:Any {
    func convertJSONtoString() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

// MARK: - UIVIEW
extension UIView{
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - UIVIEWCONTROLLER
extension UIViewController{
    func resignText(txtFields: [UITextField]) {
        txtFields.forEach{
            print($0.isFirstResponder)}
        txtFields.forEach({$0.resignFirstResponder()})
    }
}

// MARK: - UICOLLECTIONVIEW
extension UICollectionView{
    func getCollectionHeight() -> Double{
        self.reloadData()
        self.layoutIfNeeded()
        return self.contentSize.height
    }
}
extension UITableView{
    func getTableHeight() -> Double{
        self.reloadData()
        self.layoutIfNeeded()
        return self.contentSize.height
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    /// This method converts array of dictionary to json array
    ///
    /// Ex: let array_dict: [[String:AnyObject]] =[
    ///
    ///  ["abc":123, "def": "ggg", "xyz": true],
    ///  ["abc":456, "def": "hhh", "xyz": false]
    ///
    /// ]
    ///
    ///print(arrayOfDictionaries.toJSONString())
    ///
    ///[{
    ///  "abc" : 123,
    ///  "def" : "ggg",
    ///  "xyz" : true
    ///},
    ///
    ///{
    ///  "abc" : 456,
    ///  "def" : "hhh",
    ///  "xyz" : false
    ///}]
    func toJSONArray() -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

