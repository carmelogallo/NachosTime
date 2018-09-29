//
//  Configuration.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

// MARK: - Configuration

struct Configuration: ModelsProtocol {
    
    // MARK: - Decodable Properties
    
    let images: Images
    let changeKeys: [String]

    // MARK: - Private Properties
    
    private enum ConfigurationKeyContainer: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }

    // MARK: - Object Lifecycle

    init(data: Data) throws {
        self = try JSONDecoder().decode(Configuration.self, from: data)
    }
    
    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigurationKeyContainer.self)
        images = try container.decode(Images.self, forKey: .images)
        changeKeys = try container.decode([String].self, forKey: .changeKeys)
    }
}

// MARK: - Images

struct Images: Decodable {

    // MARK: - Decodable Properties
    
    let baseUrl: String
    let secureBaseUrl: String

    enum BackdropSizes: String, Decodable {
        case w300
        case w780
        case w1280
        case original
    }
    let backdropSizes: [BackdropSizes]
    
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
    
    enum PosterSizes: String, Decodable {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
        case original
    }
    let posterSizes: [PosterSizes]
    
    enum ProfilePizes: String, Decodable {
        case w45
        case w185
        case h632
        case original
    }
    let profilePizes: [ProfilePizes]
    
    enum StillSizes: String, Decodable {
        case w92
        case w185
        case w300
        case original
    }
    let stillSizes: [StillSizes]
    
    // MARK: - Private Properties
    
    private enum ImagesKeyContainer: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profilePizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }

    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImagesKeyContainer.self)
        baseUrl = try container.decode(String.self, forKey: .baseUrl)
        secureBaseUrl = try container.decode(String.self, forKey: .secureBaseUrl)
        backdropSizes = try container.decode([BackdropSizes].self, forKey: .backdropSizes)
        logoSizes = try container.decode([LogoSizes].self, forKey: .logoSizes)
        posterSizes = try container.decode([PosterSizes].self, forKey: .posterSizes)
        profilePizes = try container.decode([ProfilePizes].self, forKey: .profilePizes)
        stillSizes = try container.decode([StillSizes].self, forKey: .stillSizes)
    }

}
