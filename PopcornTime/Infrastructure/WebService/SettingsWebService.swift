//
//  SettingsDataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

class SettingsWebService: SettingsWebSeviceProtocol {
    
    private(set) var webService: WebServiceProtocol

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func getSettings(completion: @escaping ((Result<(configuration: Configuration?, genres: [Genre]?)>) -> Void)) {
        let group = DispatchGroup()
        
        var configutation: Configuration?
        var genres: [Genre]?

        // webServiceRequest
        var webServiceRequest = WebServiceRequest(method: .get,
                                                  url: "/configuration",
                                                  headers: [ "Content-Type" : "application/json" ],
                                                  params: nil,
                                                  paramsEncoding: .json)
        group.enter()
        webService.call(webServiceRequest: webServiceRequest) { result in
            switch result {
            case .success(let data):
                #warning("Create parser!")
                configutation = try? Configuration(data: data)
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }

        // genres
        webServiceRequest = WebServiceRequest(method: .get,
                                              url: "/genre/movie/list",
                                              headers: [
                                                "Content-Type" : "application/json"
            ],
                                              params: nil,
                                              paramsEncoding: .json)
        group.enter()
        webService.call(webServiceRequest: webServiceRequest) { result in
            switch result {
            case .success(let data):
                #warning("Create parser!")
                genres = try? Genres(data: data).genres
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(.success(value: (configutation, genres)))
        }
    }

}
