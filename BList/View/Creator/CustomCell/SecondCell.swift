//
//  SecondCell.swift
//  BList
//
//  Created by admin on 26/05/22.
//

import Foundation
import UIKit
import IBAnimatable
class SecondCell: UITableViewCell {
    @IBOutlet weak var view_Collection: UICollectionView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
extension SecondCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        if indexPath.row == 0{
            cell.back_view.borderWidth = 1
        }
        else{
            cell.back_view.borderWidth = 0
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 160)
    }
    
}
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: AnimatableImageView!
    @IBOutlet weak var back_view: AnimatableView!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var btn_Min: UIButton!
    @IBOutlet weak var btn_Plus: UIButton!
    
}
