//
//  FilterResultsVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 02/01/23.
//

import UIKit

class FilterResultsVC: BaseClassVC {
    enum ScreenType{
        case filter
        case search
    }
    // MARK: - OUTLETS
    @IBOutlet weak var filterResultsCV  : UICollectionView!
    @IBOutlet weak var noDataLbl        : UILabel!
    @IBOutlet weak var resultsCountLbl  : UILabel!
    @IBOutlet weak var searchField      : AnimatedBindingText!{
        didSet{
            searchField.bind { [unowned self] in
                userVM.search.value = $0
            }
        }
    }
    // MARK: - PROPERTIES
    var screenType: ScreenType = .filter
    weak var userVM: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.addTarget(self, action: #selector(searchFieldAction(_:)), for: .editingChanged)
        setUpVM(model: userVM)
        setUpData()
        fetchData()
    }
    func setUpData(){
        switch screenType{
        case .filter:
            searchField.isHidden = true
            let count = userVM.filteredExperienceResults?.count
            if count == 0{
                noDataLbl.isHidden = false
            }
            resultsCountLbl.text = "Filter Results(\(count ?? 0))"
        case .search:
            searchField.isHidden = false
            userVM.searchExperience()
        }
    }
    func fetchData(){
        userVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .SearchExperience:
                let count = self.userVM.experiences?.count
                self.resultsCountLbl.text = "Search Results(\(count ?? 0))"
                if count == 0{
                    self.noDataLbl.isHidden = false
                }
            case .MakeFavourite, .MakeUnFavourite:
                switch self.screenType {
                case .search:
                    self.userVM.experiences = self.userVM.experiences?.map({ homeItem in
                        var homeItem = homeItem
                        if homeItem.id ?? "" == self.userVM.fav_unfavExp?.experienceID ?? ""{
                            homeItem.favouriteStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                        }
                        return homeItem
                    })
                case .filter:
                    self.userVM.filteredExperienceResults = self.userVM.filteredExperienceResults?.map({ homeItem in
                        var homeItem = homeItem
                        if homeItem.id ?? "" == self.userVM.fav_unfavExp?.experienceID ?? ""{
                            homeItem.favouriteStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                        }
                        return homeItem
                    })
                }
                
            default:
                break
            }
            self.filterResultsCV.reloadData()
        }
    }
    @objc func searchFieldAction(_ sender: UITextField){
        userVM.searchExperience()
    }
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension FilterResultsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch screenType{
        case .filter:
            return userVM.filteredExperienceResults?.count ?? 0
        case .search:
            return userVM.experiences?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as? ExperienceDetailsCell else {
            return ExperienceDetailsCell()
        }
        
        switch screenType{
        case .filter:
            cell.configureCell(with: userVM.filteredExperienceResults?[indexPath.row])
        case .search:
            let data = userVM.experiences?[indexPath.row]
            cell.experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.uploadFiles ?? ""), placeholder: "no_image")
            cell.likeBtn.setImage((data?.favouriteStatus ?? 0) == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
            cell.amountLbl.text = "$ \(data?.minGuestAmount ?? "0")"
            cell.nameLbl.text = data?.expName ?? ""
        }
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    @objc func likeBtnAction(_ sender:UIButton){
        switch screenType {
        case .filter:
            let exp = userVM.filteredExperienceResults?[sender.tag]
            exp?.favouriteStatus ?? 0 == 1 ? userVM.makeUnFavourite(expId: exp?.id ?? "") : userVM.makeFavourite(expId: exp?.id ?? "")
            userVM?.filteredExperienceResults?[sender.tag].favouriteStatus = exp?.favouriteStatus ?? 0 == 1 ? 0 : 1
        case .search:
            let exp = userVM.experiences?[sender.tag]
            exp?.favouriteStatus ?? 0 == 1 ? userVM.makeUnFavourite(expId: exp?.id ?? "") : userVM.makeFavourite(expId: exp?.id ?? "")
            userVM?.experiences?[sender.tag].favouriteStatus = exp?.favouriteStatus ?? 0 == 1 ? 0 : 1
        }
        DispatchQueue.main.async {
            self.filterResultsCV.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        switch screenType{
        case .filter:
            let data = userVM.filteredExperienceResults?[indexPath.row]
//            userVM.expIds.append(data?.expID ?? "0")
            userVM.expIds.append(data?.id ?? "0")
        case .search:
            let data = userVM.experiences?[indexPath.row]
            userVM.expIds.append(data?.id ?? "0")
        }
        vc.userVM = userVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
