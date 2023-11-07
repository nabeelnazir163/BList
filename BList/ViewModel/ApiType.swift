//
//  ApiType.swift
//  BList
//
//  Created by iOS Team on 04/07/22.
//

import Foundation


enum SignUpType : String {
    case Email = "email"
    case Facebook = "facebook"
    case Gmail = "google"
    case Instagram = "instagram"
    case AppleID = "apple"
}

enum ApiType {
    case None
    case RemoveBackgroundImage
    // COMMON ENDPOINTs
    case SignIn(type: SignUpType)
    case SignUp(type: SignUpType, userType: UserType)
    case Forget
    case Otp
    case SocialLogin(type: SignUpType)
    case UploadDocument
    case Categories
    case LogOut
    case UpdateProfile
    case TransactionDetails
    
    // Authentication
    case getReviews
    case GiveRating
    case ShareFeedback
    case AddCoverPic
    case GetProfileDetails
    
    // Creator
    case SelectKindOfExperience
    case CreateExperience
    case DescribeExperience
    case ChooseLanguage
    case CreateExperienceWithDateAndTime
    case kindOfExperience
    case ItemDetail
    case PostExperience
    case UpdateExperience
    case SwitchToUserProfile
    case SwitchToCreatorProfile
    case AddCreatorCommission
    case CreatorHome
    case CreatorsList
    case SearchCreator
    case Policy
    case SearchWishlists
    
    // User
    case UserHome
    case GetBookingList
    case ExperienceDetails
    case GetBookingDetails
    case ChooseAvailableDate
    case ChooseMember
    case BookExperience
    case AddBooking
    case GetCardsList
    case AddCard
    case FavouriteExperiencesList
    case MakeFavourite
    case MakeUnFavourite
    case DeleteExperience
    case PromoteExperience
    case SearchExperience
    case Filter
    case OtherFilter
    case PostContent
    case SearchComments
    case GetComments
    case GPSCheck
    case PostComment
    case getPostComments
    case LikeComment
    case DisLikeComment
    case ReplyComment
    case NewCreatedExperiences
    case TopExperiences
    case BlistFeatureList
    case GetAnalytics
    case GetUsers
    case SearchUsers
    case RateExperienceQualities
    case GetExperiencesBasedOnDate
    case updateBlockDates
    case cancelBooking
    // Common
    case getNotifications
    
    // Socket
    case GetChatMessages
    case AcceptOrRejectBooking
    case SendImage
}

