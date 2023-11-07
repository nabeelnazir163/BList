//
//  DatePicker+Extension.swift
//  BList
//
//  Created by iOS TL on 29/07/22.
//

import Foundation
import UIKit
extension UITextField {
    private func actionHandler(sender:UIDatePicker,action:((UIDatePicker) -> Void)? = nil) {
        struct __ { static var action :((UIDatePicker) -> Void)? }
        if action != nil { __.action = action }
        else { __.action?(sender) }
    }
    @objc private func triggerActionHandler(sender:UIDatePicker) {
        self.actionHandler(sender: sender)
    }
    func addDatePickere(forMode mode :UIDatePicker.Mode,maxDate:Date? = nil, minDate:Date? = nil,ForAction action:@escaping (UIDatePicker) -> Void) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.backgroundColor = .white
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.datePickerMode = mode
        datePickerView.minimumDate = minDate
        self.inputView = datePickerView
        self.actionHandler(sender:datePickerView, action: action)
        datePickerView.addTarget(self, action:#selector(self.triggerActionHandler(sender:)) , for: .valueChanged)
    }
}
