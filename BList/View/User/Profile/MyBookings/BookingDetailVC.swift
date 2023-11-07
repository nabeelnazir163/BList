//
//  BookingDetailVC.swift
//  BList
//
//  Created by PARAS on 30/05/22.
//

import UIKit
import IBAnimatable
import MapKit
class BookingDetailVC: BaseClassVC,MKMapViewDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var collection_images:UICollectionView!
    @IBOutlet weak var collection_ImportantDetail:UICollectionView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var date2Lbl: UILabel!
    @IBOutlet weak var time2Lbl: UILabel!
    @IBOutlet weak var amount2Lbl: UILabel!
    @IBOutlet weak var desc1Lbl: UILabel!
    @IBOutlet weak var desc2Lbl: UILabel!
    @IBOutlet weak var atmosphereLocationDescLbl: UILabel!
    @IBOutlet weak var willingToTravelLbl: UILabel!
    @IBOutlet weak var clothingRecommendationLbl : UILabel!
    @IBOutlet weak var cancellationLbl: UILabel!
    @IBOutlet weak var onlinePlatformsCV            : UICollectionView!
    @IBOutlet weak var collection_ImgDetailHeight   : NSLayoutConstraint!
    @IBOutlet weak var collection_rating            : UICollectionView!
    @IBOutlet weak var collection_similarExperience : UICollectionView!
    @IBOutlet weak var mapView                      : MKMapView!
    @IBOutlet weak var reviewBookingView1           : UIView!
    @IBOutlet weak var reviewBookingView2           : UIView!
    @IBOutlet weak var viewAllRatingsBtn            : UIButton!
    @IBOutlet weak var viewAllRatingsView           : UIView!
    @IBOutlet weak var similarExperiencesSV         : UIStackView!
    @IBOutlet weak var viewOnMapBtn                 : UIButton!
    @IBOutlet weak var mapViewContainerView         : UIView!
    @IBOutlet weak var locationsLbl                 : UILabel!
    @IBOutlet weak var ratingSV                     : UIStackView!
    @IBOutlet weak var onlinePlatformsView          : UIView!
    @IBOutlet weak var locationContainerView        : UIView!
    @IBOutlet weak var onlinePlatformCVWidth        : NSLayoutConstraint!
    @IBOutlet weak var payWithLbl                   : UILabel!
    @IBOutlet weak var paymentTypeBtn               : UIButton!
    @IBOutlet weak var adultSV                      : UIStackView!
    @IBOutlet weak var adultPriceDenomination       : UILabel!
    @IBOutlet weak var adultTotalPrice              : UILabel!
    @IBOutlet weak var childrenSV                   : UIStackView!
    @IBOutlet weak var childrenPriceDenomination    : UILabel!
    @IBOutlet weak var childrenTotalPrice           : UILabel!
    @IBOutlet weak var infantSV                     : UIStackView!
    @IBOutlet weak var infantPriceDenomination      : UILabel!
    @IBOutlet weak var infantTotalPrice             : UILabel!
    @IBOutlet weak var totalPrice                   : UILabel!
    @IBOutlet weak var notesView                    : UIView!
    @IBOutlet weak var notesLbl                     : UILabel!
    @IBOutlet weak var guestsLbl                    : UILabel!
    @IBOutlet weak var msgBtn                       : UIButton!
    @IBOutlet weak var bookedDateLbl                : UILabel!
    @IBOutlet weak var hostNameLbl                  : UILabel!
    @IBOutlet weak var expDetailsContainer          : UIView!
    // MARK: - PROPERTIES
    var bookingId = ""
    var userVM : UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        msgBtn.addTarget(self, action: #selector(messageBtnAction(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userVM = UserViewModel(type: .GetBookingDetails)
        setUpVM(model: userVM)
        userVM.getBookingDetail(bookingId: self.bookingId)
        userVM.didFinishFetch = { [weak self] ApiType in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.setUpUI()
            }
        }
    }
    func setUpUI(){
        if let data = userVM.bookingDetails{
            headingLbl.text = data.expName ?? ""
            dateLbl.text = data.expStartDate ?? ""
            date2Lbl.text = data.expEndDate ?? ""
            amountLbl.text = "$\(data.minGuestAmount ?? "")"
            amount2Lbl.text = "$\(data.minGuestAmount ?? "")"
            desc1Lbl.text = data.expSummary ?? ""
            desc2Lbl.text = data.expDescribe ?? ""
            atmosphereLocationDescLbl.text = data.describeLocation ?? ""
            willingToTravelLbl.text = data.willingMessage ?? ""
            clothingRecommendationLbl.text = data.clothingRecommendations ?? ""
            if data.paymentMethod == "card" {
                paymentTypeBtn.setImage(UIImage(named: "Credit & debit card"), for: .normal)
                payWithLbl.text = "Credit & debit card"

            }
            //self.addressLbl.text = data.location ?? ""
            let ratingCount = data.totalRatingsCount ?? 0
            ratingSV.isHidden = ratingCount == 0 ? true : false
            similarExperiencesSV.isHidden = (data.nearbyExp?.count ?? 0) > 0 ? false : true
            if (ratingCount) > 5{
                viewAllRatingsView.isHidden = false
                viewAllRatingsBtn.setTitle("View All \(ratingCount) Reviews", for: .normal)
            }
            if data.expMode == "Online" || data.coordinates?.count == 0{
                onlinePlatformsView.isHidden = false
                locationContainerView.isHidden = true
                mapViewContainerView.isHidden = true
                onlinePlatformsCV.reloadData()
                onlinePlatformsCV.layoutIfNeeded()
                let screenWidth = UIScreen.main.bounds.size.width
                let collectionWidth = onlinePlatformsCV.contentSize.width
                onlinePlatformCVWidth.constant = collectionWidth > screenWidth ? screenWidth : collectionWidth
            } else {
                onlinePlatformsView.isHidden = true
                locationContainerView.isHidden = false
                mapViewContainerView.isHidden = false
                //locationsLbl.text = exp.formattedLocations ?? ""
            }
            let noofAdults = Int(data.noAdults ?? "0") ?? 0
            let noofChildren = Int(data.noChildern ?? "0") ?? 0
            let noofInfants = Int(data.noInfants ?? "0") ?? 0
            let expPrice = Int(data.minGuestAmount ?? "0") ?? 0
            adultSV.isHidden = noofAdults == 0
            childrenSV.isHidden = noofChildren == 0
            infantSV.isHidden = noofInfants == 0
            adultPriceDenomination.text = "$\(expPrice) * \(noofAdults) adult"
            childrenPriceDenomination.text = "$\(expPrice) * \(noofChildren) child"
            infantPriceDenomination.text = "$\(expPrice) * \(noofInfants) infant"
            adultTotalPrice.text = "$\(expPrice * noofAdults)"
            childrenTotalPrice.text = "$\(expPrice * noofChildren)"
            infantTotalPrice.text = "$\(expPrice * noofInfants)"
            totalPrice.text = "$\((expPrice * noofAdults) + (expPrice * noofChildren) + (expPrice * noofInfants))"
            notesView.isHidden = data.notes ?? "" == ""
            notesLbl.text = data.notes ?? ""
            if noofAdults != 0 {
                guestsLbl.text = noofAdults == 1 ? "\(noofAdults) adult" : "\(noofAdults) adults"
            }
            if noofChildren != 0 {
                if !(guestsLbl.text ?? "").isEmptyOrWhitespace() {
                    guestsLbl.text! += ", "
                }
                guestsLbl.text! += noofChildren == 1 ? "\(noofChildren) child" : "\(noofChildren) children"
            }
            if noofInfants != 0 {
                if !(guestsLbl.text ?? "").isEmptyOrWhitespace() {
                    guestsLbl.text! += ", "
                }
                guestsLbl.text! += noofInfants == 1 ? "\(noofInfants) infant" : "\(noofInfants) infants"
            }
            if let bookedDate = convert(text: data.bookingDate ?? "",dataType: .dic_arr).dic_arr?.first?["date"] as? String {
                bookedDateLbl.text = DateConvertor.shared.convert(dateInString: bookedDate, from: .yyyyMMdd, to: .ddMMMyyyy).dateInString
            }
            hostNameLbl.text = "Experience hosted by \(data.userName ?? "")"
        }
    }
    @objc func messageBtnAction(_ sender:UIButton){
        if userVM.bookingDetails?.userID ?? "" != AppSettings.UserInfo?.id ?? ""{
            let vc = UIStoryboard.loadChatVC()
            vc.receiverID = userVM.bookingDetails?.userID ?? ""
            vc.receiverName = userVM.bookingDetails?.userName ?? ""
            vc.receiverImgString = userVM.bookingDetails?.userImage ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func expandCollapseAction(_ sender:UIButton){
        expDetailsContainer.isHidden = sender.isSelected
        sender.isSelected.toggle()
    }
}

extension BookingDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return DetailModel.data().count
        } else if collectionView.tag == 4 {
            return userVM.bookingDetails?.onlinePlatforms?.count ?? 0
        }
        else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            cell.img_top.image = UIImage.init(named: "video_img")
            return cell
        }
        else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionCell", for: indexPath) as! DetailsCollectionCell
            cell.headingLbl.text = DetailModel.data()[indexPath.row].heading
            cell.subheadingLbl.text = DetailModel.data()[indexPath.row].subheading
            return cell
        }
        else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Rating_Experience_Cell", for: indexPath) as! Rating_Experience_Cell
            return cell
        }
        else if collectionView.tag == 4 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineTypeCell", for: indexPath) as? OnlineTypeCell else {return .init()}
            cell.configure(onlineType: userVM.bookingDetails?.onlinePlatforms?[indexPath.row] ?? "")
            return cell
        }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as! ExperienceDetailsCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else if collectionView.tag == 1{
            let width = (collectionView.frame.size.width - 10) / 2
            return CGSize(width: width, height: 50)
        }
        else if collectionView.tag == 2{
            let width = (collectionView.frame.size.width - 100)//0
            return CGSize(width: width, height: collectionView.frame.size.height)
        }
        else if collectionView.tag == 4 {
            return CGSize(width: 50, height: 50)
        }
        else{
            return CGSize(width: 160, height: collectionView.frame.size.height)
        }
       
    }
}
