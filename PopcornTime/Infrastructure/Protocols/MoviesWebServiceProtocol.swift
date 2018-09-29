//
//  MoviesWebServiceProtocol.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

protocol MoviesWebServiceProtocol {
    static func getNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void))
    static func getNextNowPlaying(completion: @escaping ((Result<[Movie]>) -> Void))
    static func getSearch(keyWords: String, completion: @escaping ((Result<[Movie]>) -> Void))
    static func getNextSearch(completion: @escaping ((Result<[Movie]>) -> Void))
}
