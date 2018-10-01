//
//  SettingsDataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

struct SettingsDataSource: SettingsDataSourceProtocol, SettingsWebSeviceProtocol {

    // MARK: - SettingsDataSourceProtocol

    static private(set) var configutation: Configuration!
    static private(set) var genres: [Genre]!

    // MARK: - SettingsWebSeviceProtocol

    static func getSettings(completion: @escaping ((Result<Bool>) -> Void)) {
        let group = DispatchGroup()
        
        // configuration
        var webServiceConfiguration = WebServiceRequest(method: .get,
                                                              url: "/configuration",
                                                              headers: [ "Content-Type" : "application/json" ],
                                                              params: nil,
                                                              paramsEncoding: .json)
        group.enter()
        WebService.call(configuration: webServiceConfiguration) { result in
            switch result {
            case .success(let data):
                configutation = try? Configuration(data: data)
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }

        // genres
        webServiceConfiguration = WebServiceRequest(method: .get,
                                                          url: "/genre/movie/list",
                                                          headers: [
                                                            "Content-Type" : "application/json"
            ],
                                                          params: nil,
                                                          paramsEncoding: .json)
        group.enter()
        WebService.call(configuration: webServiceConfiguration) { result in
            switch result {
            case .success(let data):
                genres = try? Genres(data: data).genres
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(.success(value: true))
        }
    }

}
