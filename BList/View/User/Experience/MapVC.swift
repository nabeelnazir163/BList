//
//  MapVC.swift
//  BList
//
//  Created by admin on 18/05/22.
//

import UIKit
import MapKit
import CoreLocation
struct ExperienceWithCoordinate{
    let id, expName, expCategory: String?
    let uploadFiles, minGuestAmount: String?
    let maxGuestAmount: String?
    let totalRatingsCount: Int?
    let averageRating: String?
    var favouriteStatus: Int?
    let coordinate : CLLocationCoordinate2D?
}
class MapVC: BaseClassVC {
    
    //MARK: - OUTLETS
    @IBOutlet weak var seperatorView    : UIView!
    @IBOutlet weak var searchTextField  : AnimatedBindingText!{
        didSet{
            searchTextField.bind { [unowned self] in
                userVM.search.value = $0 } }
    }
    @IBOutlet weak var myCollection     : UICollectionView!
    @IBOutlet weak var myView           : UIView!
    @IBOutlet weak var imageView        : UIImageView!
    @IBOutlet weak var starImageView    : UIImageView!
    @IBOutlet weak var vdBtn            : UIButton!
    @IBOutlet weak var expNameLbl       : UILabel!
    @IBOutlet weak var expPriceLbl      : UILabel!
    @IBOutlet weak var ratingLbl        : UILabel!
    @IBOutlet weak var favBtn           : UIButton!
    @IBOutlet weak var mapView          : MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    // MARK: - PROPERTIES
    var region: MKCoordinateRegion?
    //MARK:- PROPERTIES
    weak var userVM: UserViewModel!
    let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    var expImg: UIImage?
    var screenType: MapScreenType = .singleExp
    var filteredCoordinates = [ExperienceWithCoordinate]()
    var socketVM: ConnectSocketViewModel!
    var expID = ""
    //MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundObserver()
        showCurrentLocation()
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "custom")
        searchTextField.addTarget(self, action: #selector(searchFieldAction(_:)), for: .editingChanged)
        favBtn.addTarget(self, action: #selector(favBtnAction(_:)), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    @objc func tapAction(_ sender: UITapGestureRecognizer){
        DispatchQueue.main.async {
            if let selectedAnnotation = self.mapView.selectedAnnotations.first{
                self.mapView.deselectAnnotation(selectedAnnotation, animated: true)
                self.myView.alpha = 0
            }
        }
    }
    @objc func searchFieldAction(_ sender:UITextField){
        userVM.searchExperience()
    }
    func setCoordinates(){
        filteredCoordinates = []
        
        if let expList = userVM.searchExpModel?.data?.filter({$0.expMode == "In Person"}){
            var expList = expList
            for (index,expDetails) in expList.enumerated(){
                let latitudes = (expDetails.latitude ?? "").components(separatedBy: ",")
                let longitudes = (expDetails.longitude ?? "").components(separatedBy: ",")
                if latitudes.count == longitudes.count{
                    var coordinates = [CLLocationCoordinate2D]()
                    for i in 0..<latitudes.count{
                        coordinates.append(CLLocationCoordinate2D.init(latitude: Double(latitudes[i]) ?? 0, longitude: Double(longitudes[i]) ?? 0))
                    }
                    expList[index].coordinates = coordinates
                    coordinates.forEach { coordinate in
                        let expDetail = ExperienceWithCoordinate(id: expDetails.id, expName: expDetails.expName, expCategory: expDetails.expCategory, uploadFiles: expDetails.uploadFiles, minGuestAmount: expDetails.minGuestAmount, maxGuestAmount: expDetails.maxGuestAmount, totalRatingsCount: expDetails.totalRatingsCount, averageRating: expDetails.averageRating, favouriteStatus: expDetails.favouriteStatus, coordinate: coordinate)
                        filteredCoordinates.append(expDetail)
                    }
                }
            }
        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: userVM)
        switch screenType {
        case .singleExp:
            searchTextField.isHidden = true
            seperatorView.isHidden = false
            addCoordinatesToMap()
        case .multipleExp:
            searchTextField.isHidden = false
            seperatorView.isHidden = true
            userVM.searchExperience()
            fetchData()
        case .trackedUsers:
            searchTextField.isHidden = true
            seperatorView.isHidden = false
            socketVM = ConnectSocketViewModel(type: .creator)
            setUpVM(model: socketVM)
            socketVM.expID = expID
            socketVM.socketType = .autoCheckIn
            socketVM.connectLocationsSocket()
            socketVM.connectedCloser = {
                self.socketVM.checkIn()
            }
            socketVM.updateMessages = {
                self.addCoordinatesToMap()
            }
        }
        myView.alpha = 0
    }
    
    func fetchData(){
        userVM.didFinishFetch = {[weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .SearchExperience:
                self.myCollection.isHidden = false
                self.setCoordinates()
                self.addCoordinatesToMap()
                self.myCollection.reloadData()
            case .MakeFavourite, .MakeUnFavourite:
                
                if let index = self.filteredCoordinates.firstIndex(where: { expDetail in
                    expDetail.id == self.userVM.fav_unfavExp?.experienceID ?? ""
                })
                {
                    let favStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                    self.filteredCoordinates[index].favouriteStatus = favStatus
                    self.favBtn.setImage(favStatus == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
                }
                
                if let index = self.userVM.searchExpModel?.data?.firstIndex(where: { expDetail in
                    expDetail.id == self.userVM.fav_unfavExp?.experienceID ?? ""
                }){
                    self.userVM.searchExpModel?.data?[index].favouriteStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                }
            case .ExperienceDetails:
                break
            default:
                break
            }
        }
    }
    func addCoordinatesToMap(){
        switch screenType {
        case .singleExp:
            if let coordinates = userVM.expDetail?.expDetail?.coordinates{
                coordinates.forEach { coordinate in
                    let pin = MKPointAnnotation()
                    pin.title = userVM.expDetail?.expDetail?.expName ?? ""
                    pin.coordinate = coordinate
                    mapView.addAnnotation(pin)
                }
            }
        case .multipleExp:
            filteredCoordinates.forEach { expDetail in
                if let coordinate = expDetail.coordinate{
                    let pin = MKPointAnnotation()
                    pin.title = expDetail.expName ?? ""
                    pin.coordinate = coordinate
                    mapView.addAnnotation(pin)
                }
            }
        case .trackedUsers:
            if let coordinate = socketVM.locations?.coordinate {
                let pin = MKPointAnnotation()
                pin.title = socketVM.locations?.username ?? ""
                pin.coordinate = coordinate
                mapView.addAnnotation(pin)
            }
        }
    }
    
    override func appMovedToForeground() {
        showCurrentLocation()
    }
    
    // MARK: - ACTIONS
    @objc func favBtnAction(_ sender:UIButton){
        let exp = filteredCoordinates[sender.tag]
        exp.favouriteStatus ?? 0 == 1 ? userVM.makeUnFavourite(expId: exp.id ?? "") : userVM.makeFavourite(expId: exp.id ?? "")
    }
    @IBAction func actionVDBtn(_ sender: UIButton) {
        userVM.expIds.append(filteredCoordinates[sender.tag].id ?? "")
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        vc.userVM = userVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM.searchExpModel?.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? MyCollectionViewCell else { return .init()}
        let data = userVM.searchExpModel?.categories?[indexPath.row]
        cell.catNameLbl.text = data?.name ?? ""
        let imageString = BaseURLs.categoryURL.rawValue + (data?.image ?? "")
        cell.catImg.setImage(link: imageString)
        cell.selectionImg.isHidden = !(data?.isSelected ?? false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = userVM.searchExpModel?.categories?[indexPath.row]
        let label = UILabel()
        label.text = data?.name ?? ""
        label.font = UIFont.cabin_SemiBold(size: 10)
        let lblWidth = label.intrinsicContentSize.width
        var cellWidth = lblWidth + 19 + 8 + 8 + 8 + 5
        cellWidth = (data?.isSelected ?? false) == true ? cellWidth+16 : cellWidth
        return CGSize(width: cellWidth, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categories = userVM.searchExpModel?.categories
        userVM.searchExpModel?.categories = categories?.map({ category in
            var category = category
            category.isSelected = false
            return category
        })
        userVM.searchExpModel?.categories?[indexPath.row].isSelected = true
        userVM.categoryId = userVM.searchExpModel?.categories?[indexPath.row].id ?? ""
        userVM.searchExperience()
    }
}

// MARK: - COLLECTIONVIEW CELL
class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var catImg       : UIImageView!
    @IBOutlet weak var catNameLbl   : UILabel!
    @IBOutlet weak var selectionImg : UIImageView!
}

// MARK: - MKMAPVIEW DELEGATE METHODS
extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
        guard let annotationTitle = view.annotation?.title else{return}
        if let index = filteredCoordinates.firstIndex(where: { (experience) -> Bool in
            experience.expName ?? "" == annotationTitle
        }){
            let expDetails = filteredCoordinates[index]
            DispatchQueue.main.async { [weak self] in
                guard let self = self else{return}
                self.myView.alpha = 1
                self.imageView.setImage(link: BaseURLs.experience_Image.rawValue + ((expDetails.uploadFiles ?? "").components(separatedBy: ",").first ?? ""))
                self.expNameLbl.text = expDetails.expName ?? ""
                self.expPriceLbl.attributedText = makeAttributedString(text1: "$\(expDetails.minGuestAmount ?? "")/", text2: "person", completeText: "$\(expDetails.minGuestAmount ?? "")/person", color1: "AppOrange", color2: "#989595", font1: UIFont.cerebriSans_SemiBold(size: 12), font2: UIFont.cerebriSans_Book(size: 12))
                self.ratingLbl.text = "\(expDetails.averageRating ?? "") (\(expDetails.totalRatingsCount ?? 0))"
                self.favBtn.setImage((expDetails.favouriteStatus ?? 0) == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
            }
        }
        //        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard !(annotation is MKUserLocation) else{
            return nil
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom") as? LocationAnnotationView else{ return nil}
        
        let resizedSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(resizedSize)
        switch screenType{
        case .singleExp:
            expImg?.draw(in: CGRect(origin: .zero, size: resizedSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView.image = resizedImage
        case .multipleExp:
            guard let annotationTitle = annotation.title else{return .init()}
            if let index = filteredCoordinates.firstIndex(where: { (expDetail) -> Bool in
                expDetail.expName == annotationTitle
            }){
                Task{
                    let expImg = await downloadImage(from: BaseURLs.experience_Image.rawValue + ((filteredCoordinates[index].uploadFiles ?? "").components(separatedBy: ",").first ?? ""))
                    expImg?.draw(in: CGRect(origin: .zero, size: resizedSize))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    annotationView.image = resizedImage
                }
            }
        case .trackedUsers:
           
            Task{
                let userImg = await downloadImage(from: BaseURLs.userImgURL.rawValue + (socketVM.locations?.image ?? ""))
                userImg?.draw(in: CGRect(origin: .zero, size: resizedSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                annotationView.image = resizedImage
            return annotationView
            }
        }
        
        return annotationView
    }
}
// MARK: - CUSTOM ANNOTATIONVIEW
class LocationAnnotationView: MKAnnotationView{
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    
}

