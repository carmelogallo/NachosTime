//
//  Movies.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import Foundation

// MARK: - Movies

struct Movies: ModelsProtocol {
    
    // MARK: - Decodable Properties
    
    let movies: [Movie]
    let page: Int
    let totalPages: Int
    let totalMovies: Int
    let dates: Dates?
    
    // MARK: - Private Properties
    
    private enum MoviesKeyContainer: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
        case totalMovies = "total_results"
        case dates
    }
    
    // MARK: - Decodable Lifecycle
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Movies.self, from: data)
    }
    
    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoviesKeyContainer.self)
        movies = try container.decode([Movie].self, forKey: .movies)
        page = try container.decode(Int.self, forKey: .page)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        totalMovies = try container.decode(Int.self, forKey: .totalMovies)
        dates = try container.decodeIfPresent(Dates.self, forKey: .dates)
    }

}

// MARK: - Movie

struct Movie: Decodable {

    // MARK: - Decodable Properties
    var genres: String? {
        guard let genres = Manager.dataSource.settings.genres else { return nil }
        let filtered = genres.filter { genreIds.contains($0.id) }
        let names = filtered.map { $0.name }
        return names.joined(separator: " • ")
    }

    // MARK: - Decodable Properties
    
    let id: Int
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
    let title: String
    let popularity: Double
    let posterPath: String?
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]
    let backdropPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    
    // MARK: - Private Properties
    
    private enum MovieKeyContainer: String, CodingKey {
        case id
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDate = "release_date"
    }
    
    // MARK: - Decodable Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeyContainer.self)
        id = try container.decode(Int.self, forKey: .id)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        title = try container.decode(String.self, forKey: .title)
        popularity = try container.decode(Double.self, forKey: .popularity)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        adult = try container.decode(Bool.self, forKey: .adult)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }

}

// MARK: - Genres

struct Dates: Decodable {
    let minimum: String
    let maximum: String
}
