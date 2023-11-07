//
//  UBlistBoardVC.swift
//  BList
//
//  Created by iOS Team on 11/05/22.
//

import UIKit
import IBAnimatable
import CoreLocation
import GooglePlaces

class UBlistBoardVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var wishListTblView          : UITableView!
    @IBOutlet weak var wishListTblHeightConst   : NSLayoutConstraint!
    @IBOutlet weak var commentTblView           : UITableView!
    @IBOutlet weak var commentTblHeightConst    : NSLayoutConstraint!
    @IBOutlet weak var pageControlView          : AdvancedPageControlView!
    @IBOutlet weak var updateCollView           : UICollectionView!
    @IBOutlet weak var wishListView             : AnimatableView!
    @IBOutlet weak var dontSeeAnLbl: UILabel!
    
    @IBOutlet weak var scrollView               : UIScrollView!
    @IBOutlet weak var locationLbl              : UILabel!
    @IBOutlet weak var searchTextView           : AnimatableTextView!
    @IBOutlet weak var searchField              : AnimatedBindingText!{
        didSet{
            searchField.bind { [unowned self] in
                userVM.keyword.value = $0
            }
        }
    }
    @IBOutlet weak var postContentField         : AnimatedBindingText!{
        didSet{
            postContentField.bind { [unowned self] in
                userVM.postContent.value = $0
            }
        }
    }
    @IBOutlet weak var addCommentBtn            : UIButton!
    @IBOutlet weak var locationView             : UIView!
    @IBOutlet weak var addPostSV                : UIStackView!
    @IBOutlet weak var searchView               : UIView!
    // MARK: - PROPERTIES
    var userVM: UserViewModel!
    var counter = 0
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControlView()
        userVM = UserViewModel(type: .SearchWishlists)
        searchField.addTarget(self, action: #selector(txtChangeAction(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapAction(_:)))
        locationView.addGestureRecognizer(tapGesture)
        addCommentBtn.addTarget(self, action: #selector(createPostAction(_:)), for: .touchUpInside)
        wishListView.borderType = .dash(dashLength: 5, spaceLength: 5)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: userVM)
        //addCommentBtn.isHidden = AppSettings.UserInfo == nil
        //addPostSV.isHidden = AppSettings.UserInfo == nil
        //searchView.isHidden = AppSettings.UserInfo == nil
        counter = 0
        fetchCurrentLocation()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTableHeight()
        print("WishList Table Height --> \(wishListTblHeightConst.constant)")
        print("Comment Table Height --> \(commentTblHeightConst.constant)")
    }
    // MARK: - OBJ METHODS
    @objc func txtChangeAction(_ sender:UITextField){
        userVM.searchComments()
    }
    @objc func locationTapAction(_ sender:UITapGestureRecognizer){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    // MARK: - KEY FUNCTIONS
    func fetchCurrentLocation(){
        if let lat = AppSettings.currentLocation?["lat"], let long = AppSettings.currentLocation?["long"] {
            self.userVM.latitude = "\(lat)"
            self.userVM.longitude = "\(long)"
            self.userVM.searchWishlists()
            self.userVM.searchComments()
            Task{
                for try await location in Locations(coordinates: [CLLocationCoordinate2D(latitude: lat, longitude: long)]){
                    if let city_state_country = location.city_state_country {
                        self.locationLbl.text = LocationManager.shared.appendAddress(components: city_state_country)
                    }
                }
            }
        }
    }
    
    func fetchData(){
        userVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .SearchWishlists:
                let wishListTblHeight = self.wishListTblView.getTableHeight()
                self.wishListTblHeightConst.constant = wishListTblHeight > 125 ? 250 : wishListTblHeight
            case .PostContent:
                let wishListTblHeight = self.wishListTblView.getTableHeight()
                self.wishListTblHeightConst.constant = wishListTblHeight > 125 ? 250 : wishListTblHeight
                self.postContentField.text?.removeAll()
                self.userVM.postContent.value.removeAll()
                self.userVM.postImage = nil
            case .GetComments,.SearchComments:
                let commentTblHeight = self.commentTblView.getTableHeight()
                self.commentTblHeightConst.constant = commentTblHeight > 357 ? 710 : commentTblHeight
            case .LikeComment, .DisLikeComment:
                break
            default:
                break
            }
        }
    }
    
    func setTableHeight(){
        let wishListTblHeight = wishListTblView.contentSize.height
        wishListTblHeightConst.constant = wishListTblHeight > 125 ? 250 : wishListTblHeight
        let commentTblHeight = self.commentTblView.contentSize.height
        self.commentTblHeightConst.constant = commentTblHeight > 357 ? 710 : commentTblHeight
    }
    /// Page Control View
    func setupPageControlView() {
        pageControlView.drawer = ExtendedDotDrawer(numberOfPages: 4,
                                                   height: 8.0,
                                                   width: 8.0,
                                                   space: 5.0,
                                                   indicatorColor: UIColor.white,
                                                   dotsColor: UIColor.white.withAlphaComponent(0.5),
                                                   isBordered: false,
                                                   borderWidth: 0.0,
                                                   indicatorBorderColor: .clear,
                                                   indicatorBorderWidth: 0.0)
    }
    
    // MARK: - ACTIONS
    @IBAction func sendBtnAction(_ sender:UIButton){
        if !userVM.postContent.value.isEmptyOrWhitespace(){
            userVM.postMsg()
        }
        else{
            self.showErrorMessages(message: "Please enter msg to send")
        }
    }
    @objc func createPostAction(_ sender:UIButton){
        let vc = UIStoryboard.loadAddCommentVC()
        vc.userVM = userVM
        vc.callBack = { [weak self] in
            guard let self = self else{return}
            let commentTblHeight = self.commentTblView.getTableHeight()
            self.commentTblHeightConst.constant = commentTblHeight > 357 ? 710 : commentTblHeight
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    
}


// MARK: - COLLECTION VIEW METHODS
extension UBlistBoardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BListUpdateCollectionCell", for: indexPath) as! BListUpdateCollectionCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return updateCollView.frame.size
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = updateCollView.indexPathsForVisibleItems.first {
            pageControlView.setPage(index.row)
        }
    }
}


// MARK: - TABLE VIEW METHODS
extension UBlistBoardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == wishListTblView{
            return userVM.wishLists.count
        }
        return userVM.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == wishListTblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BListPostTableCell", for: indexPath) as?  BListWishlistTableCell else{return .init()}
            cell.configureData(data: userVM.wishLists[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlistCommentTableCell", for: indexPath) as? BlistCommentTableCell else {return .init()}
            cell.configureData(data: userVM.posts[indexPath.row])
            addGesture(for: [cell.likeView,cell.dislikeView,cell.commentView], index: indexPath.row)
            return cell
        }
    }
    func addGesture(for views: [UIStackView], index: Int){
        for view in views{
            let tapGesture = MyTapGesture(target: self, action: #selector(likeOrDislikeTapAction(_:)))
            tapGesture.index = index
            view.addGestureRecognizer(tapGesture)
        }
    }
    @objc func likeOrDislikeTapAction(_ sender: MyTapGesture){
        let yourLike = userVM.posts[sender.index ?? 0].yourLike
        let likesCount = userVM.posts[sender.index ?? 0].likesCount ?? 0
        let disLikesCount = userVM.posts[sender.index ?? 0].dislikesCount ?? 0
        if sender.view?.tag == 0{
            // LIKE
            userVM.likeComment(postID: userVM.posts[sender.index ?? 0].id ?? "")
            userVM.posts[sender.index ?? 0].yourLike = (yourLike == "0" || yourLike == "2") ? "1" : "0"
            if yourLike == "0"{
                userVM.posts[sender.index ?? 0].likesCount = likesCount + 1
            }
            else if yourLike == "1"{
                userVM.posts[sender.index ?? 0].likesCount = likesCount > 0 ? likesCount-1 : 0
            }
            else{
                userVM.posts[sender.index ?? 0].dislikesCount = disLikesCount > 0 ? disLikesCount-1 : 0
                userVM.posts[sender.index ?? 0].likesCount = likesCount + 1
            }
            commentTblView.reloadRows(at: [IndexPath(row: sender.index ?? 0, section: 0)], with: .automatic)
        }
        else if sender.view?.tag == 1{
            // DISLIke
            userVM.disLikeComment(postID: userVM.posts[sender.index ?? 0].id ?? "")
            userVM.posts[sender.index ?? 0].yourLike = (yourLike == "0" || yourLike == "1") ? "2" : "0"
            if yourLike == "0"{
                userVM.posts[sender.index ?? 0].dislikesCount = disLikesCount + 1
            }
            else if yourLike == "2"{
                userVM.posts[sender.index ?? 0].dislikesCount = disLikesCount > 0 ? disLikesCount-1 : 0
            }
            else{
                userVM.posts[sender.index ?? 0].likesCount = likesCount > 0 ? likesCount-1 : 0
                userVM.posts[sender.index ?? 0].dislikesCount = disLikesCount + 1
            }
            commentTblView.reloadRows(at: [IndexPath(row: sender.index ?? 0, section: 0)], with: .automatic)
        }
        else{
            // Comment
            let vc = UIStoryboard.loadBBoardPostDetailVC()
            vc.userVM = userVM
            vc.postDetails = userVM.posts[sender.index ?? 0]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == wishListTblView{
            return UITableView.automaticDimension
        }
        return 357
    }
    
}


class BListUpdateCollectionCell: UICollectionViewCell {
    
}


class BlistCommentTableCell: UITableViewCell {
    @IBOutlet weak var userImg      : AnimatableImageView!
    @IBOutlet weak var userNameLbl  : UILabel!
    @IBOutlet weak var userMsg      : UILabel!
    @IBOutlet weak var timeLbl      : UILabel!
    @IBOutlet weak var likeView     : UIStackView!
    @IBOutlet weak var dislikeView  : UIStackView!
    @IBOutlet weak var commentView  : UIStackView!
    @IBOutlet weak var imgView      : AnimatableImageView!
    @IBOutlet weak var dividerLbl   : UILabel!
    @IBOutlet weak var bottomView   : UIView!
    @IBOutlet weak var likeCountLbl : UILabel!
    @IBOutlet weak var likeImg      : UIImageView!
    @IBOutlet weak var unlikeImg    : UIImageView!
    @IBOutlet weak var disLikeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    func configureData(data: postDetails?){
        userNameLbl.text = (data?.name ?? "")
        let userImageURL = BaseURLs.userImgURL.rawValue + (data?.image ?? "")
        userImg.setImage(link: userImageURL)
        userMsg.text = data?.postContent ?? ""
//        dividerLbl.isHidden = AppSettings.UserInfo?.id ?? "" == data?.userID ?? "" || AppSettings.UserInfo == nil
//        bottomView.isHidden = AppSettings.UserInfo?.id ?? "" == data?.userID ?? ""
        if data?.yourLike == "1"{
            likeImg.image = UIImage(named: "smile")
            unlikeImg.image = UIImage(named: "sad_unsel")
        }
        else if data?.yourLike == "2"{
            likeImg.image = UIImage(named: "smile_unsel")
            unlikeImg.image = UIImage(named: "sad")
        }
        else{
            likeImg.image = UIImage(named: "smile_unsel")
            unlikeImg.image = UIImage(named: "sad_unsel")
        }
        if imgView != nil{
            imgView.setImage(link: BaseURLs.postImgURL.rawValue + (data?.postImage ?? ""))
            imgView.isHidden = (data?.postImage ?? "" == "") ? true : false
        }
        if timeLbl != nil{
            if let createDate = data?.createdAt, let date = DateConvertor.shared.convert(dateInString: createDate, from: .yyyyMMddHHmmss, to: .yyyyMMddHHmmss).date, #available(iOS 13.0, *){
                timeLbl.text = date.timeAgoDisplay()
            }
            else{
                timeLbl.text = ""
            }
        }
        commentCountLbl.attributedText = createAttributedStr(text1: "Comments  ", text2: "(\(data?.commentsCount ?? 0))", font1: .cabin_Regular(size: 10), font2: .cabin_SemiBold(size: 10),textColor1: UIColor(named: "#C1C1C1")!,textColor2: .black)//"Comments(\(postDetails?.commentsCount ?? 0))"
        likeCountLbl.text = "\(data?.likesCount ?? 0)"
        disLikeCountLbl.text = "\(data?.dislikesCount ?? 0)"
    }
}


class BListWishlistTableCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl      : UILabel!
    @IBOutlet weak var userImg          : UIImageView!
    @IBOutlet weak var userMsg          : UILabel!
    @IBOutlet weak var timeLbl          : UILabel!
    
    func configureData(data: WishlistDetails?){
        userNameLbl.text = (data?.name ?? "")
        userNameLbl.setContentHuggingPriority(.required, for: .horizontal)
        let imageURL = BaseURLs.userImgURL.rawValue + (data?.img ?? "")
        userImg.setImage(link: imageURL)
        userMsg.text = data?.wishlistComment ?? ""
        if timeLbl != nil{
            if let createDate = data?.createdAt, let date = DateConvertor.shared.convert(dateInString: createDate, from: .yyyyMMddHHmmss, to: .yyyyMMddHHmmss, timezone: .UTC).date, #available(iOS 13.0, *){
                timeLbl.text = date.timeAgoDisplay()
            }
            else{
                timeLbl.text = ""
            }
        }
    }
}
// MARK: - GMSAutocompleteViewController Delegate Methods
extension UBlistBoardVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        
        var locationName = [String]()
        locationName.append(place.name ?? "")
        for component in place.addressComponents ?? []{
            appendLocationNameComponent(value: component.name)
        }
        userVM.location_arr.append(locationName.joined(separator: ", "))
        userVM.latitude = "\(place.coordinate.latitude)"
        userVM.longitude = "\(place.coordinate.longitude)"
        userVM.keyword.value = ""
        searchField.text?.removeAll()
        userVM.searchWishlists()
        locationLbl.text = place.formattedAddress ?? ""
        print("Searched Latitude -> \(place.coordinate.latitude)\n Searched Longitude -> \(place.coordinate.longitude)")
        func appendLocationNameComponent(value: String){
            if !locationName.contains(value){
                locationName.append(value)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

class MyTapGesture: UITapGestureRecognizer{
    var index: Int?
}
