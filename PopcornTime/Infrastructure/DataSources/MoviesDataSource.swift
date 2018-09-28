//
//  MoviesDataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

struct MoviesDataSource: MoviesDataSourceProtocol, MoviesWebServiceProtocol {
    
    // MARK: - MoviesDataSourceProtocol
    
    static private(set) var movies: Movies?
    
    // MARK: - MoviesWebServiceProtocol

    static func getNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void)) {
        var page = 1
        if let currentPage = movies?.page {
            page = currentPage + 1
        }
        let webServiceConfiguration = WebServiceConfiguration(method: .get,
                                                              url: "/movie/now_playing?page=\(page)",
                                                              headers: [ "Content-Type" : "application/json" ],
                                                              params: nil,
                                                              paramsEncoding: .json)
        WebService.call(configuration: webServiceConfiguration) { result in
            switch result {
            case .success(let data):
                guard let movies = try? Movies(data: data) else {
                    completion(.success(value: [Movie]()))
                    return
                }

                MoviesDataSource.movies = movies
                completion(.success(value: movies.movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }

    static func getNextNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void)) {
        getNowPlaying(completion: completion)
    }
}
