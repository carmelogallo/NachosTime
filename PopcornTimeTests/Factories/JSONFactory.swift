//
//  JSONFactory.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation
@testable import PopcornTime

class JSONFactory {

    static func dataFromFile(filename: String, type: String) -> Data? {
        guard let path = Bundle(for: self).path(forResource: filename, ofType: type) else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    static func makeWrongDataResponse<T>() -> T? where T: ModelsProtocol {
        guard let data = dataFromFile(filename: "wrong_response", type: "json") else {
            return nil
        }
        
        return try? T(data: data)
    }

    static func makeCorrectConfigurationResponse() -> Configuration? {
        guard let data = dataFromFile(filename: "configuration_succeful", type: "json") else {
            return nil
        }
        
        return try? Configuration(data: data)
    }
    
    static func makeCorrectGenresResponse() -> Genres? {
        guard let data = dataFromFile(filename: "genres_succeful", type: "json") else {
            return nil
        }
        
        return try? Genres(data: data)
    }
    
    static func makeCorrectMoviesResponse() -> Movies? {
        guard let data = dataFromFile(filename: "movies_succeful", type: "json") else {
            return nil
        }
        
        return try? Movies(data: data)
    }
        
}
