//
//  MoviesDataSource.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

struct MoviesDataSource: MoviesDataSourceProtocol, MoviesWebServiceProtocol {
    
    // MARK: - MoviesDataSourceProtocol
    
    static private(set) var nowPlayingMovies: Movies?
    static private(set) var searchMovies: Movies?
    
    // MARK: - Private Properties

    private enum MoviesWebServiceError: Error {
        case addingPercentEncodingFailed
    }
    static private(set) var searchMoviesKeyWords: String?
    
    // MARK: - MoviesWebServiceProtocol

    static func getNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void)) {
        // page
        var page = 1
        if let currentPage = nowPlayingMovies?.page {
            page = currentPage + 1
        }
        
        // webServiceConfiguration
        let webServiceConfiguration = WebServiceConfiguration(method: .get,
                                                              url: "/movie/now_playing?page=\(page)",
                                                              headers: [ "Content-Type" : "application/json" ],
                                                              params: nil,
                                                              paramsEncoding: .json)
        
        // call
        WebService.call(configuration: webServiceConfiguration) { result in
            switch result {
            case .success(let data):
                guard let movies = try? Movies(data: data) else {
                    completion(.success(value: [Movie]()))
                    return
                }

                MoviesDataSource.nowPlayingMovies = movies
                completion(.success(value: movies.movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }

    static func getNextNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void)) {
        getNowPlaying(completion: completion)
    }
    
    static func getSearch(keyWords: String, completion: @escaping ((Result<[Movie]>) -> Void)) {
        // searchMoviesKeyWords
        guard let searchMoviesKeyWords = keyWords.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(.failure(error: MoviesWebServiceError.addingPercentEncodingFailed))
            return
        }
        self.searchMoviesKeyWords = searchMoviesKeyWords
        
        // page
        var page = 1
        if let currentPage = searchMovies?.page {
            page = currentPage + 1
        }
        
        // webServiceConfiguration
        let webServiceConfiguration = WebServiceConfiguration(method: .get,
                                                              url: "/search/movie?page=\(page)&query=\(searchMoviesKeyWords)",
            headers: [ "Content-Type" : "application/json" ],
            params: nil,
            paramsEncoding: .json)

        // call
        WebService.call(configuration: webServiceConfiguration) { result in
            switch result {
            case .success(let data):
                guard let movies = try? Movies(data: data) else {
                    completion(.success(value: [Movie]()))
                    return
                }
                
                MoviesDataSource.searchMovies = movies
                completion(.success(value: movies.movies))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    static func getNextSearch(completion: @escaping ((Result<[Movie]>) -> Void)) {
        getSearch(keyWords: searchMoviesKeyWords ?? " ", completion: completion)
    }
}
