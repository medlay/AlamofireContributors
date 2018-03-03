//
//  APIManager.swift
//  AlamofireContributors
//
//  Created by Vasyl Skrypij on 3/2/18.
//  Copyright © 2018 Vasyl Skrypij. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.DataRequest {
    public static func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            let emptyDataStatusCodes: Set<Int> = [204, 205]
            
            if let response = response, emptyDataStatusCodes.contains(response.statusCode) {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: validData)
                return .success(json)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
    
    @discardableResult
    public func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.decodableResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}


class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    func contributorsList(page : Int, completion : @escaping (Result<[User]>) -> Void) {
        Alamofire.request(RepositoryEndpoint.contributors(page: page))
            .responseDecodable(queue: nil) { (response: DataResponse<[User]>) in
                completion(response.result)
        }
    }
    
    func userInfo(login : String, completion : @escaping (Result<User>) -> Void) {
        Alamofire.request(UserInfoEndpoint.userInfo(login: login))
            .responseDecodable(queue: nil) { (response: DataResponse<User>) in
                completion(response.result)
        }
    }
}
