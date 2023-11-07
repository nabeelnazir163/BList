//
//  UTransactionDetailVC.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import UIKit

class UTransactionDetailVC: BaseClassVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
}


extension UTransactionDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetailModel.data().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionCell", for: indexPath) as! DetailsCollectionCell
        cell.headingLbl.text = DetailModel.data()[indexPath.row].heading
        cell.subheadingLbl.text = DetailModel.data()[indexPath.row].subheading
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: width, height: 50)
    }
}


class DetailsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var subheadingLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    func configure(detail: DetailModel, exp: ExpDetail?) {
        headingLbl.text = detail.heading
        
        switch detail.type {
        case .activityLevel:
            subheadingLbl.text = exp?.activityLevel?.capitalized
        case .group:
            subheadingLbl.text = (exp?.expType ?? "1") == "1" ? "Both" :((exp?.expType ?? "1") == "2" ? "Private" : "Group")
        case .duration:
            subheadingLbl.text = exp?.expDuration?.capitalized
        case .noOfGuest:
            subheadingLbl.text = "Attending \(exp?.minGuestLimit ?? "0") Max \(exp?.maxGuestLimit ?? "0")"
        case .language:
            subheadingLbl.text = exp?.formattedLanguage ?? ""
        case .ageRange:
            subheadingLbl.text = "\(exp?.minAgeLimit ?? "0") to \(exp?.maxAgeLimit ?? "0") years"
        case .handicap:
            subheadingLbl.text = exp?.handicapAccessible?.capitalized ?? "No"
        case .petAllow:
            subheadingLbl.text = exp?.petAllowed?.capitalized ?? "No"
        case .creatorPresent:
            subheadingLbl.text = exp?.creatorPresence?.capitalized ?? "No"
        case .experinceMode:
            subheadingLbl.text = exp?.expMode ?? ""
        }
    }
}
