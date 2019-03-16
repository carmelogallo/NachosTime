//
//  SettingsDataSource.swift
//  NachosTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

class SettingsWebService: SettingsWebServiceProtocol {

    // MARK: - Private properties

    private let webService: WebServiceProtocol

    // MARK: - Object lifecycle

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func get(completion: @escaping ((Result<(configuration: Configuration?, genres: [Genre]?)>) -> Void)) {
        let group = DispatchGroup()
        
        var configuration: Configuration?
        var genres: [Genre]?

        // webServiceRequest
        var request = WebServiceRequest(
                method: .get,
                path: (url: Manager.config.apiUrl + "/configuration", query: ["api_key" : Manager.config.apiKey]),
                headers: ["Content-Type" : "application/json"]
        )
        group.enter()
        webService.send(request: request, parser: ConfigurationParser.parse) { result in
            switch result {
            case .success(let configurationResponse):
                configuration = configurationResponse
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }

        // genres
        request = WebServiceRequest(
                method: .get,
                path: (url: Manager.config.apiUrl + "/genre/movie/list", query: ["api_key" : Manager.config.apiKey]),
                headers: ["Content-Type" : "application/json"]
        )
        group.enter()
        webService.send(request: request, parser: GenresParser.parse) { result in
            switch result {
            case .success(let genresResponse):
                genres = genresResponse.genres
            case .failure(let error):
                completion(.failure(error: error))
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            completion(.success(value: (configuration, genres)))
        }
    }

}
