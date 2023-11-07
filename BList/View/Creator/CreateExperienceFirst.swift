//
//  CreateExperienceFirst.swift
//  BList
//
//  Created by iOS Team on 15/10/22.
//

import UIKit
import FSCalendar
class CreateExperienceFirst: BaseClassVC {
    // MARK: - Outlets
    @IBOutlet weak var calendar                 : FSCalendar!
    @IBOutlet weak var collection_days          : UICollectionView!
    @IBOutlet weak var txt_startDate            : UITextField!{
        didSet{
            txt_startDate.inputView = UIView()
            txt_startDate.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var txt_endDate              : UITextField!{
        didSet{
            txt_endDate.inputView = UIView()
            txt_endDate.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var txt_startTime            : UITextField!{
        didSet{
            txt_startTime.inputView = UIView()
            txt_startTime.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var txt_endTime              : UITextField!{
        didSet{
            txt_endTime.inputView = UIView()
            txt_endTime.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var fromTimeTF               : UITextField!{
        didSet{
            fromTimeTF.inputView = UIView()
            fromTimeTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var toTimeTF                 : UITextField!{
        didSet{
            toTimeTF.inputView = UIView()
            toTimeTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var txt_day                  : AnimatedBindingText!{
        didSet {
            txt_day.bind{[unowned self] in self.creatorVM.exp_duration_days.value = $0 } }
    }
    @IBOutlet weak var txt_hours                : AnimatedBindingText!{
        didSet {
            txt_hours.bind{[unowned self] in self.creatorVM.exp_duration_hours.value = $0 } }
    }
    @IBOutlet weak var txt_minutes              : AnimatedBindingText!{
        didSet {
            txt_minutes.bind{[unowned self] in self.creatorVM.exp_duration_minutes.value = $0 } }
    }
    @IBOutlet  var btn_startEnd                 : [UIButton]!
    @IBOutlet  var btn_ExperienceDuration       : [UIButton]!
    @IBOutlet  var btn_Availablity              : [UIButton]!
    @IBOutlet weak var stack_ExperienceDuration : UIStackView!
    @IBOutlet weak var stack_Availability       : UIStackView!
    @IBOutlet weak var stack_duration           : UIStackView!
    @IBOutlet weak var lbl_duration             : UILabel!
    @IBOutlet weak var addTimeSlotBtn           : UIButton!
    @IBOutlet weak var timeSlotsTV              : UITableView!{
        didSet{
            timeSlotsTV.delegate = self
            timeSlotsTV.dataSource = self
        }
    }
    @IBOutlet weak var tableHeight              : NSLayoutConstraint!
    @IBOutlet weak var blockDatesLbl            : UILabel!
    // MARK: - PROPERTIES
    weak var creatorVM  : CreatorViewModel!
    weak var delegate   : changeModelType?
    var startDate       = Date()
    var endDate         = Date().nextYear
    var startTime       : Date?
    var fromTime        : Date?
    var toTime          : Date?
    var datesRange      : [Date]?
    var selectedBlockDates = [Date]()
    var datePickerFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.MMMdyyyy.rawValue
        return formatter
    }
    var timePickerFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = DateFormat.HHmm.rawValue
        return formatter
        
    }
    let highlightedColorForRange = UIColor.init(red:249/255, green: 106/255, blue: 39/238, alpha: 0.2)
    
    //MARK: - LIFE CYCLE METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorVM.modelType = .CreateExperienceWithDateAndTime
        addTargetActions()
        setUpCalendar()
        setData()
        setUpVM(model: creatorVM)
        // Do any additional setup after loading the view.
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeSlotsTV.layoutIfNeeded()
        tableHeight.constant = timeSlotsTV.contentSize.height
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let expDetails = creatorVM.expDetails{
            selectDayInWeekAction()
        }
    }
    // MARK: - KEY FUNCTIONS
    func setUpCalendar(){
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.appearance.headerTitleFont      = AppFont.cabinBold
        calendar.appearance.weekdayFont          = AppFont.cabinSemiBold
        calendar.appearance.titleFont            = AppFont.cabinSemiBold
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.selectionColor       = UIColor.red
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.allowsMultipleSelection = true
        calendar.clipsToBounds = true
    }
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    func addTargetActions(){
        // StartDateTF
        txt_startDate.addDatePicker(minDate: Date(),maxDate:nil,target: self,selector: #selector(startDateAction))
        
        // Editing DidBegin Targets
        txt_endDate.addTarget(self, action: #selector(endDateTFAction(_:)), for: .editingDidBegin)
        txt_startTime.addTarget(self, action: #selector(timeTFAction(_:)), for: .editingDidBegin)
        txt_endTime.addTarget(self, action: #selector(timeTFAction(_:)), for: .editingDidBegin)
        fromTimeTF.addTarget(self, action: #selector(timeTFAction(_:)), for: .editingDidBegin)
        toTimeTF.addTarget(self, action: #selector(timeTFAction(_:)), for: .editingDidBegin)
        
        // Editing DidEnd Targets
        txt_hours.addTarget(self, action: #selector(durationEndAction(_:)), for: .editingDidEnd)
        txt_minutes.addTarget(self, action: #selector(durationEndAction(_:)), for: .editingDidEnd)
        
        addTimeSlotBtn.addTarget(self, action: #selector(addTimeSlotAction(_:)), for: .touchUpInside)
        
    }
    func setData(){
        txt_startDate.text = self.creatorVM.expStartDate.value
        if let startDate = DateConvertor.shared.convert(dateInString: creatorVM.expStartDate.value, from: .yyyyMMdd, to: .yyyyMMdd).date, let endDate = DateConvertor.shared.convert(dateInString: creatorVM.expEndDate.value, from: .yyyyMMdd, to: .yyyyMMdd).date{
            self.startDate = startDate
            self.endDate = endDate
            datesRange = BList.datesRange(from: startDate, to: endDate)
            self.creatorVM.mentionedWeekDatesInString = DateConvertor.shared.getDates(of: creatorVM.days.filter{$0.selection == true}.map{$0.dayId}, from: (startDate).dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: .current)
            blockDatesLbl.text = "Block Dates Available"
            calendar.reloadData()
        }
        txt_endDate.text = self.creatorVM.expEndDate.value
        txt_startTime.text = self.creatorVM.expStartTime.value
        txt_endTime.text = self.creatorVM.expEndTime.value
        txt_day.text = self.creatorVM.exp_duration_days.value
        txt_hours.text = self.creatorVM.exp_duration_hours.value
        txt_minutes.text = self.creatorVM.exp_duration_minutes.value
        isStart(creatorVM.hasStartEndDate.value == "yes" ? 0: 1)
        isDuration(creatorVM.hasTimeDuration.value == "yes" ? 0 : 1)
        isAvailability(creatorVM.hasTimeDuration.value == "yes" ? 0 : 1)
        if creatorVM.timeSlots.count > 0 {
            timeSlotsTV.isHidden = false
            timeSlotsTV.reloadData()
        }
        for blockDateInString in creatorVM.blockDates{
            if let blockDate = DateConvertor.shared.convert(dateInString: blockDateInString, from: .yyyyMMdd, to: .yyyyMMdd).date{
                selectedBlockDates.append(blockDate)
                calendar.select(blockDate)
            }
        }
    }
    func isAvailability(_ tag : Int){
        creatorVM.slotAvailability.value = tag == 0 ? "yes" : "no"
        btn_Availablity.forEach({$0.setImage(UIImage.init(named: "radio_button"), for: .normal)})
        btn_Availablity[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
        stack_Availability.isHidden = tag == 0 ? false : true
    }
    func isStart(_ tag : Int){
        creatorVM.hasStartEndDate.value = tag == 0 ? "yes" : "no"
        if creatorVM.hasStartEndDate.value == "no"{
            blockDatesLbl.text = "Block Dates Not Available"
        }
        btn_startEnd.forEach({$0.setImage(UIImage.init(named: "radio_button"), for: .normal)})
        btn_startEnd[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
        stack_ExperienceDuration.isHidden = tag == 0 ? false : true
    }
    func isDuration(_ tag : Int){
        btn_ExperienceDuration.forEach({$0.setImage(UIImage.init(named: "radio_button"), for: .normal)})
        btn_ExperienceDuration[tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
        stack_duration.isHidden = tag == 0 ? false : true
        lbl_duration.isHidden = tag == 0 ? false : true
        creatorVM.hasTimeDuration.value = tag == 0 ? "yes" : "no"
    }
    // MARK: - OBJ FUNCTIONS
    @objc func durationEndAction(_ sender:UITextField){
        if fromTime != nil{
            set_ToTime()
        }
    }
    @objc func endDateTFAction(_ sender:UITextField){
        if (txt_startDate.text ?? "").isEmptyOrWhitespace(){
            sender.resignFirstResponder()
            showErrorMessages(message: "First pick start date")
        }
    }
    @objc func timeTFAction(_ sender:UITextField){
        if sender.tag == 0{
            // Start Time
            if (txt_startDate.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "First pick start date")
                sender.resignFirstResponder()
            }
            else{
                if self.txt_startDate.text != datePickerFormatter.string(from: Date()){
                    txt_startTime.addDatePicker(mode: .time, timeFormat: .Hour_24, minDate: nil, maxDate:nil, target: self, selector: #selector(startTimeAction))
                }
                else{
                    txt_startTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate: Date(),maxDate: nil,target: self,selector: #selector(startTimeAction))
                }
            }
        }
        else if sender.tag == 1{
            // End Time
            if (txt_startDate.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "First pick start date")
                sender.resignFirstResponder()
            }
            else if (txt_endDate.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "First pick end date")
                sender.resignFirstResponder()
            }
            else if (txt_startTime.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "First pick start time")
                sender.resignFirstResponder()
            }
            else{
                if txt_startDate.text == txt_endDate.text{
                    txt_endTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate: startTime,maxDate:  nil,target: self,selector: #selector(endTimeAction))
                }
                else{
                    txt_endTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate:  nil,maxDate:  nil,target: self,selector: #selector(endTimeAction))
                }
            }
        }
        else if sender.tag == 2{
            // From Time
            if (txt_hours.text ?? "").isEmptyOrWhitespace() && (txt_minutes.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "Please select duration")
                sender.resignFirstResponder()
            }
            else{
                fromTimeTF.addDatePicker(mode:.time, timeFormat: .Hour_24, minDate:nil,maxDate:nil,target: self,selector: #selector(fromTimeAction))
            }
        }
        else{
            // To Time
            if (fromTimeTF.text ?? "").isEmptyOrWhitespace(){
                showErrorMessages(message: "First pick start time")
            }
            sender.resignFirstResponder()
        }
    }
    @objc func addTimeSlotAction(_ sender:UIButton){
        if (fromTimeTF.text ?? "").isEmptyOrWhitespace(){
            showErrorMessages(message: "Please enter start time")
        }
        else if (toTimeTF.text ?? "").isEmptyOrWhitespace(){
            showErrorMessages(message: "Please enter end time")
        }
        else{
            self.creatorVM.timeSlots.append(SlotList(slotStartTime: fromTimeTF.text ?? "", slotEndTime: toTimeTF.text ?? "", isSelected: false))
            timeSlotsTV.isHidden = false
            fromTimeTF.text?.removeAll()
            toTimeTF.text?.removeAll()
            timeSlotsTV.reloadData()
        }
    }
    @objc func fromTimeAction(){
        if let datePicker = self.fromTimeTF.inputView as? UIDatePicker {
            self.fromTimeTF.text = timePickerFormatter.string(from: datePicker.date)
            fromTime = datePicker.date
            set_ToTime()
        }
        self.fromTimeTF.resignFirstResponder()
    }
    func set_ToTime(){
        if let hours = Int(txt_hours.text ?? ""), let minutes = Int(txt_minutes.text ?? ""), hours != 0, minutes != 0{
            toTime = fromTime?.adding(hours: hours, minutes: minutes)
        }
        else if let hours = Int(txt_hours.text ?? ""), hours != 0{
            toTime = fromTime?.adding(hours: hours)
        }
        else if let minutes = Int(txt_minutes.text ?? ""), minutes != 0{
            toTime = fromTime?.adding(minutes: minutes)
        }
        if let toTime = toTime{
            self.toTimeTF.text = timePickerFormatter.string(from: toTime)
        }
    }
    @objc func startTimeAction() {
        if let datePicker = self.txt_startTime.inputView as? UIDatePicker {
            
            self.txt_startTime.text = timePickerFormatter.string(from: datePicker.date)
            self.creatorVM.expStartTime.value = timePickerFormatter.string(from: datePicker.date)
            startTime = datePicker.date
            if txt_startDate.text == txt_endDate.text{
                txt_endTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate:  startTime,maxDate:  nil,target: self,selector: #selector(endTimeAction))
            }
            else{
                txt_endTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate:  nil,maxDate:  nil,target: self,selector: #selector(endTimeAction))
            }
            
        }
        self.txt_startTime.resignFirstResponder()
    }
    
    @objc func endTimeAction() {
        if let datePicker = self.txt_endTime.inputView as? UIDatePicker {
            self.txt_endTime.text = timePickerFormatter.string(from: datePicker.date)
            self.creatorVM.expEndTime.value = timePickerFormatter.string(from: datePicker.date)
        }
        self.txt_endTime.resignFirstResponder()
    }
    @objc func startDateAction() {
        
        if let datePicker = self.txt_startDate.inputView as? UIDatePicker {
            self.startDate = datePicker.date
            self.txt_startDate.text = datePickerFormatter.string(from: datePicker.date)
            self.creatorVM.expStartDate.value = dateFormatter.string(from: datePicker.date)
            //DateConvertor.shared.convert(date: txt_startDate.text!, inputFormat: .MMMddyyyy, outputFormat: .yyyyMMdd)
            if self.txt_startDate.text != datePickerFormatter.string(from: Date()){
                txt_startTime.addDatePicker(mode: .time, timeFormat: .Hour_24, minDate: nil, maxDate:nil, target: self, selector: #selector(startTimeAction))
            }
            else{
                txt_startTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate: Date(),maxDate: nil,target: self,selector: #selector(startTimeAction))
            }
            txt_endDate.addDatePicker(minDate: datePicker.date, maxDate:nil, target: self, selector: #selector(endDateAction))
            self.creatorVM.mentionedWeekDatesInString = DateConvertor.shared.getDates(of: creatorVM.days.filter{$0.selection == true}.map{$0.dayId}, from: (startDate).dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: .current)
            calendar.reloadData()
        }
        self.txt_startDate.resignFirstResponder()
    }
    
    @objc func endDateAction() {
        if let datePicker = self.txt_endDate.inputView as? UIDatePicker {
            endDate = datePicker.date
            self.txt_endDate.text = datePickerFormatter.string(from: datePicker.date)
            self.creatorVM.expEndDate.value = dateFormatter.string(from: datePicker.date)
            //DateConvertor.shared.convert(date: txt_endDate.text!, inputFormat: .MMMddyyyy, outputFormat: .yyyyMMdd)
            
            if txt_startDate.text ?? "" == txt_endDate.text ?? ""{
                txt_endTime.addDatePicker(mode: .time,timeFormat: .Hour_24, minDate:  startTime,maxDate:  nil,target: self,selector: #selector(endTimeAction))
            }
            datesRange = BList.datesRange(from: startDate, to: endDate)
            self.creatorVM.mentionedWeekDatesInString = DateConvertor.shared.getDates(of: creatorVM.days.filter{$0.selection == true}.map{$0.dayId}, from: (startDate).dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: .current)
            blockDatesLbl.text = "Block Dates Available"
            calendar.reloadData()
        }
        self.txt_endDate.resignFirstResponder()
    }
    @objc func slotDeleteBtnAction(_ sender:UIButton){
        creatorVM.timeSlots.remove(at: sender.tag)
        timeSlotsTV.isHidden = (creatorVM.timeSlots.count > 0) ? false : true
        tableHeight.constant = timeSlotsTV.getTableHeight()
    }
    // MARK: - ACTIONS
    @IBAction func startEndAction(_ sender:UIButton){
        isStart(sender.tag)
    }
    @IBAction func availabilityAction(_ sender:UIButton){
        isAvailability(sender.tag)
    }
    
    @IBAction func durationAction(_ sender:UIButton){
        isDuration(sender.tag)
    }
    @IBAction func submit(_ sender : UIButton){
        
        if creatorVM.isValid{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CAddNewExpVC") as! CAddNewExpVC
            vc.delegate = self
            vc.creatorVM = creatorVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showErrorMessages(message: creatorVM.brokenRules.first?.message ?? "")
        }
    }
    
    
    @IBAction func nextTapped(_ sender :UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
    }
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction  func previousTapped(_ sender :UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    
    
}

// MARK: - FSCALENDAR DELEGATE & DATASOURCE METHODS
extension CreateExperienceFirst:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
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

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension CreateExperienceFirst:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creatorVM.days.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaysCell", for: indexPath) as? DaysCell else{
            return DaysCell()
        }
        cell.lbl_day.text =  String(creatorVM.days[indexPath.item].dayName.prefix(3))
        cell.img_check.image = creatorVM.days[indexPath.item].selection ? UIImage.init(named: "check_orange") : UIImage.init(named: "check_grey")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        creatorVM.days[indexPath.row].selection = !creatorVM.days[indexPath.row].selection
       selectDayInWeekAction()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 78, height: 40)
    }
    func selectDayInWeekAction(){
        let selectedDaysInWeek = creatorVM.days.filter({$0.selection == true})
         if selectedDaysInWeek.count > 0{
             blockDatesLbl.text = "Block Dates Available"
         }
         else{
             blockDatesLbl.text = "Block Dates Not Available"
         }
         self.collection_days.reloadData()
         self.creatorVM.mentionedWeekDatesInString = DateConvertor.shared.getDates(of: selectedDaysInWeek.map{$0.dayId}, from: (startDate).dayBefore, to: endDate, dateFormat: .yyyyMMdd, calendar: .current)
         self.calendar.reloadData()
    }
}
extension CreateExperienceFirst:changeModelType{
    func changeModel() {
        creatorVM.modelType = .CreateExperienceWithDateAndTime
    }
}

//MARK: - TV DELEGATE & DATASOURCE METHODS
extension CreateExperienceFirst: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorVM.timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else{return .init()}
        cell.lbl_location.text = "StartTime: \( creatorVM.timeSlots[indexPath.row].slotStartTime ?? ""),        EndTime: \( creatorVM.timeSlots[indexPath.row].slotEndTime ?? "")"
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(slotDeleteBtnAction(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - COLLECTIONVIEW CELL
class DaysCell : UICollectionViewCell{
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var img_check : UIImageView!
}
// MARK: - TEXTFIELD DELEGATE METHOD
extension CreateExperienceFirst: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txt_startDate || textField == txt_endDate || textField == txt_startTime || textField == txt_endTime || textField == fromTimeTF || textField == toTimeTF{
            self.view.endEditing(true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let intValue = Int(text) ?? 0
        if textField == txt_hours {
            if intValue > 24{
                return false
            }
        }
        else if textField == txt_minutes{
            if intValue > 60{
                return false
            }
        }
        return true
    }
}
