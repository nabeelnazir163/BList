//
//  UTabBarVC.swift
//  BList
//
//  Created by Rahul Chopra on 10/05/22.
//

import UIKit
import IBAnimatable

class UTabBarVC: UITabBarController {
    
    let coustmeTabBarView: UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .white
//        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 10.0
        return view
    }()
    var hasBottom: Bool {
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    var imgView = UIImageView()
    var imageViewContainer = AnimatableView()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        addcoustmeTabBarView()
        hideTabBarBorder()
        updateTabBarItems()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        coustmeTabBarView.frame = tabBar.frame
    }
    func updateTabBarItems(){
        if AppSettings.UserInfo == nil{
            viewControllers = [
                UIStoryboard.loadExperienceTabVC(),
                UIStoryboard.loadUBlistBoardVC(),
                UIStoryboard.loadUProfileVC()
            ]
            tabBar.items?.last?.title = "Login"
        }
        else{
           viewControllers = [
                UIStoryboard.loadExperienceTabVC(),
                UIStoryboard.loadUFavoriteVC(),
                UIStoryboard.loadUBlistBoardVC(),
                UIStoryboard.loadUInboxVC(),
                UIStoryboard.loadUProfileVC()
            ]
            tabBar.items?.last?.title = "Profile"
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        var newSafeArea = UIEdgeInsets()
//        newSafeArea.bottom += coustmeTabBarView.bounds.size.height
//        self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
//        self.addSubviewToLastTabItem("catergory1", addShadow: false)
    }
    
    
    // MARK: - CORE METHODS
    private func addcoustmeTabBarView() {
        coustmeTabBarView.frame = tabBar.frame
        view.addSubview(coustmeTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    private func hideTabBarBorder()  {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }
    
    private func addSubviewToLastTabItem(_ imageName: String,addShadow:Bool) {
        if let lastTabBarButton = self.tabBar.subviews.last, let tabItemImageView = lastTabBarButton.subviews.first {
            if let accountTabBarItem = self.tabBar.items?.last {
              //  self.imgView.setImageWithPlaceholder(link: imageName, imgName: "user_dummy")
                accountTabBarItem.selectedImage   = nil
                accountTabBarItem.image           = nil
                accountTabBarItem.selectedImage = self.imgView.image
                accountTabBarItem.image         = self.imgView.image
            }
            
//            if self.hasBottom{
//                imageViewContainer.frame = CGRect(x: 20, y: 25, width: 30, height: 30)
//            }
//            else{
//                imageViewContainer.frame = CGRect(x: 20, y: 17, width: 30, height: 30)
//            }
            
            imageViewContainer.frame = lastTabBarButton.bounds//coustmeTabBarView.frame
            
            imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)//
//            imgView.cornerRadiusCustom  = 15
//            imageViewContainer.cornerRadiusCustom  = 15
            imgView.contentMode         = .scaleAspectFill
            
            if addShadow{
                imageViewContainer.shadowOffset = CGPoint(x: 0, y: 3)
                imageViewContainer.shadowColor = UIColor.init(red: 40/255, green: 118/255, blue: 249/255, alpha: 1)
                imageViewContainer.shadowRadius = 10
                imageViewContainer.shadowOpacity = 1
                imageViewContainer.cornerRadius = tabItemImageView.frame.height/2
            }
            else{
                imageViewContainer.shadowOpacity = 0
            }
            
            self.imgView.setImage(link: imageName, placeholder: "user_dummy")
//            self.imgView.removeFromSuperview()
//            self.imageViewContainer.removeFromSuperview()
            self.imageViewContainer.addSubview(self.imgView)
//            self.tabBar.subviews.last?.addSubview(self.imageViewContainer)
            self.coustmeTabBarView.addSubview(self.imageViewContainer)
            
        }
    }

}
