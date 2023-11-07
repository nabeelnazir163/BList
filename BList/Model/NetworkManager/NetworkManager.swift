//
//  NetworkManager.swift
//  GunInstructor
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

protocol APIModel : Codable {
    var httpStatus: Int? { get }
    var message: String? { get }
    var success: Int? { get }
    var error: Bool? { get }
}
enum NetworkResponse :String {
    case success
    case serverError         = "Server error."
    case badRequest          = "Bad Request"
    case outdated            = "The url you requested is outdated."
    case failed              = "Network request failed."
    case noData              = "Response returned with no data to decode."
    case unableToDecode      = "we couldn't decode the response"
}
enum APIResult<String>{
    case success
    case failure(String)
}
enum APIError :Error{
    case errorReport(desc:String, response: Int = 0)
}
struct NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    static let environment :NetworkEnvironment = .development
    static let contentType         = "application/x-www-form-urlencoded"
    //"multipart/form-data"
    //    static let termOfUserURL       = BaseURLs.TermOfUse.rawValue
    static let privacyURL          = BaseURLs.Privacy.rawValue
    let router = Router<APIEndPoint>()
    
    fileprivate func handleNetworkResponse(_ response : HTTPURLResponse, forData data : Data)->
    APIResult<String>{
        switch response.statusCode{
        case 200...299, 400, 401 : return.success
        case 402...500 :
            print(response)
            return.failure(NetworkResponse.serverError.rawValue)
        case 501...599 :
            print(response)
            return.failure(NetworkResponse.badRequest.rawValue)
        case 600       : return.failure(NetworkResponse.outdated.rawValue)
        default        : return.failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func handleAPICalling<T:APIModel>(request:APIEndPoint,completion: @escaping ((Result<T,APIError>) -> Void)){
        router.request(request) { (data, response, error) in
            if error != nil {
                completion(.failure(.errorReport(desc: "Please check your network connection.")))
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response,forData:data ?? Data())
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                        return
                    }
                    let str = String.init(data: responseData, encoding: .utf8)
                    print(str!)
                    do {
                        let result = try JSONDecoder().decode(T.self, from: responseData)
                        if (result.success ?? 0) == 1 {
                            completion(.success(result))
                        } else if (result.httpStatus ?? 0) == 401{
                            DispatchQueue.main.async {
                                AppSettings.Token =  ""
                                AppSettings.UserInfo = nil
                                
                                let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
                                let navVC = window?.rootViewController as? UINavigationController
                                let vc = UIStoryboard.loadUnAuthorizedVC()
                                vc.screenType = AppSettings.UserInfo == nil ? .notLoggedIn : .unauthorized
                                vc.modalTransitionStyle = .crossDissolve
                                vc.modalPresentationStyle = .custom
                                navVC?.viewControllers.first?.present(vc, animated: true)
                            }
                            completion(.failure(.errorReport(desc: result.message ?? "", response: result.httpStatus ?? 0)))
                        }
                        else {
                            completion(.failure(.errorReport(desc: result.message ?? "", response: result.httpStatus ?? 0)))
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        print(error)
                        completion(.failure(.errorReport(desc: "Data Not Found")))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(.errorReport(desc: networkFailureError)))
                }
            }
        }
    }
    
    func handleMultipartProgress(completion: @escaping ((Double) -> Void)){
        router.observeProgress(completion: completion)
    }
}
