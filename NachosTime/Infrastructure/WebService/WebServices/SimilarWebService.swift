//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

class SimilarWebService: SimilarWebServiceProtocol {

    // MARK: - Private properties

    private let webService: WebServiceProtocol

    // MARK: - Object lifecycle

    required init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    // MARK: - Protocol methods

    func get(of movieId: Int, at page: Int, completion: @escaping ((Result<Movies>) -> Void)) {
        let request = WebServiceRequest(
                method: .get,
                path: (url: Manager.config.apiUrl + "/movie/\(movieId)/similar", 
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
