//
//  Genre.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

// MARK: - Genres

struct Genres: Decodable {
    
    // MARK: - Decodable Properties
    
    let genres: [Genre]
    
    // MARK: - Private Properties
    
    private enum GenresKeyContainer: String, CodingKey {
        case genres
    }
    
    // MARK: - Object Lifecycle
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Genres.self, from: data)
    }
    
    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenresKeyContainer.self)
        genres = try container.decode([Genre].self, forKey: .genres)
    }
}

// MARK: - Genre

struct Genre: Decodable {
    
    // MARK: - Decodable Properties
    
    let id: Int
    let name: String
    
    // MARK: - Private Properties
    
    private enum GenreKeyContainer: String, CodingKey {
        case id
        case name
    }
        
    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenreKeyContainer.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
