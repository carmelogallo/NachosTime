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
    
    struct API {
        static let baseUrl = "https://api.themoviedb.org/3"
        static let apiKey = "90a5acd11cdcfb676199c9476c07cbb9"
    }

    open override func setUp() {
        super.setUp()
        stubConfiguration()
        stubGenres()
        stubMoviesAtPage1()
        stubMoviesAtPage2()
        stubSearchAtPage1()
        stubSearchAtPage2()
    }
    
    private func stubConfiguration() {
        // https://api.themoviedb.org/3/configuration?api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/configuration" + "?" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "configuration_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
    }

    private func stubGenres() {
        // https://api.themoviedb.org/3/genre/movie/list?api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/genre/movie/list" + "?" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "genres_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
   }

    private func stubMoviesAtPage1() {
        // https://api.themoviedb.org/3/movie/now_playing?page=1&api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/movie/now_playing?page=1" + "&" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
    }

    private func stubMoviesAtPage2() {
        // https://api.themoviedb.org/3/movie/now_playing?page=1&api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/movie/now_playing?page=2" + "&" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
    }

    private func stubSearchAtPage1() {
        // https://api.themoviedb.org/3/search/movie?page=1&query=Marvel&api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/search/movie?page=1&query=Marvel" + "&" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
    }

    private func stubSearchAtPage2() {
        // https://api.themoviedb.org/3/search/movie?page=2&query=Marvel&api_key=90a5acd11cdcfb676199c9476c07cbb9
        let uri = API.baseUrl + "/search/movie?page=2&query=Marvel" + "&" + API.apiKey
        let fixture = Bundle(for: type(of: self)).url(forResource: "movies_succeful", withExtension: "json")!
        let data = try! Data(contentsOf: fixture)
        stub(http(.get, uri: uri), jsonData(data))
    }
}
