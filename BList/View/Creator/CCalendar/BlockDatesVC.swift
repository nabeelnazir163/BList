//
//  BlockDatesVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 05/05/23.
//

import UIKit
import FSCalendar
class BlockDatesVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK: - PROPERTIES
   
    var datePickerFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.MMMdyyyy.rawValue
        return formatter
    }
    var selectedBlockDates  = [Date]()
    var startDate           = Date()
    var endDate             = Date().nextYear
    var expDetails          : GetExperiencesBasedOnDateResponseModel.Experience?
    weak var creatorVM: CreatorViewModel!
    var dateConvertor = DateConvertor.shared
    var callBack:((_ updatedBlockDates: [String])->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        updateCalendar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: creatorVM)
    }
    func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.appearance.headerTitleFont = AppFont.cabinBold
        calendar.appearance.weekdayFont = AppFont.cabinSemiBold
        calendar.appearance.titleFont = AppFont.cabinSemiBold
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.appearance.selectionColor = UIColor.red
        calendar.allowsMultipleSelection = true
        calendar.clipsToBounds = true
    }
    func updateCalendar() {
        creatorVM.blockDates = []
        creatorVM.mentionedWeekDatesInString = []
        creatorVM.expId = expDetails?.id ?? ""
        if expDetails?.expDate ?? "no" == "yes"{
            if let startDate = dateConvertor.convert(dateInString: expDetails?.fromDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date, let endDate = dateConvertor.convert(dateInString: expDetails?.toDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date {
                self.startDate = startDate
                self.endDate = endDate
            }
            
            if let startDate = dateConvertor.convert(dateInString: expDetails?.fromDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date, let endDate = dateConvertor.convert(dateInString: expDetails?.toDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date {
                self.creatorVM.mentionedWeekDatesInString = dateConvertor.getDates(of: expDetails?.weekDayIDs ?? [], from: startDate.dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: Calendar.current)
            }
        }
        else{
            self.creatorVM.mentionedWeekDatesInString = dateConvertor.getDates(of: expDetails?.weekDayIDs ?? [], from: Date(), to: Date().nextYear, dateFormat: .yyyyMMdd, calendar: Calendar.current)
        }
        
        self.creatorVM.blockDates = (expDetails?.blockDates ?? "").components(separatedBy: ",")
        self.creatorVM.blockDates.forEach {calendar.select(dateConvertor.convert(dateInString: $0, from: .yyyyMMdd, to: .yyyyMMdd).date)}
        DispatchQueue.main.async {
            self.calendar.reloadData()
        }
    }
    
    @IBAction func submitAction(_ sender:UIButton) {
        creatorVM.updateBlockDates()
        creatorVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            self.callBack?(self.creatorVM.blockDates)
            self.dismiss(animated: true)
        }
    }
}
// MARK: - FSCALENDAR DELEGATE & DATASOURCE METHODS
extension BlockDatesVC:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    // For coloring event dates. Here count represents number of dots
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if creatorVM.mentionedWeekDatesInString.contains(dateFormatter.string(from: date)) {
            return 1
        }
        return 0
    }
    
    // provide array of colors for dots
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.orange]
    }
    // Prevents scrolling from exceeding minimum date
    func minimumDate(for calendar: FSCalendar) -> Date {
        return startDate
    }
    // Prevents scrolling from exceeding maximum date
    func maximumDate(for calendar: FSCalendar) -> Date {
        return endDate
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if creatorVM.mentionedWeekDatesInString.contains(dateFormatter.string(from: date)) {
            return true
        }
        //Returning false prevents date from selecting
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        creatorVM.blockDates.append(dateFormatter.string(from: date))
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        creatorVM.blockDates.removeAll { blockDate in
            blockDate == dateFormatter.string(from: date)
        }
    }
}
