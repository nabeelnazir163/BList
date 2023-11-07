//
//  UIView-Ext.swift
//  BList
//
//  Created by iOS Team on 09/05/22.
//

import Foundation
import UIKit
import IBAnimatable

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}

class CustomTextFieldView: UIView {

  private var usernameLabelYAnchorConstraint: NSLayoutConstraint!
  private var usernameLabelLeadingAnchor: NSLayoutConstraint!

  private lazy var usernameLBL: UILabel! = {
    let label = UILabel()
    label.text = "Username"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.alpha = 0.5
    return label
  }()

  private lazy var usernameTextField: UITextField! = {
    let textLabel = UITextField()
    textLabel.borderStyle = .roundedRect
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    return textLabel
  }()

  init() {
    super.init(frame: UIScreen.main.bounds)
    addSubview(usernameTextField)
    addSubview(usernameLBL)
    backgroundColor = UIColor(white: 1, alpha: 1)
    usernameTextField.delegate = self

    configureViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureViews() {
    let margins = self.layoutMarginsGuide
    usernameLabelYAnchorConstraint = usernameLBL.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor, constant: 0)
    usernameLabelLeadingAnchor = usernameLBL.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor, constant: 5)

    NSLayoutConstraint.activate([
      usernameTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
      usernameTextField.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
      usernameTextField.widthAnchor.constraint(equalToConstant: 100),
      usernameTextField.heightAnchor.constraint(equalToConstant: 25),

      usernameLabelYAnchorConstraint,
      usernameLabelLeadingAnchor,
      ])
  }

}

extension CustomTextFieldView: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    usernameLabelYAnchorConstraint.constant = -25
    usernameLabelLeadingAnchor.constant = 0
    performAnimation(transform: CGAffineTransform(scaleX: 0.8, y: 0.8))
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text, text.isEmpty {
      usernameLabelYAnchorConstraint.constant = 0
      usernameLabelLeadingAnchor.constant = 5
      performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }
  }

  fileprivate func performAnimation(transform: CGAffineTransform) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.usernameLBL.transform = transform
      self.layoutIfNeeded()
    }, completion: nil)
  }

}


class CustomRightAndLeftImageButton:AnimatableButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightImage    : UIImage = UIImage() {
        didSet {
            if rightImg != nil {
                rightImg.image = rightImage
            }
        }
    }
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var background_Color    : UIColor = UIColor.clear
    @IBInspectable var titleStr      : String  = "" {
        didSet {
            title.text = titleStr
        }
    }
    @IBInspectable var isCenterFlag : Bool = true
    var leftImg : UIImageView!
    var rightImg : UIImageView!
    let title = UILabel()
    
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
        if isCenterFlag{
            leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        }
        else{
            leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        }
       
        leftImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftImg.layer.cornerRadius = leftImg.frame.height/2
//        let title = UILabel()
        title.text = titleStr
        title.backgroundColor = .clear
        title.font = UIFont.init(name: "Cabin-Regular", size: 16.0)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        rightImg = UIImageView(image: rightImage)
        rightImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightImg)
        rightImg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        if isCenterFlag{
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        else{
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        }
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    func setData(_ title_Color:UIColor,left_Image:String,right_Image:String){
        leftImg.removeFromSuperview()
        rightImg.removeFromSuperview()
        leftImage =   UIImage.init(named: left_Image)!
        rightImage =  UIImage.init(named: right_Image)!
        titleColor = title_Color
        draw(self.bounds)
        self.layoutSubviews()
        
    }
    
}
public extension UIButton {

    func alignTextRight(spacing: CGFloat = 6.0,text:String = "") {
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
    }

}
