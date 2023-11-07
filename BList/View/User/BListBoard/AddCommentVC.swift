//
//  AddCommentVC.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 01/02/23.
//

import UIKit
import GrowingTextView
class AddCommentVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var photosCV     : UICollectionView!
    @IBOutlet weak var msgTxtview   : GrowingTextView!
    @IBOutlet weak var stackViewBottom: NSLayoutConstraint!
    weak var userVM: UserViewModel!
    var callBack:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM.commentImg = nil
        msgTxtview.font = AppFont.cabinRegular.withSize(15.0)
        setUpVM(model: userVM)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: - ACTIONS
    @IBAction func addPhotosBtnAction(_ sender:UIButton){
        let share = CameraHandler.shared
        share.showActionSheet(vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            self.photosCV.isHidden = false
            self.userVM.commentImg = img
            self.photosCV.reloadData()
        }
    }
    @objc func keyboardWillShow(notification: NSNotification)  {
        
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            let y = keyboardFrame.height - CGFloat(bottomPadding ?? 0.0)
            self.stackViewBottom.constant = (y-180) > 30 ? (y-180) : 30
            self.view.layoutIfNeeded()
            
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.stackViewBottom.constant = 30
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func publishBtnAction(_ sender:UIButton){
        if let comment = msgTxtview.text{
            userVM.comment = comment
            userVM.postComment()
            userVM.didFinishFetch = { [weak self](_) in
                guard let self = self else{return}
                self.callBack?()
                self.dismiss(animated: true)
            }
        }
        else{
            showErrorMessages(message: "please add a comment to post")
        }        
    }
}
// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE METHODS
extension AddCommentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionCell", for: indexPath) as? PhotosCollectionCell else{return .init()}
        cell.imgView.image = userVM.commentImg
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    @objc func deleteBtnAction(_ sender:UIButton){
        userVM.commentImg = nil
        photosCV.isHidden = true
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width//200
                      , height: 150)
    }
}
