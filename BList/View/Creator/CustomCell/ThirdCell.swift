//
//  ThirdCell.swift
//  BList
//
//  Created by admin on 26/05/22.
//

import Foundation
import UIKit
class ThirdCell: UITableViewCell{
    @IBOutlet weak var view_Collection: UICollectionView!
    @IBOutlet weak var nslayout_collectionHeight: NSLayoutConstraint!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
extension ThirdCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 || indexPath.row == 3{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath) as? CollectionViewCell2 else {
                return CollectionViewCell2()
            }
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell3", for: indexPath) as? CollectionViewCell3 else {
                return CollectionViewCell3()
            }
            return cell
        }
     
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: width, height: 72)
    }
    
}
class CollectionViewCell2:UICollectionViewCell{
    
}

class CollectionViewCell3:UICollectionViewCell{
    
}
