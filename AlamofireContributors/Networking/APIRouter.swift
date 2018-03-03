//
//  APIRouter.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/2/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension APIConfiguration {
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.GitHubServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

enum RepositoryEndpoint: APIConfiguration {
    
    case contributors(page: Int)
 
    internal var method: HTTPMethod {
        switch self {
        case .contributors:
            return .get
        }
    }
    
    internal var path: String {
        switch self {
        case .contributors:
            return "repos/Alamofire/Alamofire/contributors"
        }
    }
    
    internal var parameters: Parameters? {
        switch self {
        case .contributors(let page):
            return [Constants.APIParameterKey.page : page]
        }
    }
    
}

enum UserInfoEndpoint: APIConfiguration {
    
    case userInfo(login: String)
    
    internal var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        }
    }
    
    internal var path: String {
        switch self {
        case .userInfo(let login):
            return "users/\(login)"
        }
    }
    
    internal var parameters: Parameters? {
        switch self {
        case .userInfo:
            return nil
        }
    }
    
}
