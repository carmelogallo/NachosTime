//
//  PopcornTimeTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 27/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
import Mockingjay

extension XCTestCase {

    open override func setUp() {
        super.setUp()
        stubConfiguration()
        stubGenres()
        stubMovies()
        stubSearch()
    }
    
    private func stubConfiguration() {
        let uri = "/3/configuration"
        let fixture = Bundle(for: type(of: self)).url(forResource: "configuration_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(matcher(uri: uri, method: .get), jsonData(data))
    }

    private func stubGenres() {
        let uri = "/3/genre/movie/list"
        let fixture = Bundle(for: type(of: self)).url(forResource: "genres_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(matcher(uri: uri, method: .get), jsonData(data))
   }

    private func stubMovies() {
        let uri = "/3/movie/now_playing"
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(matcher(uri: uri, method: .get), jsonData(data))
    }

    private func stubSearch() {
        let uri = "/3/search/movie"
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_successful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(matcher(uri: uri, method: .get), jsonData(data))
    }

    private func matcher(uri: String, method: HTTPMethod) -> (_ request: URLRequest) -> Bool {
        return { request in
            let containUri = request.url?.path.contains(uri) ?? false
            var sameMethod = false
            if let httpMethod = request.httpMethod, httpMethod == method.description {
                sameMethod = true
            }
            return containUri && sameMethod
        }
    }
}
