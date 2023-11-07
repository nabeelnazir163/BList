//
//  InstagramResponse.swift
//  Crowdify App
//
//  Created by apple on 26/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

struct InstagramTestUser: Codable {
  var access_token: String
  var user_id: Int
}
struct InstagramUser: Codable {
  var id: String
  var username: String
}
struct Feed: Codable {
  var data: [MediaData]
  var paging: PagingData
}
struct MediaData: Codable {
  var id: String
  var caption: String?
}
struct PagingData: Codable {
  var cursors: CursorData
  var next: String
}
struct CursorData: Codable {
  var before: String
  var after: String
}
struct InstagramMedia: Codable {
  var id: String
  var media_type: MediaType
  var media_url: String
  var username: String
  var timestamp: String
}
enum MediaType: String, Codable {
  case IMAGE
  case VIDEO
  case CAROUSEL_ALBUM
}


// MARK: - InstaDetailModel
struct InstaDetailModel: Codable {
    let loggingPageID: String?
    let showSuggestedProfiles, showFollowDialog: Bool?
    let graphql: Graphql?
    let showViewShop: Bool?

    enum CodingKeys: String, CodingKey {
        case loggingPageID = "logging_page_id"
        case showSuggestedProfiles = "show_suggested_profiles"
        case showFollowDialog = "show_follow_dialog"
        case graphql
        case showViewShop = "show_view_shop"
    }
    
    // MARK: - Graphql
    struct Graphql: Codable {
        let user: User
    }
    
    // MARK: - User
    struct User: Codable {
        let biography: String?
        let businessEmail : String?
        let countryBlock: Bool?
        let edgeFollow: EdgeFollow?
        let fullName: String?
        let id: String?
        let isBusinessAccount, isJoinedRecently: Bool?
        let businessCategoryName, overallCategoryName : String?
        let isPrivate, isVerified: Bool?
        let profilePicURL, profilePicURLHD: String?
        let username: String?
        
        enum CodingKeys: String, CodingKey {
            case biography
            case businessEmail = "business_email"
            case countryBlock = "country_block"
            case edgeFollow = "edge_follow"
            case fullName = "full_name"
            case id
            case isBusinessAccount = "is_business_account"
            case isJoinedRecently = "is_joined_recently"
            case businessCategoryName = "business_category_name"
            case overallCategoryName = "overall_category_name"
            case isPrivate = "is_private"
            case isVerified = "is_verified"
            case profilePicURL = "profile_pic_url"
            case profilePicURLHD = "profile_pic_url_hd"
            case username
          
        }
    }

    // MARK: - Edge
    struct Edge: Codable {
        let count: Int?
        let pageInfo: PageInfo?

        enum CodingKeys: String, CodingKey {
            case count
            case pageInfo = "page_info"
        }
    }

    // MARK: - PageInfo
    struct PageInfo: Codable {
        let hasNextPage: Bool?

        enum CodingKeys: String, CodingKey {
            case hasNextPage = "has_next_page"
        }
    }

    // MARK: - EdgeFollow
    struct EdgeFollow: Codable {
        let count: Int
    }
}
