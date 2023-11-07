//
//  UserModel.swift
//  BList
//
//  Created by iOS Team on 04/07/22.
//

import Foundation

// MARK: - UserModel
struct UserModel: APIModel {
    var success: Int?
    var error: Bool?
    var httpStatus: Int?
    var message: String?
    var data: User?
    
    enum CodingKeys: String, CodingKey {
        case httpStatus = "http_status"
        case message, data, success, error
    }
}


// MARK: - User
struct User: Codable {
    var id, firstName, lastName, email: String?
    var chatToken, phonecode, phone, password: String?
    var dob, gender, bio, facebookURL: String?
    var twitterURL, instagramURL, linkedinURL, websiteURL: String?
    var profileImg, identityType, identityDocument, identityVerified: String?
    var userIdentityDocument, userIdentityVerified, creatorBusinessIdentity, businessIdentityVeriied: String?
    var businessImages, role, creatorType, otp: String?
    var otpVerify, status,  device_name, deviceToken, token: String?
    var socialID, socialType, commission, isNotification: String?
    var createdAt, deletedAt, coverPic: String?
    let autoCheckin, manualCheckin, autoTrack: String?
    var emergency_phone, emergency_name, emergency_email, user_list: String?
    var emergency: String?
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case chatToken = "chat_token"
        case email, phone, password, dob, gender, bio
        case facebookURL = "facebook_url"
        case twitterURL = "twitter_url"
        case instagramURL = "instagram_url"
        case linkedinURL = "linkedin_url"
        case websiteURL = "website_url"
        case profileImg = "profile_img"
        case identityType = "identity_type"
        case identityDocument = "identity_document"
        case identityVerified = "identity_verified"
        case userIdentityDocument = "user_identity_document"
        case userIdentityVerified = "user_identity_verified"
        case creatorBusinessIdentity = "creator_business_identity"
        case businessIdentityVeriied = "business_identity_veriied"
        case businessImages = "business_images"
        case role, emergency
        case creatorType = "creator_type"
        case otp, emergency_phone, emergency_name, emergency_email, user_list
        case otpVerify = "otp_verify"
        case status, phonecode, device_name
        case deviceToken = "device_token"
        case commission
        case isNotification = "is_notification"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case socialID = "social_id"
        case socialType = "social_type"
        case token
        case coverPic = "cover_img"
        case autoCheckin = "auto_checkin"
        case manualCheckin = "manual_checkin"
        case autoTrack = "auto_track"
    }
}


struct CommonApiModel: APIModel {
    var success: Int?
    var error: Bool?
    var httpStatus: Int?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case httpStatus = "http_status"
        case message, success, error
    }
}


