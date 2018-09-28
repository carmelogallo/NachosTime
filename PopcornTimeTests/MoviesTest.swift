//
//  MoviesTest.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest

class MoviesTest: XCTestCase {

    func testParsingSuccess() {
        let movies = JSONFactory.makeCorrectMoviesResponse()
        XCTAssertNotNil(movies)
    }
    
    func testParsingFailure() {
        let movies = JSONFactory.makeWrongMoviesResponse()
        XCTAssertNil(movies)
    }

}
