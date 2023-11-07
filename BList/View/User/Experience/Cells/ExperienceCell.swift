//
//  ExperienceCell.swift
//  BList
//
//  Created by iOS TL on 16/05/22.
//

import UIKit
import IBAnimatable

class ExperienceCell: UITableViewCell {
    
    @IBOutlet weak var collection_Experience: UICollectionView!
    @IBOutlet weak var layout_collection    : NSLayoutConstraint!
    @IBOutlet weak var noDataLbl            : UILabel!
    weak var parent: AllCategoryVC?
    weak var experienceBasedVC: ExperiencesBasedOnCategoryVC?
    weak var userVM: UserViewModel?
    var itemIndex = 0
    func setData(){
        if itemIndex == 3{
            if let layout = collection_Experience.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical  // .horizontal
            }
            collection_Experience.isScrollEnabled = false
        }
        else{
            if let layout = collection_Experience.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            collection_Experience.isScrollEnabled = true
        }
    }
}
extension ExperienceCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM?.homeData[itemIndex-1].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExperienceDetailsCell", for: indexPath) as? ExperienceDetailsCell else{ return .init() }
        cell.configureCell(with: userVM?.homeData[itemIndex - 1].items?[indexPath.row])
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    @objc func likeBtnAction(_ sender:UIButton){
        let exp = userVM?.homeData[itemIndex - 1].items?[sender.tag]
        userVM?.homeData[itemIndex - 1].items?[sender.tag].favouriteStatus = exp?.favouriteStatus ?? 0 == 1 ? 0 : 1
        exp?.favouriteStatus ?? 0 == 1 ? parent?.userVM.makeUnFavourite(expId: exp?.expID ?? "") : parent?.userVM.makeFavourite(expId: exp?.expID ?? "")
        self.parent?.tbl_Experience.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if itemIndex == 1{
            return CGSize(width: 180, height:280)
        }
        else if itemIndex == 2{
            return CGSize(width: 220, height: 280)
        }
        else{
            return CGSize(width: (collectionView.frame.width-50)/2, height: 280)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userVM?.expIds.append(userVM?.homeData[itemIndex - 1].items?[indexPath.row].expID ?? "0")
        let vc = UIStoryboard.loadNewlyExperienceDetail()
        
        if parent == nil {
            vc.userVM = experienceBasedVC?.userVM
            experienceBasedVC?.navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.userVM = parent?.userVM
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class ExperienceDetailsCell: UICollectionViewCell{
    @IBOutlet weak var experienceImg    : AnimatableImageView!
    @IBOutlet weak var expNameLbl       : UILabel!
    @IBOutlet weak var nameLbl          : UILabel!
    @IBOutlet weak var amountLbl        : UILabel!
    @IBOutlet weak var likeBtn          : UIButton!
    @IBOutlet weak var typeBtn          : UIButton!
    @IBOutlet weak var categoryBtn      : UIButton!
    @IBOutlet weak var ratingBtn        : UIButton!
    @IBOutlet weak var mainView         : AnimatableView!
    
    func configureCell(with data: HomeItem?){
        experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverPhoto ?? ""), placeholder: "no_image")
        likeBtn.setImage((data?.favouriteStatus ?? 0) == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
//        amountLbl.attributedText = makeAttributedString(text1: "$ \(data?.amount ?? "0")", text2: "/ Person", completeText: "$ \(data?.amount ?? "0")/ Person", color1: "AppOrange", color2: "#B6B6B6", font1: UIFont.cabin_Medium(size: 9), font2: UIFont.cabin_Medium(size: 9))
        amountLbl.text = "$ \(data?.amount ?? "0")"
        nameLbl.text = data?.experienceName ?? ""
        typeBtn.setTitle(data?.expMode ?? "", for: .normal)
        categoryBtn.setTitle(data?.categoryName ?? "", for: .normal)
        let rating = Float(data?.averageRating ?? "0")?.rounded() ?? 0
    }
    func configureCell(with data: ExperienceDetails?){
        experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverImg ?? ""), placeholder: "no_image")
        likeBtn.setImage((data?.favouriteStatus ?? 0) == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
//        amountLbl.attributedText = makeAttributedString(text1: "$ \(data?.amount ?? "0")", text2: "/ Person", completeText: "$ \(data?.amount ?? "0")/ Person", color1: "AppOrange", color2: "#B6B6B6", font1: UIFont.cabin_Medium(size: 9), font2: UIFont.cabin_Medium(size: 9))
        amountLbl.text = "$ \(data?.amount ?? "0")"
        nameLbl.text = data?.experienceName ?? ""
        typeBtn.setTitle(data?.expMode ?? "", for: .normal)
        categoryBtn.setTitle(data?.categoryName ?? "", for: .normal)
        let rating = Float(data?.averageRating ?? "0")?.rounded() ?? 0
    }
    func configureRelatedExpCell(with data: ExperienceDetails?){
        experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverImg ?? ""), placeholder: "no_image")
        expNameLbl.text = data?.experienceName ?? ""
        amountLbl.text = "$ \(data?.amount ?? "0")"
        typeBtn.setTitle(data?.expMode ?? "", for: .normal)
        categoryBtn.setTitle(data?.categoryName ?? "", for: .normal)
        
    }
    
    func configureCell(with data: FilterResultsResponseModel.FilteredExperienceDetails?){
        experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverImg ?? ""), placeholder: "no_image")
        likeBtn.setImage((data?.favouriteStatus ?? 0) == 1 ? UIImage(named: "fav_active") : UIImage(named: "heart_gray"), for: .normal)
        amountLbl.text = "$ \(data?.amount ?? "0")"
        nameLbl.text = data?.experienceName ?? ""
        typeBtn.setTitle(data?.expMode ?? "", for: .normal)
        categoryBtn.setTitle(data?.categoryName ?? "", for: .normal)
        //let rating = Float(data?.averageRating ?? "0")?.rounded() ?? 0
    }
    
    func configureCell(with data: FavouritesListModel.ExpDetails){
        nameLbl.text = data.expName ?? ""
        let image = BaseURLs.experience_Image.rawValue + (data.images?.components(separatedBy: ",").first ?? "")
        experienceImg.setImage(link: image, placeholder: "no_image")
        amountLbl.text = "$\(data.price ?? "")"
    }

    func configureCell(with data: UserProfileResponseModel.ExpDetails?) {
        experienceImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.coverImg ?? ""), placeholder: "no_image")
        expNameLbl.text = data?.expName ?? ""
        amountLbl.text = data?.maxGuestAmount ?? ""
        categoryBtn.setTitle(data?.categoryName ?? "", for: .normal)
        categoryBtn.imageView?.setImage(link: BaseURLs.categoryURL.rawValue + (data?.categoryImage ?? ""), placeholder: "no_image")
        let rating = "\(Float(data?.averageRating ?? "") ?? 0.0)" + "(\(data?.totalRatingsCount ?? 0))"
        ratingBtn.setTitle(rating, for: .normal)
    }
}
