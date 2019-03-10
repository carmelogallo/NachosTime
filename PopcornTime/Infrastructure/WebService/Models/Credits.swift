//
// Created by Carmelo Gallo on 2019-03-10.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import Foundation

struct Credits: Decodable {
    // MARK: - Decodable Properties

    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable, Hashable {

    // MARK: - Hashable

    var hashValue: Int { return id.hashValue }

    // MARK: - Decodable Properties

    let id: Int
    let castId: Int
    let creditId: String
    let character: String
    let gender: Gender?
    let name: String
    let order: Int
    let profilePath: String?

    // MARK: - Private Properties

    private enum CodingKeys: String, CodingKey {
        case id
        case castId = "cast_id"
        case creditId = "credit_id"
        case character
        case gender
        case name
        case order
        case profilePath = "profile_path"
    }

    // MARK: - Decodable Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        castId = try container.decode(Int.self, forKey: .castId)
        creditId = try container.decode(String.self, forKey: .creditId)
        character = try container.decode(String.self, forKey: .character)
        gender = try container.decode(Gender?.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
        order = try container.decode(Int.self, forKey: .order)
        profilePath = try container.decode(String?.self, forKey: .profilePath)
    }

    // MARK: - Hashable Lifecycle

    static func ==(left: Cast, right: Cast) -> Bool {
        return left.id == right.id
    }

}

struct Crew: Decodable, Hashable {

    // MARK: - Hashable

    var hashValue: Int { return id.hashValue }

    // MARK: - Decodable Properties

    let id: Int
    let creditId: String
    let department: String
    let gender: Gender?
    let name: String
    let job: String
    let profilePath: String?

    // MARK: - Private Properties

    private enum CodingKeys: String, CodingKey {
        case id
        case castId = "cast_id"
        case creditId = "credit_id"
        case department
        case gender
        case name
        case job
        case profilePath = "profile_path"
    }

    // MARK: - Decodable Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        creditId = try container.decode(String.self, forKey: .creditId)
        department = try container.decode(String.self, forKey: .department)
        gender = try container.decode(Gender?.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
        job = try container.decode(String.self, forKey: .job)
        profilePath = try container.decode(String?.self, forKey: .profilePath)
    }

    // MARK: - Hashable Lifecycle

    static func ==(left: Crew, right: Crew) -> Bool {
        return left.id == right.id
    }

}
