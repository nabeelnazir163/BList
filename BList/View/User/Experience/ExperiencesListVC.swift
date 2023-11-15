//
//  BlistFeatureListVC.swift
//  BList
//
//  Created by iOS TL on 06/06/22.
//

import UIKit


enum ExperienceType:Int{
    case top = 1
    case new
    case blist
    case seeAll
}

class ExperiencesListVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var expCV    :  UICollectionView!
    @IBOutlet weak var noDataLbl: UILabel!
    // MARK: - PROPERTIES
    weak var userVM: UserViewModel!
    var expType: ExperienceType?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: userVM)
        setHeaderTitle()
        userVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else {return}
            switch apiType{
            case .MakeFavourite, .MakeUnFavourite:
                self.userVM.seeAllExperiences = self.userVM.seeAllExperiences.map({ exp in
                    var exp = exp
                    if exp.expID ?? "" == self.userVM.fav_unfavExp?.experienceID ?? ""{
                        exp.favouriteStatus = Int(self.userVM.fav_unfavExp?.doFavorite ?? "")
                    }
                    return exp
                })
                self.expCV.reloadData()
            default:
                self.noDataLbl.isHidden = !self.userVM.seeAllExperiences.isEmpty
                self.expCV.reloadData()
            }
        }
    }
    func setHeaderTitle(){
        userVM.seeAllExperiences = []
        switch expType {
        case .top:
            titleLbl.text = "Top Experiences"
            userVM.topExperiences()
        case .new:
            titleLbl.text = "New Experiences"
            userVM.newCreatedExperiences()
        case .blist:
            titleLbl.text = "Blist Experiences"
            userVM.blistFeatureList()
        case .seeAll:
            titleLbl.text = "Similar Experiences"
            userVM.seeAllExperiences = userVM.expDetail?.nearbyExp ?? []
        case .none:
            break
        }
    }
}
extension ExperiencesListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM.seeAllExperiences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as? ExperienceDetailsCell else {
            return .init()
        }
        cell.configureCell(with: userVM.seeAllExperiences[indexPath.row])
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeBtnAction(_ sender:UIButton){
        let exp = userVM.seeAllExperiences[sender.tag]
        userVM.seeAllExperiences[sender.tag].favouriteStatus = (exp.favouriteStatus ?? 0) == 1 ? 0 : 1
        expCV.reloadData()
        exp.favouriteStatus ?? 0 == 1 ? userVM.makeUnFavourite(expId: exp.expID ?? "") : userVM.makeFavourite(expId: exp.expID ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40) / 2
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userVM.expIds.append(userVM.seeAllExperiences[indexPath.row].expID ?? "")
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        vc.userVM = userVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
