//
//  NowPlayingWebService.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

class NowPlayingWebService: NowPlayingWebServiceProtocol {

    // MARK: - Private properties

    private let webService: WebServiceProtocol
    
    // MARK: - Object lifecycle
    
    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    // MARK: - Protocol methods
    
    func get(at page: Int, completion: @escaping ((Result<Movies>) -> Void)) {
        let request = WebServiceRequest(
                method: .get,
                path: (url: Manager.config.apiUrl + "/movie/now_playing",
                       query: ["api_key" : Manager.config.apiKey, "page" : "\(page)"]),
                headers: ["Content-Type" : "application/json"]
        )
        webService.send(request: request, parser: MoviesParser.parse) { result in
            switch result {
            case .success(let movies):
                completion(.success(value: movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }

}
