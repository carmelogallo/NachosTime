//
//  SearchWebService.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

class SearchWebService: SearchWebServiceProtocol {
    
    // MARK: - Private Properties

    private enum SearchWebServiceError: Error {
        case addingPercentEncodingFailed
    }
    private(set) var query: String?
    
    // MARK: - NowPlayingWebServiceProtocol

    private(set) var webService: WebServiceProtocol
    
    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
    func get(at page:Int, keyWords: String, completion: @escaping ((Result<[Movie]>) -> Void)) {
        // query
        guard let query = keyWords.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(.failure(error: SearchWebServiceError.addingPercentEncodingFailed))
            return
        }
        self.query = query
        
        // webServiceRequest
        let webServiceRequest = WebServiceRequest(method: .get,
                                                  url: "/search/movie?page=\(page)&query=\(query)",
                                                  headers: [ "Content-Type" : "application/json" ],
                                                  params: nil,
                                                  paramsEncoding: .json)
        
        // call
        webService.call(webServiceRequest: webServiceRequest) { result in
            switch result {
            case .success(let data):
                #warning("Create parser!")
                guard let movies = try? Movies(data: data) else {
                    completion(.success(value: [Movie]()))
                    return
                }

                completion(.success(value: movies.movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
}
