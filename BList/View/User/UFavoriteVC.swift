//
//  UFavoriteVC.swift
//  BList
//
//  Created by Rahul Chopra on 10/05/22.
//

import UIKit

class UFavoriteVC: BaseClassVC {
    
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var noDateLbl        : UILabel!
    var userVM: UserViewModel!
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = UserViewModel(type: .FavouriteExperiencesList)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: userVM)
        userVM.getFavouritesList()
        fetchData()
    }
    func fetchData(){
        userVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .MakeUnFavourite:
                if let index = self.userVM.favouritesList.firstIndex(where: { exp in
                    exp.experienceID ?? "" == self.userVM.fav_unfavExp?.experienceID ?? ""
                }){
                    self.userVM.favouritesList.remove(at: index)
                }
            default:
                break
            }
            self.noDateLbl.alpha = (self.userVM.favouritesList.isEmpty == true) ? 1 : 0
            self.collectionView.reloadData()
        }
    }
}


extension UFavoriteVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM.favouritesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as? ExperienceDetailsCell else{return .init()}
        cell.configureCell(with: userVM.favouritesList[indexPath.row])
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    @objc func likeBtnAction(_ sender:UIButton){
        userVM.makeUnFavourite(expId: userVM.favouritesList[sender.tag].experienceID ?? "")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.size.width - 40) / 2
        return CGSize(width: width, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userVM.expIds.append(userVM.favouritesList[indexPath.row].experienceID ?? "0")
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        vc.userVM = userVM
        navigationController?.pushViewController(vc, animated: true)
    }
}
