//
//  MyBookingsVC.swift
//  BList
//
//  Created by iOS Team on 19/05/22.
//

import UIKit
import IBAnimatable
enum BookingType{
    case future
    case past
}
class MyBookingsVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet var bookingBtns       : [UIButton]!
    @IBOutlet weak var noDataLbl    : UILabel!
    
    var viewVM : UserViewModel!
    var bookingType: BookingType = .future
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewVM = UserViewModel(type: .GetBookingList)
        setUpVM(model: viewVM)
        viewVM.getBookings()
        viewVM.didFinishFetch = { [weak self] ApiType in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noDataLbl.isHidden = !(self.viewVM.bookingTypes?.futureBooking?.count ?? 0 == 0)
            }
        }
    }
    
    // MARK: - IBACTIONS
    @IBAction func actionBookingBtn(_ sender: UIButton) {
        bookingBtns.forEach({$0.shadow(color: .clear, radius: 0, opacity: 0, size: .zero); $0.backgroundColor = .clear; $0.titleLabel?.font = AppFont.cabinRegular.withSize(16)})
        bookingBtns[sender.tag].shadow(color: UIColor(hexString: "#DBDBDB").withAlphaComponent(0.14), radius: 4, opacity: 1, size: .zero)
        bookingBtns[sender.tag].backgroundColor = .white
        bookingBtns[sender.tag].titleLabel?.font = AppFont.cabinBold.withSize(16)
        bookingType = sender.tag == 0 ? .future : .past
        switch bookingType {
        case .future:
            self.noDataLbl.isHidden = !(self.viewVM.bookingTypes?.futureBooking?.count ?? 0 == 0)
            self.noDataLbl.isHidden = !(self.viewVM.bookingTypes?.futureBooking?.count ?? 0 == 0)
        case .past:
            self.noDataLbl.isHidden = !(self.viewVM.bookingTypes?.pastBooking?.count ?? 0 == 0)
            self.noDataLbl.isHidden = !(self.viewVM.bookingTypes?.pastBooking?.count ?? 0 == 0)
        }
        tableView.reloadData()
    }
}



// MARK: - TABLE VIEW DATA SOURCE METHODS
extension MyBookingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch bookingType{
        case .future:
            return viewVM.bookingTypes?.futureBooking?.count ?? 0
        case .past:
            return viewVM.bookingTypes?.pastBooking?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingTableCell", for: indexPath) as? MyBookingTableCell else { return .init() }
        var bookingslist:[BookingListModel.BookingDetails]?
        switch bookingType{
        case .future:
            bookingslist = viewVM.bookingTypes?.futureBooking
        case .past:
            bookingslist = viewVM.bookingTypes?.pastBooking
        }
        cell.configureCell(with: bookingslist?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var bookingslist:[BookingListModel.BookingDetails]?
        switch bookingType{
        case .future:
            bookingslist = viewVM.bookingTypes?.futureBooking
        case .past:
            bookingslist = viewVM.bookingTypes?.pastBooking
        }
        let rowData = bookingslist?[indexPath.row]
        if rowData?.isAcceptance == "1"{
            let vc = UIStoryboard.loadBookingDetailVC()
            vc.bookingId = rowData?.id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class MyBookingTableCell: UITableViewCell {
    @IBOutlet weak var img_Booking  : AnimatableImageView!
    @IBOutlet weak var dateLbl      : UILabel!
    @IBOutlet weak var btn_Cancel   : UIButton!
    @IBOutlet weak var titleLbl     : UILabel!
    @IBOutlet weak var amountLbl    : UILabel!
    @IBOutlet weak var ratingLbl    : UILabel!
    @IBOutlet weak var pendingLbl   : UILabel!
    
    func configureCell(with data: BookingListModel.BookingDetails?){
        img_Booking.setImage(link: BaseURLs.experience_Image.rawValue + (data?.expImage ?? ""))
        amountLbl.text = "$\(data?.minGuestAmount ?? "")"
        titleLbl.text = data?.expName ?? ""
        if let dic_arr = BList.convert(text: data?.bookDateTime ?? "", dataType: .dic_arr).dic_arr, let firstElement = dic_arr.first{
            dateLbl.text = DateConvertor.shared.convert(dateInString: firstElement["date"] as? String ?? "", from: .yyyyMMdd, to: .ddMMMyyyy).dateInString
        }
        ratingLbl.text = "\(data?.averageRating ?? "0") (\(data?.totalRatingsCount ?? 0))"
        btn_Cancel.isHidden = data?.isAcceptance ?? "" == "1" ? true : false
        pendingLbl.isHidden = data?.isAcceptance ?? "" == "0" ? false : true
    }
}
