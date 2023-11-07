//
//  PickerView.swift
//  BList
//
//  Created by iOS Team on 11/07/22.
//

import Foundation
import UIKit


class PickerView: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var toolBar = UIToolbar()
    private var picker  = UIPickerView()
    var data = [String]()
    var selectedData: String = "Male"
    var closureDidSelect: ((String) -> ())?
    
    func showPicker(view: UIView, data: [String]) {
        self.data = data
        self.selectedData = "Male"
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.isTranslucent = true
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        self.closureDidSelect?(selectedData)
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(data[row])
        self.selectedData = data[row]
    }
}
