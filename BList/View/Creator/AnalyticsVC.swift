//
//  AnalyticsVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 03/04/23.
//

import UIKit
import FloatRatingView
import IBAnimatable

class AnalyticsVC: BaseClassVC {
    enum AnalyticSections: Int {
        case incomeInDays = 0
        case topExperiences
        case myExperiences
        case demographicData
        case experienceRatings
    }
    // MARK: - OUTLETS
    @IBOutlet weak var analyticsCV  : UICollectionView!
    
    // MARK: - PROPERTIES
    var creatorVM: CreatorViewModel!
    var ratings: [GetAnalyticsResponseModel.MyExperience.RatingDetails]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorVM = CreatorViewModel(type: .GetAnalytics)
        analyticsCV.collectionViewLayout = createLayout()
        // Do any additional setup after loading the view.
    }
    func createLayout() -> UICollectionViewCompositionalLayout{
        .init { [weak self](sectionIndex, layoutEnvironment) in
            guard let self = self else{return nil}
            if let section:AnalyticSections = AnalyticSections(rawValue: sectionIndex){
                switch section {
                case .incomeInDays:
                    let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                    let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .absolute(98), items: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .none
                    return section
                case .topExperiences:
                    let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                    let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .absolute(97), items: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 0, bottom: 16, trailing: 0)
                    return section
                case .myExperiences:
                    let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), top: 0, bottom: 0, leading: 0, trailing: 0)
                    let group = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.48), height: .absolute(170), items: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 12, bottom: 19, trailing: 12)
                    section.boundarySupplementaryItems = [self.myExpSupplementaryHeaderItem()] //[self.supplementaryHeaderItem()]
                    section.supplementariesFollowContentInsets = false
                    return section
                case .demographicData:
                    let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), top: 5, bottom: 0, leading: 0, trailing: 0)
                    let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .absolute(146), items: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .none
                    section.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 18, bottom: 20, trailing: 18)
                    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                    section.supplementariesFollowContentInsets = true
                    return section
                case .experienceRatings:
                    let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .estimated(20), top: 5, bottom: 10, leading: 0, trailing: 0)
                    let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .estimated(20), items: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .none
                    section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 18, bottom: 15, trailing: 18)
                    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                    section.supplementariesFollowContentInsets = true
                    return section
                }
            }
            else{
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), items: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func myExpSupplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpVM(model: creatorVM)
        creatorVM.getAnalytics()
        creatorVM.didFinishFetch = { [weak self](_) in
            guard let self = self else {return}
            if (self.creatorVM.analyticsData?.count ?? 0) > 2, (self.creatorVM.analyticsData?[2].myExperiences?.count ?? 0) > 0 {
                self.creatorVM.analyticsData?[2].myExperiences?[0].isSelected = true
                if let ratings = self.creatorVM.analyticsData?[2].myExperiences?[0].rate_arr {
                    self.ratings = ratings
                } else {
                    self.ratings = K.getDummyRatings()
                }
            }
            self.analyticsCV.reloadData()
        }
    }
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension AnalyticsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return creatorVM.analyticsData?[section].topExperiences?.count ?? 0
        } else if section == 2{
            return creatorVM.analyticsData?[section].myExperiences?.count ?? 0
        } else if section == 3{
            return 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        creatorVM.analyticsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeader", for: indexPath) as? TitleHeader else {return .init()}
            view.title.text = creatorVM.analyticsData?[indexPath.section].sectionName ?? ""
            return view
        default:
            return .init()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = AnalyticSections(rawValue: indexPath.section)
        switch type {
        case .incomeInDays:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomeInDaysCell", for: indexPath) as? IncomeInDaysCell else{return .init()}
            let incomeData = creatorVM.analyticsData?[indexPath.section]
            cell.income_7Days.text = "$\((incomeData?.incomeInDays?.last_7 ?? "") == "" ? "0" : (incomeData?.incomeInDays?.last_7 ?? ""))"
            cell.income_30Days.text = "$\((incomeData?.incomeInDays?.last_30 ?? "") == "" ? "0" : (incomeData?.incomeInDays?.last_30 ?? ""))"
            cell.income_365Days.text = "$\((incomeData?.incomeInDays?.last_365 ?? "") == "" ? "0" : (incomeData?.incomeInDays?.last_365 ?? ""))"
            return cell
        case .topExperiences:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopExperienceCell", for: indexPath) as? TopExperienceCell else{return .init()}
            cell.configureCell(with: creatorVM.analyticsData?[indexPath.section].topExperiences?[indexPath.row])
            return cell
        case .myExperiences:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyExperienceCell", for: indexPath) as? MyExperienceCell else{return .init()}
            cell.configureCell(with: creatorVM.analyticsData?[indexPath.section].myExperiences?[indexPath.row])
            return cell
        case .demographicData:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemographicCell", for: indexPath) as? DemographicCell else{return .init()}
            return cell
        case .experienceRatings:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingColCell", for: indexPath) as? RatingColCell else{return .init()}
            cell.ratings = self.ratings
            cell.tableHeight.constant = cell.ratingsTbl.getTableHeight()
            return cell
        case .none:
            return .init()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let ratings = creatorVM.analyticsData?[indexPath.section].myExperiences?[indexPath.row].rate_arr, ratings.count > 0 {
                self.ratings = ratings
            } else {
                self.ratings = K.getDummyRatings()
            }
            var myExp = creatorVM.analyticsData?[indexPath.section].myExperiences
            let index = myExp?.firstIndex(where: {$0.isSelected == true})
            creatorVM.analyticsData?[indexPath.section].myExperiences = myExp?.map({ exp in
                var exp = exp
                exp.isSelected = false
                return exp
            })
            creatorVM.analyticsData?[indexPath.section].myExperiences?[indexPath.row].isSelected = true
            DispatchQueue.main.async {
                if let index = index {
                    self.analyticsCV.reloadItems(at: [indexPath, IndexPath(item: index, section: 2)])
                } else {
                    self.analyticsCV.reloadItems(at: [indexPath])
                }
                self.analyticsCV.reloadSections([4])
            }
        }
    }
}


struct AnalyticsData{
    let sectionName     : String?
    var incomeInDays    : IncomeInDays?
    var topExperiences  : [GetAnalyticsResponseModel.TopExperience]?
    var myExperiences   : [GetAnalyticsResponseModel.MyExperience]?
}

struct IncomeInDays {
    let last_7: String?
    let last_30: String?
    let last_365: String?
}
struct DemographicData {
    let ageRange: String?
    let similarEmployees: String?
}
class IncomeInDaysCell: UICollectionViewCell {
    @IBOutlet weak var income_7Days: UILabel!
    @IBOutlet weak var income_30Days: UILabel!
    @IBOutlet weak var income_365Days: UILabel!
}
class TopExperienceCell: UICollectionViewCell {
    @IBOutlet weak var expName: UILabel!
    @IBOutlet weak var expStartDate: UILabel!
    @IBOutlet weak var expTime: UILabel!
    @IBOutlet weak var expPrice: UILabel!
    
    func configureCell(with data: GetAnalyticsResponseModel.TopExperience?) {
        expName.text = data?.experienceName ?? ""
        expTime.text = data?.timeSlots_arr?.first ?? ""
        expPrice.text = "$\(data?.minGuestAmount ?? "")"
    }
}

class MyExperienceCell: UICollectionViewCell {
    @IBOutlet weak var expName: UILabel!
    @IBOutlet weak var expCatName: UILabel!
    @IBOutlet weak var expCatImg: UIImageView!
    @IBOutlet weak var expPrice: UILabel!
    @IBOutlet weak var expImg: UIImageView!
    @IBOutlet weak var borderView: AnimatableView!
    func configureCell(with data: GetAnalyticsResponseModel.MyExperience?) {
        expName.text = data?.expName ?? ""
        expCatName.text = data?.categoryName ?? ""
        expImg.setImage(link: BaseURLs.experience_Image.rawValue + (data?.uploadFiles?.components(separatedBy: ",").first ?? ""))
        expCatImg.setImage(link: BaseURLs.categoryURL.rawValue + (data?.categoryImage ?? ""))
        expPrice.text = "$ " + (data?.minGuestAmount ?? "")
        borderView.borderWidth = (data?.isSelected == true) ? 1 : 0
        borderView.borderColor = (data?.isSelected == true) ? UIColor(named: "AppOrange") : UIColor.clear
    }
}


class DemographicCell: UICollectionViewCell {
    
}

class RatingColCell: UICollectionViewCell {
    @IBOutlet weak var ratingsTbl: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var ratings: [GetAnalyticsResponseModel.MyExperience.RatingDetails]?
     func viewDidLayoutSubviews() {
        tableHeight.constant = ratingsTbl.contentSize.height
        print("Table Height --> \(tableHeight.constant)")
    }
}
extension RatingColCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ratings?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTblCell", for: indexPath) as? RatingTblCell else { return .init() }
        cell.configureCell(with: ratings?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}

class RatingTblCell: UITableViewCell {
    @IBOutlet weak var ratingCat: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!{
        didSet{
            ratingView.editable = false
        }
    }
    
    func configureCell(with data: GetAnalyticsResponseModel.MyExperience.RatingDetails?) {
        ratingCat.text = data?.ratingCat ?? ""
        progressView.progress = (data?.ratingValue ?? 0.0)/5.0
        progressView.progressTintColor = data?.ratingColor
        ratingLbl.text = String(format: "%.1f", data?.ratingValue ?? 0.0)
        ratingView.rating = Double(data?.ratingValue ?? 0.0)
    }
}

