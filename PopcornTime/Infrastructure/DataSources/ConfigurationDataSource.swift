//
//  ConfigurationDataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

protocol ConfigurationWebSeviceProtocol {
    
    static var configutation: Configuration! { get }
    
    static func getConfiguration(completion: @escaping ((Result<Bool>) -> Void))
}

class ConfigurationDataSource: ConfigurationWebSeviceProtocol {

    static var configutation: Configuration!
    
    static func getConfiguration(completion: @escaping ((Result<Bool>) -> Void)) {
        let webService = WebService(method: .get,
                                              url: "/configuration",
                                              headers: [
                                                "Content-Type" : "application/json"
                                              ],
                                              params: nil,
                                              paramsEncoding: .json)
        WebServiceManager.call(webService: webService) { result in
            switch result {
            case .success(let data):
                configutation = try? Configuration(data: data)
                completion(.success(value: true))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }

}
