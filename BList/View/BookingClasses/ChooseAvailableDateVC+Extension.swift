//
//  ChooseAvailableDateVC+Extension.swift
//  BList
//
//  Created by iOS Team on 21/10/22.
//

import Foundation
import UIKit
import IBAnimatable
extension ChooseAvailableDateVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if timeSlotList.count > 1{
            return timeSlotList.count
        }
        else{
            return timeSlotList[section].slotTimes?.count ?? 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (timeSlotList.count > 1) ? 1 : timeSlotList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if timeSlotList.count > 1{
            return CGSize.zero
        }
        else{
            return CGSize(width: collectionView.frame.size.width, height: 25)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleHeader", for: indexPath) as? TitleHeader else{return .init()}
            headerView.title.text = (timeSlotList[indexPath.section].date ?? "")
            return headerView
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if timeSlotList.count > 1{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as? TimeSlotCell else{
                return .init()
            }
            cell.lbl_Date.text = timeSlotList[indexPath.row].date ?? ""
            cell.timeSlot =  timeSlotList[indexPath.row].slotTimes ?? []
            cell.parents = self
            cell.date  =  timeSlotList[indexPath.row].date ?? ""
            cell.tableView.reloadData()
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleSlotCell", for: indexPath) as? SingleSlotCell else{
                return .init()
            }
            let slotDate = timeSlotList[indexPath.section].date ?? ""
            let slotTime = timeSlotList[indexPath.section].slotTimes?[indexPath.row]
            if (selectedSlot.count > 0) && (selectedSlot[0].date == slotDate) && (selectedSlot[0].slotTime == slotTime ?? ""){
                cell.lbl_time.backgroundColor = .clear
                cell.lbl_time.borderColor = UIColor.init(hexString: "F96A27")
                cell.lbl_time.textColor =  UIColor.init(hexString: "F96A27")
            }
            else{
                cell.lbl_time.backgroundColor = UIColor.init(hexString: "E6E6E6")
                cell.lbl_time.textColor =  UIColor.init(hexString: "BBBBBB")
                cell.lbl_time.borderColor = UIColor.init(hexString: "BBBBBB")
            }
            cell.lbl_time.text = timeSlotList[indexPath.section].slotTimes?[indexPath.row]
            return cell
        }
    }
    @objc func showMoreAction(_ sender:UIButton){
        timeSlotList = viewModel.time_SlotList
        collection_TimeSlot_Nslayout.constant = collection_TimeSlot.getCollectionHeight()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collection_TimeSlot.frame.size.width - 10
        let width = collectionViewWidth/2
        if timeSlotList.count > 1{
            let selectedTime = timeSlotList[indexPath.row].slotTimes
            let numberOfItem =  selectedTime?.count ?? 0
            return CGSize(width: width, height: (CGFloat(numberOfItem*45)+20))
        }
        else{
            return CGSize(width: width, height: 35)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if timeSlotList.count <= 1{
            let data = [(date:timeSlotList[indexPath.section].date ?? "",slotTime:timeSlotList[indexPath.section].slotTimes?[indexPath.row] ?? "")]
            self.selectedSlot = data
            collection_TimeSlot.reloadData()
        }
    }
}
extension ChooseAvailableDateVC:SelectedTimeSlotDelegate{
    func selectedDates(timeSlotData: [(date: String, slotTime: String)]) {
        selectedSlot = timeSlotData
        if selectedSlot.count > 0{
            self.collection_TimeSlot.isHidden = false
            //self.btn_selectTimeSlot.isHidden = true
        }
        self.collection_TimeSlot.reloadData()
    }
}
class ShowMore_Cell : UICollectionViewCell{
    @IBOutlet weak var btn_ShowMore: UIButton!
}
class dateCell : UICollectionViewCell{
    @IBOutlet weak var lbl_time:AnimatableLabel!
    @IBOutlet weak var lbl_Date:UILabel!
}
class SingleSlotCell: UICollectionViewCell{
    @IBOutlet weak var lbl_time:AnimatableLabel!
}


