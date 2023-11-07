//
//  InstagramAPI.swift
//  Crowdify App
//
//  Created by apple on 26/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
class InstagramApi {
    static let shared = InstagramApi()
    private let instagramAppID = "731670861275078"
    private let redirectURIURLEncoded = "https://www.paraspro.com/index.php/signin" //"https://www.crowdify.app/instagram/oauth"
    private let redirectURI = "https://www.paraspro.com/index.php/signin"
    private let app_secret = "66dd8c67f75db66b384b155bd0c28ffd"
    private let boundary = "Boundary-\(UUID().uuidString)"
    var url = "https://api.instagram.com/oauth/authorize"
    private init () {}
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
        let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\("731670861275078")&redirect_uri=\(redirectURIURLEncoded)&scope=user_profile,user_media&response_type=code"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
    }
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        if request.url?.query?.starts(with: "code=") ?? false {
            return request.url?.query?.replacingOccurrences(of: "code=", with: "")
        }
        return nil
    }
    private func getFormBody(_ parameters: [[String : Any]], _ boundary: String) -> Data {
        do {
            var body = ""
            for param in parameters {
                if param["disabled"] == nil {
                    let paramName = param["key"]!
                    body += "--\(boundary)\r\n"
                    body += "Content-Disposition:form-data; name=\"\(paramName)\""
                    let paramType = param["type"] as! String
                    if paramType == "text" {
                        let paramValue = param["value"] as! String
                        body += "\r\n\r\n\(paramValue)\r\n"
                    } else {
                        let paramSrc = param["src"] as! String
                        let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
                        let fileContent = String(data: fileData, encoding: .utf8)!
                        body += "; filename=\"\(paramSrc)\"\r\n"
                            + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                    }
                }
            }
            body += "--\(boundary)--\r\n";
            return body.data(using: .utf8) ?? Data()
        }
        catch {
            print(error)
            return Data()
        }
    }
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramUser) -> Void) {
        guard let authToken = getTokenFromCallbackURL(request: request) else {
            return
        }
        let parameters = [
            [
                "key": "client_id",
                "value": instagramAppID,
                "type": "text"
            ],
            [
                "key": "client_secret",
                "value": app_secret,
                "type": "text"
            ],
            [
                "key": "grant_type",
                "value": "authorization_code",
                "type": "text"
            ],
            [
                "key": "code",
                "value": authToken,
                "type": "text"
            ],
            [
                "key": "redirect_uri",
                "value": redirectURIURLEncoded,
                "type": "text"
            ]] as [[String : Any]]
        var request = URLRequest(url: URL(string: BaseURL.displayApi.rawValue + Method.access_token.rawValue)!)
        let postData = getFormBody(parameters, boundary)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                do {
                    let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
//                    UserData.InstaAccessToken = jsonData.access_token
//                    UserData.AccessUser_ID = jsonData.user_id
                    
                    self.getInstagramUser(testUserData: jsonData) { user in
                        
                        self.getDetailsOfUSer(userName: user?.username ?? "") { instaDetailModel in
                            print(instaDetailModel?.graphql?.user.businessEmail)
                            print(instaDetailModel?.graphql?.user.fullName)
                        }
                        
                        completion(user!)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    func getInstagramUser(testUserData: InstagramTestUser, completion: @escaping (InstagramUser?) -> Void) {
        let urlString = "\(BaseURL.graphApi.rawValue)\(testUserData.user_id)?fields=id,username,email&access_token=\(testUserData.access_token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
                completion(nil)
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                print(jsonData)
//                UserData.user_Name = jsonData.username
                completion(jsonData)
            } catch let error as NSError {
                print(error)
                completion(nil)
            }
        })
        dataTask.resume()
    }
    func getDetailsOfUSer(userName:String,completion: @escaping (InstaDetailModel?) -> ()){
        let urlString = "https://www.instagram.com/\(userName)/?__a=1"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
                completion(nil)
                return
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                do {
                    let jsonData = try JSONDecoder().decode(InstaDetailModel.self, from: data!)
                    print(jsonData)
//                    UserData.InstaProfile = jsonData.graphql.user.profilePicURL ?? ""
                    completion(jsonData)
                } catch let error {
                    print(error)
                    completion(nil)
                }

            }
        })
        dataTask.resume()
    }
}
private enum BaseURL: String {
    case displayApi = "https://api.instagram.com/"
    case graphApi = "https://graph.instagram.com/"
}
private enum Method: String {
    case authorize = "oauth/authorize"
    case access_token = "oauth/access_token"
}
