//
//  JSONFactory.swift
//  NachosTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation
@testable import NachosTime

class JSONFactory {

    static func dataFromFile(filename: String, type: String) -> Data? {
        guard let path = Bundle(for: self).path(forResource: filename, ofType: type) else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    static func makeWrongDataResponse<T>() -> T? where T: Decodable {
        guard let data = dataFromFile(filename: "wrong_response", type: "json") else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }

    static func makeCorrectConfigurationResponse() -> Configuration? {
        guard let data = dataFromFile(filename: "configuration_successful", type: "json") else {
            return nil
        }
        
        return try? JSONDecoder().decode(Configuration.self, from: data)
    }
    
    static func makeCorrectConfigurationWithMissingDataResponse() -> Configuration? {
        guard let data = dataFromFile(filename: "configuration_successful_with_missing_data", type: "json") else {
            return nil
        }

        return try? JSONDecoder().decode(Configuration.self, from: data)
    }
    
    static func makeCorrectGenresResponse() -> Genres? {
        guard let data = dataFromFile(filename: "genres_successful", type: "json") else {
            return nil
        }
        
        return try? JSONDecoder().decode(Genres.self, from: data)
    }
    
    static func makeCorrectMoviesResponse() -> Movies? {
        guard let data = dataFromFile(filename: "movies_successful", type: "json") else {
            return nil
        }
        
        return try? JSONDecoder().decode(Movies.self, from: data)
    }
        
}
