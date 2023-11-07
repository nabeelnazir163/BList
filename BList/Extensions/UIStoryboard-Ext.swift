//
//  UIStoryboard-Ext.swift
//  BList
//
//  Created by Rahul Chopra on 15/05/22.
//

import Foundation
import UIKit


enum StoryboardType: String {
    case user = "User"
    case creator = "Creator"
    case auth = "Auth"
    case experience = "Experience"
}


extension UIStoryboard {
    static func storyboardType(type: StoryboardType) -> UIStoryboard {
        return UIStoryboard(name: type.rawValue, bundle: nil)
    }
    
    static func setTo(type: StoryboardType, vcName: String) {
        let storyboard = UIStoryboard(name: type.rawValue, bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: vcName)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    static func loadFromAuthorization(_ identifier: String) -> UIViewController {
        return loadFromAuthorizationStoryboard(from: .auth, identifier: identifier)
    }
    static func loadFromExperience(_ identifier: String) -> UIViewController {
        return loadFromExperienceStoryboard(from: .experience, identifier: identifier)
    }
    static func loadFromUser(_ identifier: String) -> UIViewController {
        return loadFromUserStoryboard(from: .user, identifier: identifier)
    }
    static func loadFromCreator(_ identifier: String) -> UIViewController {
        return loadFromCreatorStoryboard(from: .creator, identifier: identifier)
    }
    
    static func loadFromAuthorizationStoryboard(from storyboard: StoryboardType, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    static func loadFromExperienceStoryboard(from storyboard: StoryboardType, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    static func loadFromUserStoryboard(from storyboard: StoryboardType, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    static func loadFromCreatorStoryboard(from storyboard: StoryboardType, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
extension UIStoryboard {
    //ViewControllers of Authorization Storyboard
    static func loadCountryListTable() -> CountryListTable {
        return loadFromAuthorization("CountryListTable")as! CountryListTable
    }
    static func loadLoginVC() -> LoginVC {
        return loadFromAuthorization("LoginVC")as! LoginVC
    }
    static func loadUnAuthorizedVC() -> UnAuthorizedVC {
        return loadFromAuthorization("UnAuthorizedVC")as! UnAuthorizedVC
    }
    
    
    //ViewControllers of Experience Storyboard
    static func loadMapVC() -> MapVC {
        return loadFromExperience("MapVC")as! MapVC
    }
    static func loadNewlyExperienceDetail() -> NewlyExperienceDetail {
        return loadFromExperience("NewlyExperienceDetail")as! NewlyExperienceDetail
    }
    static func loadChangeLocationVC() -> ChangeLocationVC {
        return loadFromExperience("ChangeLocationVC")as! ChangeLocationVC
    }
    static func loadBookingSuccessfully() -> BookingSuccessfully {
        return loadFromExperience("BookingSuccessfully")as! BookingSuccessfully
    }
    static func loadChooseMemberVC() -> ChooseMemberVC {
        return loadFromExperience("ChooseMemberVC")as! ChooseMemberVC
    }
    static func loadExperiencesListVC() -> ExperiencesListVC {
        return loadFromExperience("ExperiencesListVC")as! ExperiencesListVC
    }
    static func loadAllCategoryVC() -> AllCategoryVC {
        return loadFromExperience("AllCategoryVC")as! AllCategoryVC
    }
    static func loadExperiencesBasedOnCategoryVC() -> ExperiencesBasedOnCategoryVC {
        return loadFromExperience("ExperiencesBasedOnCategoryVC")as! ExperiencesBasedOnCategoryVC
    }
    
    //ViewControllers of User Storyboard
    
    static func loadUTabBarVC() -> UTabBarVC {
        return loadFromUser("UTabBarVC")as! UTabBarVC
    }
    static func loadExperienceTabVC() -> ExperienceTabVC {
        return loadFromUser("ExperienceTabVC")as! ExperienceTabVC
    }
    static func loadUFavoriteVC() -> UFavoriteVC {
        return loadFromUser("UFavoriteVC")as! UFavoriteVC
    }
    static func loadUBlistBoardVC() -> UBlistBoardVC {
        return loadFromUser("UBlistBoardVC")as! UBlistBoardVC
    }
    static func loadUInboxVC() -> UInboxVC {
        return loadFromUser("UInboxVC")as! UInboxVC
    }
    
    static func loadUProfileVC() -> UProfileVC {
        return loadFromUser("UProfileVC")as! UProfileVC
    }
    static func loadUPersonalProfileVC() -> UPersonalProfileVC {
        return loadFromUser("UPersonalProfileVC")as! UPersonalProfileVC
    }
    static func loadUEditProfileVC() -> UEditProfileVC {
        return loadFromUser("UEditProfileVC")as! UEditProfileVC
    }
    static func loadUPaymentMethodsVC() -> UPaymentMethodsVC {
        return loadFromUser("UPaymentMethodsVC")as! UPaymentMethodsVC
    }
    static func loadFilterVC() -> FilterVC {
        return loadFromUser("FilterVC")as! FilterVC
    }
    static func loadFilterResultsVC() -> FilterResultsVC {
        return loadFromUser("FilterResultsVC")as! FilterResultsVC
    }
    static func loadChatVC() -> ChatVC {
        return loadFromUser("ChatVC")as! ChatVC
    }
    static func loadAllCategoriesListVC() -> AllCategoriesListVC {
        return loadFromUser("AllCategoriesListVC")as! AllCategoriesListVC
    }
    static func loadAddCommentVC() -> AddCommentVC {
        return loadFromUser("AddCommentVC")as! AddCommentVC
    }
    static func loadBBoardPostDetailVC() -> BBoardPostDetailVC {
        return loadFromUser("BBoardPostDetailVC")as! BBoardPostDetailVC
    }
    static func loadBookingDetailVC() -> BookingDetailVC {
        return loadFromUser("BookingDetailVC")as! BookingDetailVC
    }
    static func loadZoomImageVC() -> ZoomImageVC {
        return loadFromUser("ZoomImageVC")as! ZoomImageVC
    }
    static func loadCardCVV() -> CardCVV {
        return loadFromUser("CardCVV")as! CardCVV
    }
    static func loadFeaturesChooseOptionVC() -> FeaturesChooseOptionVC {
        return loadFromUser("FeaturesChooseOptionVC")as! FeaturesChooseOptionVC
    }
    static func loadUTransactionListVC() -> UTransactionListVC {
        return loadFromUser("UTransactionListVC")as! UTransactionListVC
    }
    static func loadUTransactionDetailVC() -> UTransactionDetailVC {
        return loadFromUser("UTransactionDetailVC")as! UTransactionDetailVC
    }
    static func loadUReviewsListVC() -> UReviewsListVC {
        return loadFromUser("UReviewsListVC")as! UReviewsListVC
    }
    static func loadUGiveRatingVC() -> UGiveRatingVC {
        return loadFromUser("UGiveRatingVC")as! UGiveRatingVC
    }
    static func loadGiveRatingVC() -> GiveRatingVC {
        return loadFromUser("GiveRatingVC")as! GiveRatingVC
    }
    static func loadUSendFeedbackVC() -> USendFeedbackVC {
        return loadFromUser("USendFeedbackVC")as! USendFeedbackVC
    }
    static func loadChooseOptionPopUp() -> ChooseOptionPopUp {
        return loadFromUser("ChooseOptionPopUp")as! ChooseOptionPopUp
    }
    
    //ViewControllers of Creator Storyboard
    static func loadPromoteVC() -> PromoteVC {
        return loadFromCreator("PromoteVC")as! PromoteVC
    }
    static func loadNewExperienceVC() -> NewExperienceVC {
        return loadFromCreator("NewExperienceVC")as! NewExperienceVC
    }
    static func loadAddNewExperienceVC() -> AddNewExperienceVC {
        return loadFromCreator("AddNewExperienceVC")as! AddNewExperienceVC
    }
    static func loadBookedUsersVC() -> BookedUsersVC {
        return loadFromCreator("BookedUsersVC")as! BookedUsersVC
    }
    static func loadBlockDatesVC() -> BlockDatesVC {
        return loadFromCreator("BlockDatesVC")as! BlockDatesVC
    }
}
