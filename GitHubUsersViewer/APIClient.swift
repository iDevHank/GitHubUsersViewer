//
//  GitHubAPIClient.swift
//  GitHubUsersViewer
//
//  Created by Hank on 14/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum APIClientError {
    case network
    case server
    case unknown
}

private struct APIClientConstants {
    static let baseURL = "https://api.github.com/users"
    static let perPage = 20
    static let initialSince = 135
}

struct APIClient {

    fileprivate static func requestJSON(with url: String,
                                        method: Alamofire.HTTPMethod,
                                        parameters: [String: Any]?,
                                        success: @escaping (JSON) -> Void,
                                        failure: @escaping (APIClientError) -> Void) -> Alamofire.DataRequest {
        return Alamofire.request(URL(string: url)!, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard json != JSON.null else {
                        failure(APIClientError.server)
                        return
                    }
                    success(json)
                case .failure(_):
                    failure(APIClientError.network)
                }
        }
    }

}

extension APIClient {

    @discardableResult
    static func getUsers(since: String?,
                         success: @escaping (JSON) -> Void,
                         failure: @escaping (APIClientError) -> Void) -> Alamofire.DataRequest {
        let validSince = since ?? APIClientConstants.initialSince.description
        return requestJSON(with: APIClientConstants.baseURL,
                           method: .get,
                           parameters: ["per_page": APIClientConstants.perPage.description,
                                        "since": validSince],
                           success: { value in
                            success(value)
        },
                           failure: { error in
                            failure(error)
        })
    }

}

extension APIClient {

    @discardableResult
    static func getUserDetails(userName: String,
                               success: @escaping (JSON) -> Void,
                               failure: @escaping (APIClientError) -> Void) -> Alamofire.DataRequest {
        let url = APIClientConstants.baseURL + "/" + userName
        return requestJSON(with: url,
                           method: .get,
                           parameters: nil,
                           success: { value in
                            success(value)
        },
                           failure: { error in
                            failure(error)
        })
    }

}
