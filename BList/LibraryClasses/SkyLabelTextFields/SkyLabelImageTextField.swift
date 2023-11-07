//
//  SkyLabelImageTextField.swift
//  ConsignItAway
//
//  Created by Rahul Chopra on 27/01/22.
//

import Foundation
import UIKit

@IBDesignable
class SkyLabelImageTextField: UIView {
    
    /// A UILabel value that identifies the label used to display the icon
    open var iconLabel: UILabel!
    
    /// A UIImageView value that identifies the view used to display the icon
    open var iconImageView: UIImageView!
    open var textField: UITextField!
    open var horizontalLine: UILabel!
    var textChanged :(String) -> () = { _ in }
    
    @IBInspectable var iconImage: UIImage? = nil {
        didSet {
            self.iconImageView.image = iconImage
        }
    }
    
    @IBInspectable var placeholderText: String = "" {
        didSet {
            self.textField.placeholder = placeholderText
            self.iconLabel.text = placeholderText
        }
    }
    
    
    @IBInspectable var textFont: UIFont = .systemFont(ofSize: 15.0) {
        didSet {
            self.textField.font = textFont
        }
    }
    
    @IBInspectable var isSecure: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = isSecure
        }
    }
    
    @IBInspectable var keyboardType: Int = 0 {
        didSet {
            self.textField.keyboardType = UIKeyboardType(rawValue: keyboardType)!
            
//            0: default // Default type for the current input method.
//            1: asciiCapable // Displays a keyboard which can enter ASCII characters
//            2: numbersAndPunctuation // Numbers and assorted punctuation.
//            3: URL // A type optimized for URL entry (shows . / .com prominently).
//            4: numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
//            5: phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
//            6: namePhonePad // A type optimized for entering a person's name or phone number.
//            7: emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).
//            8: decimalPad // A number pad with a decimal point.
//            9: twitter // A type optimized for twitter text entry (easy access to @ #)
            
            if keyboardType == 7 {
                self.textField.autocapitalizationType = .none
            }
        }
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createIcon()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notificaiton:)), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBegin(notificaiton:)), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEnd(notificaiton:)), name: UITextField.textDidEndEditingNotification, object: textField)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createIcon()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notificaiton:)), name: UITextField.textDidChangeNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBegin(notificaiton:)), name: UITextField.textDidBeginEditingNotification, object: textField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEnd(notificaiton:)), name: UITextField.textDidEndEditingNotification, object: textField)
    }
    
    @objc func textDidBegin(notificaiton: NSNotification) {
        self.horizontalLine.backgroundColor = AppColor.app989595
    }
    
    @objc func textDidEnd(notificaiton: NSNotification) {
        self.horizontalLine.backgroundColor = AppColor.app989595
    }
    
    @objc func textDidChange(notificaiton: NSNotification) {
        if let txtField = notificaiton.object as? UITextField {
            if txtField == textField {
                iconLabel.isHidden = txtField.text == ""
            }
        }
    }
    
    
    /// Creates the both icon label and icon image view
    fileprivate func createIcon() {
        createIconLabel()
        createIconImageView()
        createTextField()
        createHorizontalLine()
    }
    
    // Creates the icon label
    fileprivate func createIconLabel() {
        let iconLabel = UILabel()
        iconLabel.backgroundColor = UIColor.clear
        iconLabel.textAlignment = .center
        iconLabel.text = "Password"
        iconLabel.textAlignment = .left
        iconLabel.font = AppFont.cabinRegular.withSize(12.0)
        iconLabel.textColor = UIColor.init(white: 0.0, alpha: 0.4)
        iconLabel.isHidden = true
        iconLabel.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        self.iconLabel = iconLabel
        addSubview(iconLabel)
    }
    
    /// Creates the icon image view
    fileprivate func createIconImageView() {
        let iconImageView = UIImageView()
        iconImageView.backgroundColor = .clear
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        self.iconImageView = iconImageView
        addSubview(iconImageView)
    }
    
    /// Creates the icon image view
    fileprivate func createTextField() {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = "Password"
        iconLabel.font = AppFont.cabinRegular.withSize(15.0)
        self.textField = textField
        addSubview(textField)
    }
    
    
    fileprivate func createHorizontalLine() {
        let horizontalLine = UILabel()
        horizontalLine.backgroundColor = AppColor.app2E2F41
        self.horizontalLine = horizontalLine
        addSubview(horizontalLine)
    }
    
    func setupConstraints() {
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        horizontalLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        horizontalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalLine.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.bottomAnchor.constraint(equalTo: horizontalLine.topAnchor, constant: -5).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        iconImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 0).isActive = true
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        iconLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    // MARK: LISTENER FOR TEXT FIELD
    func bind(callback :@escaping (String) -> ()) {
        textChanged = callback
        self.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
  
    @objc func textFieldDidChange(_ textField :UITextField) {
        print(textField.text!)
        textChanged(textField.text!)
    }
}
