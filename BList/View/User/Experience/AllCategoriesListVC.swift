//
//  AllCategoriesListVC.swift
//  BList
//
//  Created by iOS TL on 06/06/22.
//

import UIKit

class AllCategoriesListVC: BaseClassVC {
    weak var userVM: UserViewModel!
    @IBOutlet weak var collection_category:UICollectionView!
    var selectedIndex: ((_ selIndex: Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension AllCategoriesListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userVM.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return CategoryCell()
        }
        cell.configureCell(data: userVM.categories[indexPath.row])
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 48)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex?(indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
}
