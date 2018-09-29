//
//  GenreTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class GenreTests: XCTestCase {

    func testParsingSuccess() {
        let genres = JSONFactory.makeCorrectGenresResponse()
        XCTAssertNotNil(genres)
    }
    
    func testParsingFailure() {
        guard let genres: Genres = JSONFactory.makeWrongDataResponse() else {
            return
        }
        XCTAssertNil(genres)
    }

}
