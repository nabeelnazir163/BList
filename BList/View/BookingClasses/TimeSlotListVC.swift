//
//  TimeSlotListVC.swift
//  BList
//
//  Created by iOS Team on 21/10/22.
//

import UIKit
protocol SelectedTimeSlotDelegate:AnyObject{
    func selectedDates(timeSlotData : [(date:String,slotTime:String)])
}
class TimeSlotListVC: BaseClassVC {
    weak var viewModel: UserViewModel!
    var selectedDate = ""
    var timeSlotData = [TimeSlotData]()
    var selectedSlot = [(date:String,slotTime:String)]()
    weak var delegate :SelectedTimeSlotDelegate?
    
    @IBOutlet weak var collection_TimeSlot:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedDate != ""{
            timeSlotData = viewModel.time_SlotList.filter({ timeslotData in
                timeslotData.date == selectedDate
            })
        }
        else{
            timeSlotData = viewModel.time_SlotList
        }
        collection_TimeSlot.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func doneAction(_ sender:UIButton){
        self.dismiss(animated: true) {[weak self] in
            guard let self = self else{return}
            self.delegate?.selectedDates(timeSlotData: self.selectedSlot)
        }
    }
}
extension TimeSlotListVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlotData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as? TimeSlotCell else{
            return TimeSlotCell()
        }
        cell.lbl_Date.text = timeSlotData[indexPath.row].date ?? ""
        cell.timeSlot =  timeSlotData[indexPath.row].slotTimes ?? []
        //cell.parents = self
        cell.date  =  timeSlotData[indexPath.row].date ?? ""
        cell.tableView.reloadData()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collection_TimeSlot.frame.size.width - 10) / 2
        let selectedTime = timeSlotData[indexPath.row].slotTimes
        let numberOfItem =  selectedTime?.count ?? 0
        return CGSize(width: width, height: (CGFloat(numberOfItem*45)+20))
    }
}
