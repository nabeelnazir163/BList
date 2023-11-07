//
//  NewlyExperienceDetail.swift
//  BList
//
//  Created by iOS TL on 23/05/22.
//

import UIKit
import MapKit
import IBAnimatable

class NewlyExperienceDetail: BaseClassVC,MKMapViewDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet weak var pageControl                 : UIPageControl!
    @IBOutlet weak var expHostByLbl                : UILabel!
    @IBOutlet weak var userImgview                 : AnimatableImageView!
    @IBOutlet weak var clothingRecomStackView      : UIStackView!
    @IBOutlet weak var cancellationStackView       : UIStackView!
    @IBOutlet weak var ratingSV                    : UIStackView!
    @IBOutlet weak var locationsSV                 : UIStackView!
    @IBOutlet weak var clothingRecomLbl            : UILabel!
    @IBOutlet weak var willingTravelDescLbl        : UILabel!
    @IBOutlet weak var expNameLbl                  : UILabel!
    @IBOutlet weak var startDateLbl                : UILabel!
    @IBOutlet weak var startTimeLbl                : UILabel!
    @IBOutlet weak var amountPerPersonLbl          : UILabel!
    @IBOutlet weak var endTimeLbl                  : UILabel!
    @IBOutlet weak var endDateLbl                  : UILabel!
    @IBOutlet weak var endAmountPerPersonLbl       : UILabel!
    @IBOutlet weak var expDescLbl                  : UILabel!
    @IBOutlet weak var expDesc2Lbl                 : UILabel!
    @IBOutlet weak var totalPriceLbl               : UILabel!
    @IBOutlet weak var atmosphereDescLbl           : UILabel!
    @IBOutlet weak var onlinePlatformsView         : UIView!
    @IBOutlet weak var collection_images           : UICollectionView!
    @IBOutlet weak var collection_ImportantDetail  : UICollectionView!
    @IBOutlet weak var onlinePlatformsCV           : UICollectionView!
    @IBOutlet weak var onlinePlatformCVWidth       : NSLayoutConstraint!
    @IBOutlet weak var collection_ImgDetailHeight  : NSLayoutConstraint!
    @IBOutlet weak var collection_rating           : UICollectionView!
    @IBOutlet weak var collection_similarExperience: UICollectionView!
    @IBOutlet weak var mapView                     : MKMapView!
    @IBOutlet weak var reviewBookingView1          : UIView!
    @IBOutlet weak var reviewBookingView2          : UIView!
    @IBOutlet weak var cancellationPolicyLbl       : UILabel!
    @IBOutlet weak var viewAllRatingsBtn           : UIButton!
    @IBOutlet weak var viewAllRatingsView          : UIView!
    @IBOutlet weak var similarExperiencesSV        : UIStackView!
    @IBOutlet weak var viewOnMapBtn                : UIButton!
    @IBOutlet weak var mapViewContainerView        : UIView!
    @IBOutlet weak var bookView                    : UIView!
    @IBOutlet weak var bookViewHeight              : NSLayoutConstraint!
    @IBOutlet weak var locationsLbl                : UILabel!
    @IBOutlet weak var expDetailsContainer         : UIView!
    @IBOutlet weak var messageBtn                  : UIButton!
    @IBOutlet weak var prevBtn                     : UIButton!
    @IBOutlet weak var nxtBtn                      : UIButton!
    @IBOutlet weak var ratingCountBtn              : UIButton!
    @IBOutlet weak var createdAt                   : UILabel!
    // MARK: - PROPERTIES
    var selectedExpId   : String = "0"
    weak var userVM     : UserViewModel!
    var userImages      = [String]()
    var coordinate      : CLLocationCoordinate2D?
    var region          : MKCoordinateRegion?
    let span            = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    var accountType     : AccountType = .user
    var expDetailModel  = DetailModel.data()
    var currentPage     = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected Experience Id: \(selectedExpId)")
        setUpVM(model: userVM)
        userVM.getExperienceDetail()
        userVM.didFinishFetch = { apiType in
            switch apiType {
            case .ExperienceDetails:
                DispatchQueue.main.async {
                    self.showInfoOnUI()
                }
            default: break
            }
        }
        switch accountType {
        case .creator:
            bookView.alpha = 0
            bookViewHeight.constant = 0
        case .user:
            addGesture(for: [reviewBookingView1, reviewBookingView2])
        }
        viewOnMapBtn.addTarget(self, action: #selector(viewOnMapBtnTapAction(_:)), for: .touchUpInside)
        showCurrentLocation()
        messageBtn.isHidden = AppSettings.UserInfo?.role == "2"
        messageBtn.addTarget(self, action: #selector(messageBtnAction(_:)), for: .touchUpInside)
        prevBtn.addTarget(self, action: #selector(prevAction(_:)), for: .touchUpInside)
        nxtBtn.addTarget(self, action: #selector(nxtAction(_:)), for: .touchUpInside)
        
    }
    @objc func trackAction(_ sender:UIButton) {
        let vc = UIStoryboard.loadMapVC()
        vc.userVM = userVM
        vc.expID = selectedExpId
        vc.screenType = .trackedUsers
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - KEY FUNCTIONS
    func showCurrentLocation(){
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: self.span)
            if let region = self.region{
                DispatchQueue.main.async {
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
    
    func addGesture(for views: [UIView]){
        for view in views {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:)))
            view.addGestureRecognizer(tapGesture)
        }
    }
    @objc func viewOnMapBtnTapAction(_ sender:UIButton){
        Task{
            
            let img = await downloadImage(from: BaseURLs.experience_Image.rawValue + (userImages.first ?? ""))
            let vc = UIStoryboard.loadMapVC()
            vc.userVM = userVM
            vc.expImg = img
            navigationController?.pushViewController(vc, animated: true)
        }
        
        /*if let coordinate = coordinate, let region = region{
         let options = [
         MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
         MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
         ]
         let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
         let mapItem = MKMapItem(placemark: placemark)
         mapItem.name = viewModel.expDetail?.expDetail?.expName ?? ""
         mapItem.openInMaps(launchOptions: options)
         }*/
    }
    @objc func viewTapAction(_ sender:UITapGestureRecognizer){
        if sender.view?.tag == 0{
            if let vc = UIStoryboard.storyboardType(type: .experience).instantiateViewController(withIdentifier: "ReviewBookingVC") as? ReviewBookingVC {
                vc.viewModel = userVM
                vc.selectedViewTag = sender.view?.tag ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            if let vc = UIStoryboard.storyboardType(type: .experience).instantiateViewController(withIdentifier: "ReviewBookingVC") as? ReviewBookingVC {
                vc.viewModel = userVM
                vc.selectedViewTag = sender.view?.tag ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func showInfoOnUI() {
        if let exp = self.userVM.expDetail, let expDetails = exp.expDetail {
            
            userImages = (expDetails.images ?? "").components(separatedBy: ",")
            if userImages.count > 1 {
                prevBtn.isHidden = false
                nxtBtn.isHidden = false
            } else {
                prevBtn.isHidden = true
                nxtBtn.isHidden = true
            }
            createdAt.text = DateConvertor.shared.timeAgo(for: expDetails.createdAt ?? "", dateFormat: .yyyyMMddHHmmss)
            pageControl.numberOfPages = userImages.count > 1 ? userImages.count : 0
            
            if (expDetails.userImage ?? "") != "" {
                userImgview.setImage(link: expDetails.userImage ?? "", placeholder: "user_dummy")
            } else {
                userImgview.image = UIImage(named: "user_dummy")
            }
            expHostByLbl.text = "Experience hosted by \(expDetails.username ?? "")"
            expNameLbl.text = expDetails.expName
            if expDetails.expDate ?? "no" == "yes"{
                startDateLbl.text = DateConvertor.shared.convert(dateInString: expDetails.expStartDate ?? "", from: .yyyyMMdd, to: .EEEddMMM).dateInString
                endDateLbl.text = DateConvertor.shared.convert(dateInString: expDetails.expEndDate ?? "", from: .yyyyMMdd, to: .EEEddMMM).dateInString
                startTimeLbl.text = expDetails.expStartTime ?? ""
                endTimeLbl.text = expDetails.expEndTime ?? ""
            }
            else{
                startDateLbl.text = expDetails.currentDate ?? ""
                endDateLbl.text = "No end date"
                startTimeLbl.isHidden = true
                endTimeLbl.isHidden = true
            }
            
            expDescLbl.text = expDetails.expDescribe
            expDesc2Lbl.text = expDetails.expSummary
            atmosphereDescLbl.text = expDetails.describeLocation
            willingTravelDescLbl.text = (expDetails.willingTravel ?? "no") == "yes" ? expDetails.willingMessage : expDetails.willingTravel ?? ""
            clothingRecomLbl.text = expDetails.clothingRecommendations
            cancellationPolicyLbl.text = expDetails.isCancel ?? ""
            amountPerPersonLbl.attributedText = createAttributedStr(text1: "$\(expDetails.amount ?? "0") / ", text2: "person", font1: AppFont.cabinRegular.withSize(16.0), font2: AppFont.cabinRegular.withSize(16.0), textColor1: AppColor.orange, textColor2: AppColor.app989595)
            endAmountPerPersonLbl.attributedText = createAttributedStr(text1: "$\(expDetails.amount ?? "0") / ", text2: "person", font1: AppFont.cabinRegular.withSize(16.0), font2: AppFont.cabinRegular.withSize(16.0), textColor1: AppColor.orange, textColor2: AppColor.app989595)
            totalPriceLbl.attributedText = createAttributedStr(text1: "$\(expDetails.amount ?? "0") / ", text2: "Person", font1: AppFont.cabinRegular.withSize(19.0), font2: AppFont.cabinRegular.withSize(19.0), textColor1: UIColor.black, textColor2: AppColor.app989595)
            
            let ratingCount = exp.totalRatingsCount ?? 0
            let avgRating = exp.averageRating ?? ""
            ratingCountBtn.setTitle("\(avgRating) (\(ratingCount))", for: .normal)
            ratingSV.isHidden = ratingCount == 0 ? true : false
            collection_rating.reloadData()
            similarExperiencesSV.isHidden = (exp.nearbyExp?.count ?? 0) > 0 ? false : true
            if (ratingCount) > 5{
                viewAllRatingsView.isHidden = false
                viewAllRatingsBtn.setTitle("View All \(ratingCount) Reviews", for: .normal)
            }
            if expDetails.expMode == "Online" || expDetails.coordinates.count == 0{
                onlinePlatformsView.isHidden = false
                locationsSV.isHidden = true
                mapViewContainerView.isHidden = true
                onlinePlatformsCV.reloadData()
                onlinePlatformsCV.layoutIfNeeded()
                let screenWidth = UIScreen.main.bounds.size.width
                let collectionWidth = onlinePlatformsCV.contentSize.width
                onlinePlatformCVWidth.constant = collectionWidth > screenWidth ? screenWidth : collectionWidth
            }
            else{
                onlinePlatformsView.isHidden = true
                locationsSV.isHidden = false
                mapViewContainerView.isHidden = false
                locationsLbl.text = expDetails.formattedLocations ?? ""
            }
            collection_ImportantDetail.reloadData()
            collection_ImportantDetail.layoutIfNeeded()
            collection_ImgDetailHeight.constant = collection_ImportantDetail.contentSize.height
            collection_similarExperience.reloadData()
            collection_images.reloadData()
            expDetails.coordinates.forEach { coordinate in
                let pin = MKPointAnnotation()
                pin.title = userVM.expDetail?.expDetail?.expName ?? ""
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
            }
        }
    }
    // MARK: - ACTIONS
    @objc func messageBtnAction(_ sender:UIButton){
        if userVM.expDetail?.expDetail?.userID ?? "" != AppSettings.UserInfo?.id ?? ""{
            let vc = UIStoryboard.loadChatVC()
            vc.receiverID = userVM.expDetail?.expDetail?.userID ?? ""
            vc.receiverName = userVM.expDetail?.expDetail?.username ?? ""
            vc.receiverImgString = userVM.expDetail?.expDetail?.userImage ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func bookingAction(_ sender: Any) {
        if AppSettings.UserInfo != nil && AppSettings.UserInfo?.role == "1"{
            let storyboard = UIStoryboard.init(name: "Experience", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseAvailableDateVC") as! ChooseAvailableDateVC
            vc.selectedExpId = selectedExpId
            vc.viewModel = userVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.loadLoginVC()
            vc.user_Model = userVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func seeAllBtn(_ sender:UIButton) {
        let vc = UIStoryboard.loadExperiencesListVC()
        vc.userVM = userVM
        vc.expType = .seeAll
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func expandCollapseAction(_ sender:UIButton){
        expDetailsContainer.isHidden = sender.isSelected
        sender.isSelected.toggle()
    }
    @IBAction func backAction(_ sender:UIButton) {
        userVM.expIds.removeLast()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func prevAction(_ sender:UIButton) {
        if currentPage > 0 {
            currentPage -= 1
        }
        DispatchQueue.main.async {
            self.pageControl.currentPage = self.currentPage
            self.collection_images.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .left, animated: true)
        }
    }
    @objc func nxtAction(_ sender:UIButton) {
        if currentPage < (userImages.count-1) {
            currentPage += 1
        }
        DispatchQueue.main.async {
            self.pageControl.currentPage = self.currentPage
            self.collection_images.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .right, animated: true)
        }
    }
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension NewlyExperienceDetail: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return userImages.count
        }
        else if collectionView.tag == 1 {
            return expDetailModel.count
        }
        else if collectionView.tag == 2{
            return userVM.expDetail?.ratingInfo?.count ?? 0
        }
        else if collectionView.tag == 3 {
            return userVM.expDetail?.nearbyExp?.count ?? 0
        }
        else{
            return userVM.expDetail?.expDetail?.formattedOnlineTypes?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            let image_Baseurl = BaseURLs.experience_Image.rawValue
            cell.img_top.setImage(link: (image_Baseurl) + userImages[indexPath.row], placeholder: "no_image")
            return cell
        }
        else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionCell", for: indexPath) as! DetailsCollectionCell
            cell.configure(detail: expDetailModel[indexPath.row], exp: userVM.expDetail?.expDetail)
            return cell
        }
        else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Rating_Experience_Cell", for: indexPath) as! Rating_Experience_Cell
            cell.configureCell(with: userVM.expDetail?.ratingInfo?[indexPath.row])
            return cell
        }
        else if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as! ExperienceDetailsCell
            let data = userVM.expDetail?.nearbyExp?[indexPath.row]
            cell.configureCell(with: userVM.expDetail?.nearbyExp?[indexPath.row])
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineTypeCell", for: indexPath) as? OnlineTypeCell else { return .init()}
            cell.configure(onlineType: userVM.expDetail?.expDetail?.formattedOnlineTypes?[indexPath.row] ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = userVM.expDetail?.expDetail
        if collectionView.tag == 0{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else if collectionView.tag == 1{
            let width = (collectionView.frame.size.width - 10) / 2
            var height:Double = 50
            let type = expDetailModel[indexPath.row].type
            if type == .duration || type == .noOfGuest{
                let labelSize = UILabel().labelSize(width: width, height: .greatestFiniteMagnitude, font: UIFont.cabin_Regular(size: 14), text: data?.expDuration ?? "")
                height = labelSize.height + 26
                height = height < 50 ? 50 : height
                return CGSize(width: width, height: height)
            }
            else if type == .language || type == .ageRange{
                let labelSize = UILabel().labelSize(width: width, height: .greatestFiniteMagnitude, font: UIFont.cabin_Regular(size: 14), text: data?.formattedLanguage ?? "")
                height = labelSize.height + 26
                height = height < 50 ? 50 : height
                return CGSize(width: width, height: height)
            }
            else{
                return CGSize(width: width, height: 50)
            }
            
        } else if collectionView.tag == 2{
            let width = ((collectionView.frame.size.width-15) * 0.7)//0
            return CGSize(width: width, height: collectionView.frame.size.height)
        } else if collectionView.tag == 3{
            return CGSize(width: 160, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            currentPage = indexPath.row
            DispatchQueue.main.async {
                self.pageControl.currentPage = indexPath.row
                if self.currentPage == 0 {
                    self.prevBtn.setImage(UIImage(named: "prev_Grey"), for: .normal)
                    self.nxtBtn.setImage(UIImage(named: "nxt_White"), for: .normal)
                } else if self.currentPage == (self.userImages.count - 1) {
                    self.prevBtn.setImage(UIImage(named: "prev_White"), for: .normal)
                    self.nxtBtn.setImage(UIImage(named: "nxt_Grey"), for: .normal)
                } else {
                    self.prevBtn.setImage(UIImage(named: "prev_White"), for: .normal)
                    self.nxtBtn.setImage(UIImage(named: "nxt_White"), for: .normal)
                }

            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collection_similarExperience {
            let vc = UIStoryboard.loadNewlyExperienceDetail()
            vc.userVM = userVM
            vc.userVM.expIds.append(userVM.expDetail?.nearbyExp?[indexPath.row].expID ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - COLLECTIONVIEW CELLS
class ImagesCell:UICollectionViewCell{
    @IBOutlet weak var img_top:UIImageView!
}
class Rating_Experience_Cell:UICollectionViewCell{
    @IBOutlet weak var img_user:UIImageView!
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_comment:UILabel!
    
    func configureCell(with data: RatingInfo?) {
        img_user.setImage(link: data?.username ?? "")
        lbl_name.text = data?.username ?? ""
        lbl_comment.text = data?.ratingMessage ?? ""
        lbl_date.text = data?.date ?? ""
    }
}
class OnlineTypeCell: UICollectionViewCell{
    @IBOutlet weak var onlineTypeBtn: UIButton!
    
    func configure(onlineType: String){
        onlineTypeBtn.setImage(UIImage(named: onlineType), for: .normal)
    }
}
