//
//  TimeSlotCell.swift
//  BList
//
//  Created by iOS Team on 21/10/22.
//

import Foundation
import UIKit
import IBAnimatable
class TimeSlotCell : UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_Date:UILabel!
    weak var parents : ChooseAvailableDateVC?//TimeSlotListVC?
    var date = ""
    var timeSlot = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlot.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as? TimeCell else{
            return TimeCell()
        }
        if ((parents?.selectedSlot.count ?? 0) > 0) && (parents?.selectedSlot[0].date == date) && (parents?.selectedSlot[0].slotTime == timeSlot[indexPath.row]){
            cell.lbl_time.backgroundColor = .clear
            cell.lbl_time.borderColor = UIColor.init(hexString: "F96A27")
            cell.lbl_time.textColor =  UIColor.init(hexString: "F96A27")
        }else{
            cell.lbl_time.backgroundColor = UIColor.init(hexString: "E6E6E6")
            cell.lbl_time.textColor =  UIColor.init(hexString: "BBBBBB")
            cell.lbl_time.borderColor = UIColor.init(hexString: "BBBBBB")
        }
        cell.lbl_time.text = timeSlot[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data:[(date:String,slotTime:String)] = [(date:date,slotTime:timeSlot[indexPath.row])]
        parents?.selectedSlot = data
       // self.tableView.reloadData()
        self.parents?.collection_TimeSlot.reloadData()
    }
}
class TimeCell : UITableViewCell{
    @IBOutlet weak var lbl_time:AnimatableLabel!
    @IBOutlet weak var btn_cross:UIButton!
}
