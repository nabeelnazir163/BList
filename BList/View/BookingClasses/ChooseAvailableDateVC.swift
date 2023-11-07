//
//  ChooseAvailableDateVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import FSCalendar
import IBAnimatable
import Loaf
class ChooseAvailableDateVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var noOfInfantLbl                : UILabel!
    @IBOutlet weak var noOfChildLbl                 : UILabel!
    @IBOutlet weak var noofAdultLbl                 : UILabel!
    @IBOutlet weak var strtDateTxtField             : AnimatableTextField!
    @IBOutlet weak var endDateTxtField              : AnimatableTextField!
    @IBOutlet weak var txt_dateRequest              : AnimatableTextField!
    @IBOutlet weak var txt_TimeRequest              : AnimatableTextField!
    @IBOutlet weak var calendar                     : FSCalendar!
    @IBOutlet weak var adults_View                  : UIView!
    @IBOutlet weak var children_View                : UIView!
    @IBOutlet weak var infact_View                  : UIView!
    @IBOutlet weak var collection_TimeSlot          : UICollectionView!{
        didSet{
            collection_TimeSlot.delegate = self
            collection_TimeSlot.dataSource = self
        }
    }
    
    @IBOutlet weak var collection_TimeSlot_Nslayout : NSLayoutConstraint!
    @IBOutlet weak var date_timeRequestSV           : UIStackView!
    @IBOutlet weak var availabilitySV               : UIStackView!
    @IBOutlet var radio_btns                        : [UIButton]!
    @IBOutlet weak var pickDateTF                   : UITextField!
    @IBOutlet weak var pickTimeTF                   : UITextField!
    @IBOutlet weak var datesCount                   : UILabel!
    @IBOutlet weak var notes_Lbl                    : UILabel!
    @IBOutlet weak var notesView                    : UIView!
    // MARK: - PROPERTIES
    var timeSlotList = [TimeSlotData]()
    var datesRange = [Date](){
        didSet{
            datesCount.text = "\(datesRange.count) available"
        }
    }
    var availableDates = [String](){
        didSet{
            datesCount.text = "\(availableDates.count) available"
            calendar.reloadData()
        }
    }
    var selectedSlot = [(date:String,slotTime:String)]()
    weak var viewModel: UserViewModel!
    let highlightedColorForRange = UIColor.init(red:249/255, green: 106/255, blue: 39/238, alpha: 0.2)
    var selectedExpId = ""
    var selectedDate: String = ""
    let dateConverter = DateConvertor.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewModel = UserViewModel(type: .BookExperience)
        viewModel.modelType = .ChooseAvailableDate
        setUpVM(model: viewModel)
        setUpCalendar()
        addDatePickers()
        getAvailableDatesAndSlots()
    }
    
    func getAvailableDatesAndSlots(){
        let expDetails = viewModel.expDetail?.expDetail
        let availableSlots =  (expDetails?.timeSlots ?? "").components(separatedBy: ",")
        if expDetails?.expDate ?? "no" == "yes"{
//            let selectedDates = (expDetails?.selectedDates ?? "").components(separatedBy: ",")
//            availableDates = selectedDates
            if let startDate = dateConverter.convert(dateInString: expDetails?.expStartDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date, let endDate = dateConverter.convert(dateInString: expDetails?.expEndDate ?? "", from: .yyyyMMdd, to: .yyyyMMdd).date {
                availableDates = dateConverter.getDates(of: expDetails?.weekDayIDs ?? [], from: startDate.dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: Calendar.current)
            }
        }
        else{
            availableDates = dateConverter.getDates(of: viewModel.expDetail?.expDetail?.weekDayIDs ?? [], from: Date(), to: Date().nextYear, dateFormat: .yyyyMMdd, calendar: Calendar.current)
        }
        let blockDates = (viewModel.expDetail?.expDetail?.blockDates ?? "").components(separatedBy: ",")
        availableDates.removeAll { date in
            blockDates.contains { blockDate in
                blockDate == date
            }
        }
        if availableDates.count > 0 && availableSlots.count > 0{
                viewModel.time_SlotList = availableDates.map{
                    TimeSlotData(date: $0, isSelected: false, slotTimes: availableSlots)
            }
        }
        availabilitySV.isHidden = true
        /*DispatchQueue.main.async {
            self.timeSlotList = self.viewModel.time_SlotList
            self.collection_TimeSlot_Nslayout.constant = self.collection_TimeSlot.setCollectionHeight()
        }*/
        
        if let startDate = dateFormatter.date(from: viewModel.expDetail?.expDetail?.expStartDate ?? ""){
            showCalendar(for: startDate)
        }
        
    }
    
    /// Shows the page of the calendar that contains the given date
    func showCalendar(for givenDate: Date){
        let calendar = FSCalendar()
        let components = givenDate.get(components: .month,.year)
        if let year = components.year, let month = components.month{
            var dateComponents = DateComponents()
            dateComponents.setValue(month, for: .month)
            dateComponents.setValue(year, for: .year)
            let date = Calendar.current.date(from: dateComponents)
            calendar.setCurrentPage(date!, animated: true)
        }
    }
    
    func setUpCalendar(){
        calendar.delegate                        = self
        calendar.dataSource                      = self
        calendar.today                           = nil
        calendar.locale = .current
        calendar.appearance.headerTitleFont      = AppFont.cabinBold
        calendar.appearance.weekdayFont          = AppFont.cabinSemiBold
        calendar.appearance.selectionColor       = AppColor.orange
        calendar.appearance.titleFont            = AppFont.cabinSemiBold
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.clipsToBounds = true
    }
    
    func addDatePickers(){
        pickDateTF.addDatePicker(minDate: Date(),
                                 maxDate: nil,
                                 target: self,
                                 selector: #selector(requestDateAction(_:)))
        pickTimeTF.addDatePicker(mode: .time, minDate: nil,
                                 maxDate: nil,
                                 target: self,
                                 selector: #selector(requestTimeAction(_:)))
    }
    
    @objc func requestDateAction(_ sender:UITextField) {
        if let datePicker = self.pickDateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
            self.pickDateTF.text = dateFormatter.string(from: datePicker.date)
            self.viewModel.requestDate = dateFormatter.string(from: datePicker.date)
        }
        self.pickDateTF.resignFirstResponder()
    }
    
    @objc func requestTimeAction(_ sender:UITextField) {
        if let datePicker = self.pickTimeTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = DateFormat.HHmm.rawValue
            self.pickTimeTF.text = dateFormatter.string(from: datePicker.date)
            self.viewModel.requestTime = pickTimeTF.text ?? ""
        }
        self.pickTimeTF.resignFirstResponder()
    }
    
    // MARK: - IBACTIONS
    @IBAction func selectTimeSlotAction(_ sender: UIButton) {
        if viewModel.time_SlotList.count > 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeSlotListVC") as! TimeSlotListVC
            vc.delegate = self
            vc.viewModel = viewModel
            vc.selectedDate = selectedDate
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
    }
    
    @IBAction func yes_or_noBtnAction(_ sender:UIButton){
        if sender.tag == 0{
            // YES
            date_timeRequestSV.isHidden = false
            notesView.isHidden = false
        }
        else{
            // NO
            date_timeRequestSV.isHidden = true
            notesView.isHidden = true
        }
        radio_btns.forEach({$0.setImage(UIImage.init(named: "radio"), for: .normal)})
        radio_btns[sender.tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
    }
    
    @IBAction func actionAdultIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfAdult > 0 {
                viewModel.noOfAdult -= 1
                noofAdultLbl.text = "\(viewModel.noOfAdult)"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .adult){
                    viewModel.noOfAdult += 1
                } else {
                    showErrorMessages(message: "This experience doesn't allow adults because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noofAdultLbl.text = "\(viewModel.noOfAdult)"
            }
        }
    }
    
    func eligibleToAdd(person: Person) -> Bool{
        let minAge = Int(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") ?? 0
        let maxAge = Int(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") ?? 0
        switch person {
        case .adult:
            return (minAge ... maxAge).contains { age in
                age >= 12
            }
        case .children:
            return (minAge ... maxAge).contains { age in
                age >= 2 && age <= 12
            }
        case .infant:
            return (minAge ... maxAge).contains { age in
                age < 2
            }
        }
    }
    func isGuestCountUnderLimit() -> Bool{
        
        if (viewModel.guestCount) < Int(viewModel.expDetail?.expDetail?.maxGuestLimit ?? "0") ?? 0{
            return true
        }
        else{
            showErrorMessages(message: "Guest limit reached.")
            return false
        }
    }
    @IBAction func actionChildIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfChild > 0 {
                viewModel.noOfChild -= 1
                noOfChildLbl.text = "\(viewModel.noOfChild)"
            } else {
                viewModel.noOfChild = 0
                noOfChildLbl.text = "0"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .children){
                    viewModel.noOfChild += 1
                }
                else{
                    showErrorMessages(message: "This experience doesn't allow children because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noOfChildLbl.text = "\(viewModel.noOfChild)"
            }
        }
    }
    @IBAction func actionInfantIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfInfant > 0 {
                viewModel.noOfInfant -= 1
                noOfInfantLbl.text = "\(viewModel.noOfInfant)"
            } else {
                viewModel.noOfInfant = 0
                noOfInfantLbl.text = "0"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .infant){
                    viewModel.noOfInfant += 1
                }
                else{
                    showErrorMessages(message: "This experience doesn't allow infants because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noOfInfantLbl.text = "\(viewModel.noOfInfant)"
            }
        }
    }
    @IBAction func crossAction(_ sender :UIButton) {
        for view in self.navigationController?.viewControllers ?? []{
            if view.isKind(of: NewlyExperienceDetail.self){
                clearModelData()
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
    func clearModelData(){
        viewModel.noOfChild = 0
        viewModel.noOfAdult = 0
        viewModel.noOfInfant = 0
        viewModel.guestCount = 0
        viewModel.selectedTimeSlot = []
        viewModel.requestTime = ""
        viewModel.requestDate = ""
    }
    @IBAction func nextTapped(_ sender :UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
    }
    @IBAction func noteAction(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.notes = self.viewModel.notes.value
        vc.closureDidAddNote = { [weak self] (note) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.viewModel.notes.value = note
                self.notes_Lbl.text = note
            }
        }
        self.present(vc, animated:true, completion: nil)
    }
    @IBAction func doneAction(_ sender :UIButton) {
        if selectedSlot.count > 0{
            convertTupleToDic()
        }
        if viewModel.isValid {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewBookingVC") as! ReviewBookingVC
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
    @IBAction  func previousTapped(_ sender :UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    func convertTupleToDic(){
        
        let dic = ["date":selectedSlot[0].date ,"slots":selectedSlot[0].slotTime] as [String: AnyObject]
        viewModel.selectedTimeSlot = [dic]
        /*
         let selectedTimeSlot = selectedSlot[0].slotTime.components(separatedBy: "-")
         if let startTime = DateConvertor.shared.convert(dateInString: selectedTimeSlot[0], from: .hhmma, to: .HHmm).dateInString, let endTime = DateConvertor.shared.convert(dateInString: selectedTimeSlot[1], from: .hhmma, to: .HHmm).dateInString {
             let timeslot24Hr = "\(startTime)-\(endTime)"
             let dic = ["date":selectedSlot[0].date ,"slots":timeslot24Hr] as [String: AnyObject]
             viewModel.selectedTimeSlot = [dic]
         }
         */
        
    }
}

// MARK: - FSCALENDAR DELEGATE, DATASOURCE & APPEARANCE METHODS
extension ChooseAvailableDateVC:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    /*
     // Prevents scrolling from exceeding minimum date
     func minimumDate(for calendar: FSCalendar) -> Date {
     guard let date = formatter.date(from: viewModel.expDetail?.expDetail?.expStartDate ?? "") else{return .init()}
     return date
     }
     // Prevents scrolling from exceeding maximum date
     func maximumDate(for calendar: FSCalendar) -> Date {
     guard let date = formatter.date(from: viewModel.expDetail?.expDetail?.expEndDate ?? "") else{return .init()}
     return date
     }
     */
    
    // For coloring event dates. Here count represents number of dots
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if availableDates.contains(dateFormatter.string(from: date)) {
            return 1
        }
        return 0
    }
    
    // provide array of colors for dots
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.orange]
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selected date \(dateFormatter.string(from: date))")
        // nothing selected:
        selectedDate = dateFormatter.string(from: date)
        if !availableDates.contains(dateFormatter.string(from: date)){
            selectedDate = ""
            showErrorMessages(message: "Please select one of the available dates")
            availabilitySV.isHidden = true
            //timeSlotList = viewModel.time_SlotList
        }
        else{
            if viewModel.time_SlotList.count > 0{
                if selectedDate != ""{
                    timeSlotList = viewModel.time_SlotList.filter({ timeslot in
                        timeslot.date == selectedDate
                    })
                    availabilitySV.isHidden = false
                }
            }
        }
        collection_TimeSlot_Nslayout.constant = collection_TimeSlot.getCollectionHeight()
    }
    
    /*func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
     if datesRange.contains(date) {
     return true
     }
     //Returning false prevents date from selecting
     return false
     }*/
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected date \(dateFormatter.string(from: date))")
    }
    
}
class TitleHeader: UICollectionReusableView{
    @IBOutlet weak var title: UILabel!
}
