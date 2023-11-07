//
//  UIButtonExtensions.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 12/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable
@IBDesignable
class CustomLeftImageAndRightText:UIButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightStr      : String = String()
    @IBInspectable var rightColor      : UIColor = UIColor.black
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var titleStr      : String  = String()
    let title = UILabel()
    let rightTitle = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        title.text = titleStr
    }
    override func draw(_ rect: CGRect) {
        let leftImg = UIImageView(image: leftImage)
        leftImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftImg)
        leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        leftImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        title.text = titleStr
        title.font = UIFont.init(name: "Cabin-Regular", size: 16.0)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        rightTitle.text = rightStr
        rightTitle.font = UIFont.init(name: "Cabin-Regular", size: 14.0)
        rightTitle.textColor = rightColor
        rightTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightTitle)
        rightTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        rightTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}


extension UIButton {
    func shadow(color: UIColor, radius: CGFloat, opacity: Float, size: CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}


@IBDesignable
class CustomRightImageButton:UIButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightImage    : UIImage = UIImage()
    var title = UILabel()
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var background_Color    : UIColor = UIColor.clear
    @IBInspectable var titleStr      : String  = String()
    var leftImg : UIImageView!
    var rightImg : UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        if leftImg != nil {
            leftImg.image = leftImage
        }
        if rightImg != nil {
            rightImg.image = rightImage
        }
    }
    override func draw(_ rect: CGRect) {
        leftImg = UIImageView(image: leftImage)
        leftImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftImg)
        leftImg.backgroundColor = background_Color
        leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        leftImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftImg.layer.cornerRadius = leftImg.frame.height/2
        
        title.text = titleStr
        title.font = UIFont.init(name: "Cabin-Medium", size: 14.0)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        rightImg = UIImageView(image: rightImage)
        rightImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightImg)
        rightImg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setData(_ title_Color:UIColor,title:String,left_Image:String,right_Image:String){
        if leftImg != nil{
            leftImg.removeFromSuperview()
        }
        if rightImg != nil{
        rightImg.removeFromSuperview()
        }
        if left_Image != ""{
            leftImage =   UIImage.init(named: left_Image)!
        }
        if right_Image != ""{
            rightImage =  UIImage.init(named: right_Image)!
        }
        titleColor = title_Color
        self.titleStr = title
        draw(self.bounds)
        self.layoutSubviews()
        
    }
    
}
