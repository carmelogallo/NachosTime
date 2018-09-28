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
    
    static func makeWrongDataResponse() -> Data? {
        guard let data = dataFromFile(filename: "wrong_response", type: "json") else {
            return nil
        }
        
        return data
    }

    static func makeCorrectConfigurationResponse() -> Configuration? {
        guard let data = dataFromFile(filename: "configuration_succeful", type: "json") else {
            return nil
        }
        
        return try? Configuration(data: data)
    }
    
    static func makeWrongConfigurationResponse() -> Configuration? {
        guard let data = makeWrongDataResponse() else {
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
    
    static func makeWrongGenresResponse() -> Genres? {
        guard let data = makeWrongDataResponse() else {
            return nil
        }
        
        return try? Genres(data: data)
    }
    
}
