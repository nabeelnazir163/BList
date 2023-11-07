//
//  UIImage+Ext.swift
//  BList
//
//  Created by iOS Team on 06/05/22.
//

import Foundation
import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    static var EyeIcon: UIImage {
        UIImage(named: "EyeIcon")!
    }
    static var HideIcon: UIImage {
        UIImage(named: "HideIcon")!
    }
}
