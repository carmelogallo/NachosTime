//
//  NowPlayingWebService.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

class NowPlayingWebService: NowPlayingWebServiceProtocol {
    
    // MARK: - Private Properties
    
    private enum NowPlayingWebServiceError: Error {
        case parsingMoviesFailed
    }

    // MARK: - NowPlayingWebServiceProtocol

    private(set) var webService: WebServiceProtocol
    
    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func get(at page: Int, completion: @escaping ((Result<Movies>) -> Void)) {
        // webServiceRequest
        let webServiceRequest = WebServiceRequest(method: .get,
                                                  url: "/movie/now_playing?page=\(page)",
                                                  headers: [ "Content-Type" : "application/json" ],
                                                  params: nil,
                                                  paramsEncoding: .json)
        
        // call
        webService.call(webServiceRequest: webServiceRequest) { result in
            switch result {
            case .success(let data):
                guard let movies = MoviesParser.parse(data: data) else {
                    completion(.failure(error: NowPlayingWebServiceError.parsingMoviesFailed))
                    return
                }
                
                completion(.success(value: movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }

}
