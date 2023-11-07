//
//  UITextField-Ext.swift
//  BList
//
//  Created by iOS TL on 11/07/22.
//

import Foundation
import UIKit

extension UITextField {
    func addInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = Date()
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    func addDatePicker(mode: UIDatePicker.Mode = .date, timeFormat: LocaleID? = .none,minDate: Date? = nil, maxDate: Date? = nil, target: Any, selector: Selector) {
        //Add DatePicker as inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = mode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        if let localeId = timeFormat{
            datePicker.locale = Locale(identifier: localeId.rawValue)
        }
        if let minDate = minDate {
            datePicker.minimumDate = minDate
        }
        if let maxDate = maxDate {
            datePicker.maximumDate = maxDate
        }
      
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        doneBarButton.tag = self.tag
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
        
        /*
         var comps = DateComponents()
         comps.year = 40
         let max_Date = calendar.date(byAdding: comps, to: Date())
         
         if mode == .date {
         datePicker.minimumDate = minDate
         let isToday = Calendar.current.isDateInToday(maxDate)
         if isToday{
         datePicker.maximumDate = max_Date
         }
         else{
         datePicker.maximumDate = maxDate
         }
         }*/
        
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
