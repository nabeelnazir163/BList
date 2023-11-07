//
//  MonthYearTextField.swift
//  ConsignItAway
//
//  Created by Rahul Chopra on 28/03/22.
//

import Foundation
import UIKit
import IBAnimatable

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class MonthYearTextField: AnimatableTextField {
    enum PickerType: String {
        case month
        case year
        case monthYear
        case time
    }
    
    @IBInspectable var pickerType: String = "month" {
        didSet {
            if let type = PickerType(rawValue: pickerType) {
                self.type = type
                if type == .month {
                    let monthIndexes = Calendar.current.monthSymbols.enumerated().map({($0.offset + 1).string()})
                    self.componentsArray = monthIndexes
                } else if type == .time {
                    
                } else {
                    var yearsArray = [String]()
                    let year = 2020
                    let currentYear = Calendar.current.component(.year, from: Date())
                    for each in year...(currentYear + 0) {
                        yearsArray.append((each).string())
                    }
                    self.componentsArray = yearsArray
                }
            } else if type == .month {
                self.type = .month
                let monthIndexes = Calendar.current.monthSymbols.enumerated().map({($0.offset + 1).string()})
                self.componentsArray = monthIndexes
            } else {
                self.type = .monthYear
                let monthIndexes = Calendar.current.monthSymbols.enumerated().map({($0.offset + 1).string()})
                
                self.componentsArray = monthIndexes
            }
        }
    }

   @IBInspectable var monthFormat: String = "MMM" {
      didSet {
         if monthFormat == "12" {
            let monthIndexes = Calendar.current.monthSymbols.enumerated().map({($0.offset + 1).string()})
            self.componentsArray = monthIndexes
         } else if monthFormat == "MMM" {
            self.componentsArray = Calendar.current.shortMonthSymbols
         } else if monthFormat == "M" {
            self.componentsArray = Calendar.current.veryShortMonthSymbols
         } else if monthFormat == "MMMM" {
             let monthIndexes = Calendar.current.monthSymbols
             self.componentsArray = monthIndexes
         } else {
            let monthIndexes = Calendar.current.monthSymbols
            self.componentsArray = monthIndexes
         }
      }
   }

   private var contentView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.rgb(r: 222, g: 225, b: 232)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
   }()

   var pickerView: UIPickerView = {
      let pickerView = UIPickerView()
      pickerView.translatesAutoresizingMaskIntoConstraints = false
      return pickerView
   }()

    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
    private var parentVC: UIViewController?
    private let toolBar = UIToolbar()
    private var bottomConstraint: NSLayoutConstraint!
    var isPickerOpened: Bool = false
    private var type: PickerType = .month
    var componentsArray = [String]()
    var months = [String]()
    var years = [Int]()
    var selectedComponent: (month: String, year: String)?
    var closureDidTap: (() -> ())?
    var closureDidSelect: ((Int) -> ())?
    var closureDidDone: (() -> ())?


   // MARK:- INITIALIZERS
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.commonInit()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.commonInit()
   }

   private func commonInit() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(openPickerView))
      self.addGestureRecognizer(tap)
      self.setupMonthYear()
      self.perform(#selector(setupPickerView), with: nil, afterDelay: 0.0)
   }

   @objc private func setupPickerView() {
    if let parentVC = self.parentViewController {
         parentVC.view.addSubview(contentView)
         contentView.addSubview(pickerView)
         self.setupToolBar()
         self.activateConstraints(parentVC: parentVC)

         pickerView.dataSource = self
         pickerView.delegate = self
      }
   }

   private func activateConstraints(parentVC: UIViewController) {
      NSLayoutConstraint.activate([
         contentView.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
         contentView.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),

         pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         pickerView.heightAnchor.constraint(equalToConstant: 200),
         pickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

         toolBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         toolBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         toolBar.topAnchor.constraint(equalTo: contentView.topAnchor),
         toolBar.heightAnchor.constraint(equalToConstant: 50),

         pickerView.topAnchor.constraint(equalTo: toolBar.bottomAnchor)
      ])

      bottomConstraint = contentView.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor, constant: 250)
      bottomConstraint.isActive = true
   }

   private func setupToolBar() {
      toolBar.barStyle = UIBarStyle.default
      toolBar.isTranslucent = true
      toolBar.tintColor = .black
      toolBar.sizeToFit()

       toolBar.isTranslucent = false
       toolBar.barStyle = .default

      let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
      let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

      var chooseTitle = ""
      if type == .month {
         chooseTitle = "Choose Month"
      } else if type == .time {
        chooseTitle = "Choose Time"
      } else {
        chooseTitle = "Choose Year"
      }

      let chooseLabel = UIBarButtonItem(title: chooseTitle, style: .plain, target: nil, action: nil)
      let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))

      toolBar.setItems([cancelButton, spaceButton, chooseLabel, spaceButton2, doneButton], animated: false)
      toolBar.isUserInteractionEnabled = true

      contentView.addSubview(toolBar)
      toolBar.translatesAutoresizingMaskIntoConstraints = false
   }

    @objc func doneTapped() {
        if type == .monthYear {
            let month = convertDate(dateStr: months[pickerView.selectedRow(inComponent: 0)], actualFormat: "MMMM", outputFormat: "MM")
            let year = years[pickerView.selectedRow(inComponent: 1)].string()
            self.selectedComponent = (month: month, year: year)
            self.text = "\(month)/\(year)"
        } else if type == .time {
            let hour = pickerView.selectedRow(inComponent: 0) + 1
            let min = pickerView.selectedRow(inComponent: 1)
//            let sec = pickerView.selectedRow(inComponent: 2)
            let hr = hour < 10 ? "0\(hour)" : "\(hour)"
            let mn = min < 10 ? "0\(min)" : "\(min)"
//            let second = sec < 10 ? "0\(sec)" : "\(sec)"
//            let time = "\(hr):\(mn):\(second)"
            let time = "\(hr):\(mn)"
            self.text = time
        } else {
            self.text = componentsArray[pickerView.selectedRow(inComponent: 0)]
            self.closureDidSelect?(Int(componentsArray[pickerView.selectedRow(inComponent: 0)]) ?? 0)
        }
        
        self.closureDidDone?()
        self.closePickerView()
    }

   @objc func cancelTapped() {
      self.closePickerView()
   }

   func closePickerView() {
      isPickerOpened = !isPickerOpened
      self.bottomConstraint.constant = self.isPickerOpened == true ? 0 : 250
      self.contentView.alpha = self.isPickerOpened == true ? 1.0 : 0.0

      UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
         self.layoutIfNeeded()
         self.contentView.layoutIfNeeded()
         self.superview!.layoutIfNeeded()
         self.parentVC?.view.layoutIfNeeded()
      }, completion: nil)
   }

    @objc func openPickerView() {
        if self.closureDidTap != nil {
            self.closureDidTap!()
        }
        
        if !isPickerOpened {
            self.closePickerView()
        }
    }
    
    func setupMonthYear() {
        if type == .time {
            
            let hourLbl = UILabel(frame: CGRect(x: 0, y: pickerView.frame.size.height / 2, width: 75, height: 30))
            hourLbl.text = "hour"
            pickerView.addSubview(hourLbl)
        } else {
            // population years
            var years: [Int] = []
            if years.count == 0 {
                var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
                for _ in 1...15 {
                    years.append(year)
                    year += 1
                }
            }
            self.years = years
            
            // population months with localized names
            var months: [String] = []
            for i in 0..<12 {
                let dateF = DateFormatter()
                dateF.dateFormat = "MMMM"
                let dateDate = dateF.date(from: dateF.monthSymbols[i])
                dateF.locale = Locale(identifier: "en-US")
                dateF.dateFormat = "MMMM"
                let datt = dateF.string(from: dateDate!)
                months.append(datt.capitalized)
            }
            self.months = months
            
            let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
            self.pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        }
        
    }
    
    func convertDate(dateStr: String, actualFormat: String = "yyyy-MM-dd HH:mm:ss.SSSZ", outputFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en-US")
        df.dateFormat = actualFormat
        if let dateDate = df.date(from: dateStr) {
            
            df.dateFormat = outputFormat
            return df.string(from: dateDate)
        }
        return ""
    }
}


// MARK:- PICKER VIEW DATA SOURCE & DELEGATE METHODS
extension MonthYearTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if type == .time {
            return 2 //3
        } else if type == .monthYear {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if type == .monthYear {
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        } else if type == .time {
            switch component {
            case 0:
                return 12
            case 1:
                return 60
            case 2:
                return 60
            default:
                return 0
            }
        }
        return componentsArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if type == .monthYear {
            switch component {
            case 0:
                return "\(months[row])"
            case 1:
                return "\(years[row])"
            default:
                return nil
            }
        } else if type == .time {
            switch component {
            case 0:
                return row < 9 ? "0\(row + 1)" : "\(row + 1)"
            case 1:
                return row < 10 ? "0\(row)" : "\(row)"
            case 2 :
                return row < 10 ? "0\(row)" : "\(row)"
            default:
                return nil
            }
        }
        return componentsArray[row]
    }

   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
//       if type == .time {
//           if component == 0 {
//               if row == 11 {
//
//               }
//           }
//       }
//      print(componentsArray[row])
   }
}
