//
//  CCalendarVC.swift
//  BList
//
//  Created by Rahul Chopra on 15/05/22.
//

import UIKit
import FSCalendar
import IBAnimatable
class CCalendarVC: BaseClassVC{
    @IBOutlet weak var txt_startDate: UITextField!
    @IBOutlet weak var txt_endDate: UITextField!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var collection_experience: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var noData: UILabel!
    @IBOutlet weak var submitBlockDates: UIButton!
    var startDate       = Date()
    var datePickerFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.MMMdyyyy.rawValue
        return formatter
    }
    //rgba(249, 106, 39, 1)
    let highlightedColorForRange = UIColor.init(red:249/255, green: 106/255, blue: 39/238, alpha: 0.2)
    
    var creatorVM: CreatorViewModel!
    var userVM: UserViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = UserViewModel(type: .ExperienceDetails)
        creatorVM = CreatorViewModel(type: .CreatorHome)
        configureCalendar()
        submitBlockDates.addTarget(self, action: #selector(blockDatesAction(_:)), for: .touchUpInside)
    }
    
    @objc func blockDatesAction(_ sender: UIButton) {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: creatorVM)
        calendar.select(Date())
        creatorVM.selectedDate = DateConvertor.shared.convert(date: Date(), format: .yyyyMMdd).dateInString ?? ""
        creatorVM.getExperiences()
        creatorVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else {return}
            switch apiType {
            case .GetExperiencesBasedOnDate:
                if let exps = self.creatorVM.expBasedOnDate, exps.count > 0 {
                    let collectionHeight = self.collection_experience.getCollectionHeight()
                    self.collectionHeight.constant = collectionHeight > 410 ? 410 : collectionHeight
                    self.noData.isHidden = true
                } else {
                    self.noData.isHidden = false
                    self.collection_experience.reloadData()
                    self.collectionHeight.constant = 100
                }
           
            default:
                break
            }
        }
    }
    
    func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        calendar.appearance.headerTitleFont      = AppFont.cabinBold
        calendar.appearance.weekdayFont          = AppFont.cabinSemiBold
        calendar.appearance.titleFont            = AppFont.cabinSemiBold
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.appearance.selectionColor       = UIColor(named: "AppOrange")
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = true
        calendar.clipsToBounds = true
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
extension CCalendarVC {
    
    func configureVisibleCells() {
        self.calendar.visibleCells().forEach { (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }
    
    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date!) {
                let previousDate = BList.calendar.date(byAdding: .day, value: -1, to: date!)!
                let nextDate = BList.calendar.date(byAdding: .day, value: 1, to: date!)!
                if calendar.selectedDates.contains(date!) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        diyCell.selectionLayer.fillColor = highlightedColorForRange.cgColor
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date!) {
                        selectionType = .singleRight // .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .singleRight // .leftBorder
                    }
                    else {
                        selectionType = .middle //.single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.selectionLayer.isHidden = true
        }
    }
    
    
}

extension CCalendarVC:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        creatorVM.selectedDate = dateFormatter.string(from: date)
        creatorVM.getExperiences()
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        creatorVM.selectedDate = ""
//        creatorVM.getExperiences()
//        creatorVM.selectedDates.removeAll { blockDate in
//            blockDate == dateFormatter.string(from: date)
//        }
    }
  
    // Prevents scrolling from exceeding minimum date
    func minimumDate(for calendar: FSCalendar) -> Date {
        return startDate
    }
    
    
}
extension CCalendarVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creatorVM.expBasedOnDate?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceCalendarCell", for: indexPath) as? ExperienceCalendarCell else {
            return .init()
        }
        cell.configureCell(with: creatorVM.expBasedOnDate?[indexPath.row])
        cell.menuBtn.tag = indexPath.row
        cell.menuBtn.addTarget(self, action: #selector(menuTapAction(_:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func menuTapAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Message User", style: .default) {[weak self] _ in
            guard let self = self else {return}
            let vc = UIStoryboard.loadBookedUsersVC()
            vc.expID = self.creatorVM.expBasedOnDate?[sender.tag].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        action1.setValue(UIColor(named: "AppOrange"), forKey: "titleTextColor")
        let action2 = UIAlertAction(title: "Cancel Booking", style: .default) {[weak self] _ in
            guard let self = self else {return}
            print("Cancel Booking Pending")
            self.creatorVM.expId = self.creatorVM.expBasedOnDate?[sender.tag].id ?? ""
            self.creatorVM.cancelBookings()
            self.creatorVM.didFinishFetch = { [weak self](_) in
                guard let self = self else {return}
                self.showSuccessMessages(message: "Bookings got cancelled for \(self.creatorVM.expBasedOnDate?[sender.tag].expName ?? "") experience")
                self.collection_experience.reloadData()
            }
        }
        action2.setValue(UIColor(named: "AppOrange"), forKey: "titleTextColor")
        let action3 = UIAlertAction(title: "Block Dates", style: .default) {[weak self] _ in
            guard let self = self else {return}
            let vc = UIStoryboard.loadBlockDatesVC()
            vc.creatorVM = self.creatorVM
            vc.expDetails = self.creatorVM.expBasedOnDate?[sender.tag]
            vc.callBack = { [weak self](updatedBlockDates) in
                guard let self = self else {return}
                self.creatorVM.expBasedOnDate?[sender.tag].blockDates = updatedBlockDates.joined(separator: ",")
                self.showSuccessMessages(message: "Block dates updated for \(self.creatorVM.expBasedOnDate?[sender.tag].expName ?? "") experience")
            }
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        }
        action3.setValue(UIColor(named: "AppOrange"), forKey: "titleTextColor")
        let action4 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action1)
        if self.creatorVM.expBasedOnDate?[sender.tag].isBooking == 1 {
            actionSheet.addAction(action2)
        }
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userVM.expIds.append(creatorVM.expBasedOnDate?[indexPath.row].id ?? "")
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        vc.accountType = .creator
        vc.userVM = userVM
        navigationController?.pushViewController(vc, animated: true)
        
        /*
         creatorVM.expBasedOnDate = creatorVM.expBasedOnDate?.map({ exp in
             var exp = exp
             exp.isSelection = false
             return exp
         })
         creatorVM.expBasedOnDate?[indexPath.row].isSelection.toggle()
         let expDetails = creatorVM.expBasedOnDate?[indexPath.row]
         
         self.creatorVM.expId = expDetails?.id ?? ""

         DispatchQueue.main.async {
             self.collection_experience.reloadData()
         }
         */
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collection_experience.frame.width - 15)/2
        return  CGSize(width: width, height: 200)
    }
    
}
class ExperienceCalendarCell: UICollectionViewCell{
    @IBOutlet weak var img_category : UIImageView!
    @IBOutlet weak var lbl_title    : UILabel!
    @IBOutlet weak var expPrice     : UILabel!
    @IBOutlet weak var expImg       : UIImageView!
    @IBOutlet weak var borderView   : AnimatableView!
    @IBOutlet weak var menuBtn      : UIButton!
    func configureCell(with data: GetExperiencesBasedOnDateResponseModel.Experience?) {
        lbl_title.text = data?.expName ?? ""
        expPrice.text = "$ \(data?.price ?? "")"
        expImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverPhoto ?? ""))
        borderView.borderWidth = (data?.isSelection == true) ? 1 : 0
    }
}
