//
//  AddNewExpVC.swift
//  BList
//
//  Created by admin on 24/05/22.
//

import UIKit

class AddNewExpVC: UIViewController {

    @IBOutlet weak var myCollection: UICollectionView!
    
    var label = ["Adventure","Events"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
extension AddNewExpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return label.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == label.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddMoreCell
            return cell
        }
        else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell2
        cell.lbl.text = label[indexPath.row]
        return cell
        }
    }
    
}
class AddMoreCell : UICollectionViewCell{
    
}
class MyCollectionViewCell2: UICollectionViewCell {
    @IBOutlet weak var closeBtn : UIButton!
    @IBOutlet weak var lbl      : UILabel!

}
