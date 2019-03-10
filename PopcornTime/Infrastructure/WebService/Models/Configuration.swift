//
//  Configuration.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

// MARK: - Configuration

struct Configuration: Decodable {
    
    // MARK: - Decodable Properties
    
    let images: Images
    let changeKeys: [String]

    // MARK: - Private Properties
    
    private enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }

    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        images = try container.decode(Images.self, forKey: .images)
        changeKeys = try container.decode([String].self, forKey: .changeKeys)
    }
}

// MARK: - Images

struct Images: Decodable {

    // MARK: - Decodable Properties
    
    let baseUrl: String
    let secureBaseUrl: String

    enum BackdropSize: String, Decodable {
        case w300
        case w780
        case w1280
        case original
    }
    let backdropSizesFromServer: [String]
    
    enum LogoSizes: String, Decodable {
        case w45
        case w92
        case w154
        case w185
        case w300
        case w500
        case original
    }
    let logoSizes: [LogoSizes]
    
    enum PosterSize: String, Decodable {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
        case original
    }
    private let posterSizesFromServer: [String]
    
    enum ProfileSize: String, Decodable {
        case w45
        case w185
        case h632
        case original
    }
    let profileSizes: [ProfileSize]
    
    enum StillSize: String, Decodable {
        case w92
        case w185
        case w300
        case original
    }
    let stillSizes: [StillSize]
    
    // MARK: - Private Properties
    
    private enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }

    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseUrl = try container.decode(String.self, forKey: .baseUrl)
        secureBaseUrl = try container.decode(String.self, forKey: .secureBaseUrl)
        backdropSizesFromServer = try container.decode([String].self, forKey: .backdropSizes)
        logoSizes = try container.decode([LogoSizes].self, forKey: .logoSizes)
        posterSizesFromServer = try container.decode([String].self, forKey: .posterSizes)
        profileSizes = try container.decode([ProfileSize].self, forKey: .profileSizes)
        stillSizes = try container.decode([StillSize].self, forKey: .stillSizes)
    }

    // MARK: Configuration Factory

    func posterSizeValue(_ posterSize: PosterSize) -> String? {
        guard posterSizesFromServer.contains(posterSize.rawValue) else {
            return nil
        }
        
        return posterSize.rawValue
    }

    func backdropSizeValue(_ backdropSize: BackdropSize) -> String? {
        guard backdropSizesFromServer.contains(backdropSize.rawValue) else {
            return nil
        }
        
        return backdropSize.rawValue
    }
    
}
