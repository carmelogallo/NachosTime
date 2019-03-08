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

    private let webService: WebServiceProtocol

    // MARK: - Object lifecycle

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
    func get(at page:Int, keyWords: String, completion: @escaping ((Result<[Movie]>) -> Void)) {
        // query
        guard let query = keyWords.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(.failure(error: SearchWebServiceError.addingPercentEncodingFailed))
            return
        }

        let request = WebServiceRequest(
                method: .get,
                path: (url: Manager.config.apiURL + "/search/movie",
                       query: ["api_key" : Manager.config.apiKey, "page" : "\(page)", "query" : "\(query)"]),
                headers: ["Content-Type" : "application/json"]
        )
        webService.send(request: request, parser: MoviesParser.parse) { result in
            switch result {
            case .success(let movies):
                completion(.success(value: movies.movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }

    }
}
