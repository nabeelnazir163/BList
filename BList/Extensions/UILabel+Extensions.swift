//
//  UILabel+Extensions.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 22/11/22.
//

import UIKit
extension UILabel{
    /// This function provides the label width and height
    /// - Returns: Return CGSize of label from which we can get label width and height
    func labelSize(width: Double, height: Double, font: UIFont, text: String) -> CGSize{
        frame = CGRect(x: 0, y: 0, width: width, height: height)
        numberOfLines = 0
        self.font = font
        self.text = text
        sizeToFit()
        return frame.size
    }
}

