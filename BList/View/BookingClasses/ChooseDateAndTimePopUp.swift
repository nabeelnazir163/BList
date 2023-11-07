//
//  ChooseDateAndTimePopUp.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import FSCalendar
import IBAnimatable
class ChooseDateAndTimePopUp: BaseClassVC, SelectedTimeSlotDelegate {
    func selectedDates(timeSlotData: [(date: String, slotTime: String)]) {
        selectedSlot = timeSlotData
        if selectedSlot.count > 0{
            self.collection_TimeSlot.isHidden = false
            self.btn_selectTimeSlot.isHidden = true
        }
        self.collection_TimeSlot.reloadData()
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var strtDateTxtField: AnimatableTextField!
    @IBOutlet weak var endDateTxtField: AnimatableTextField!
    @IBOutlet weak var date_timeRequestSV           : UIStackView!
    @IBOutlet var radio_btns                        : [UIButton]!
    @IBOutlet weak var pickDateTF                   : UITextField!
    @IBOutlet weak var pickTimeTF                   : UITextField!
    @IBOutlet weak var btn_selectTimeSlot           : UIButton!
    @IBOutlet weak var collection_TimeSlot          : UICollectionView!
    @IBOutlet weak var collection_TimeSlot_Nslayout : NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    var firstDate: Date?
    var lastDate: Date?
    var datesRange = [Date]()
    var selectedDate: String = ""
    var selectedSlot = [(date:String,slotTime:String)]()
    let highlightedColorForRange = UIColor.init(red:249/255, green: 106/255, blue: 39/238, alpha: 0.2)
    weak var viewModel: UserViewModel!
    var clouser:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate       = self
        calendar.dataSource     = self
        calendar.today          = nil
        calendar.clipsToBounds  = true
        calendar.appearance.headerTitleFont             = AppFont.cabinBold
        calendar.appearance.weekdayFont                 = AppFont.cabinSemiBold
        calendar.appearance.titleFont                   = AppFont.cabinSemiBold
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.selectionColor              = AppColor.orange
        calendar.calendarHeaderView.backgroundColor     = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor    = UIColor.clear
//        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        getData()
        addDatePickers()
        guard let startDate = dateFormatter.date(from: viewModel.expDetail?.expDetail?.expStartDate ?? ""), let endDate = dateFormatter.date(from: viewModel.expDetail?.expDetail?.expEndDate ?? "") else{return}
        datesRange = BList.datesRange(from: startDate, to: endDate)
    }
    func getData(){
       
        viewModel.didFinishFetch  = {[weak self](apiType) in
            guard let self = self else{return}
            //   let data = self.viewModel.time_Slot_Data.filter({$0.isSelected ?? false})
            if self.selectedSlot.count == 0{
                self.collection_TimeSlot.isHidden = true
                self.btn_selectTimeSlot.isHidden = false
            }
            else{
                self.collection_TimeSlot.isHidden = false
                self.btn_selectTimeSlot.isHidden = true
                self.collection_TimeSlot.reloadData {[weak self] in
                    guard let self = self else{return}
                    self.collection_TimeSlot_Nslayout.constant = 60.0
                }
            }
        }
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
            let datePickerFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.pickDateTF.text = datePickerFormatter.string(from: datePicker.date)
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
            self.viewModel.requestTime = pickTimeTF.text ?? "" //DateConvertor.shared.convert(date: pickTimeTF.text ?? "", inputFormat: .hhmmA, outputFormat: .HHmm)
        }
        self.pickTimeTF.resignFirstResponder()
    }
    
    // MARK: - ACTIONS
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
        }
        else{
            // NO
            date_timeRequestSV.isHidden = true
        }
        radio_btns.forEach({$0.setImage(UIImage.init(named: "radio"), for: .normal)})
        radio_btns[sender.tag].setImage(UIImage.init(named: "radio_active"), for: .normal)
    }
    
    @IBAction func done(_ sender :UIButton) {
        self.dismiss(animated: true) {[weak self] in
            guard let self = self else{return}
            self.clouser?()
        }
    }
    @IBAction func nextTapped(_ sender :UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
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
}

extension ChooseDateAndTimePopUp:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    // For coloring event dates. Here count represents number of dots
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if datesRange.contains(date) {
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
        if !datesRange.contains(date){
            selectedDate = ""
            showErrorMessages(message: "Please select valid date")
        }
        else{
            selectedDate = dateFormatter.string(from: date)
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Deselected date \(dateFormatter.string(from: date))")
    }

}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension ChooseDateAndTimePopUp: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSlot.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedSlot.count == indexPath.row{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowMore_Cell", for: indexPath) as? ShowMore_Cell else{
                return ShowMore_Cell()
            }
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? dateCell else{
                return dateCell()
            }
            cell.lbl_Date.text = selectedSlot[indexPath.row].date
            cell.lbl_time.text = selectedSlot[indexPath.row].slotTime
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collection_TimeSlot.frame.size.width-10) / 2
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSlot.count == indexPath.row{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeSlotListVC") as! TimeSlotListVC
            vc.delegate = self
            vc.timeSlotData = viewModel.time_SlotList
            vc.selectedSlot = selectedSlot
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            self.present(vc, animated:true, completion: nil)
        }
    }
}
