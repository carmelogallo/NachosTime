//
//  MoviesTest.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class MoviesTest: XCTestCase {
    
    func testParsingSuccess() {
        let movies = JSONFactory.makeCorrectMoviesResponse()
        XCTAssertNotNil(movies)
    }
    
    func testParsingFailure() {
        guard let movies: Movies = JSONFactory.makeWrongDataResponse() else {
            return
        }
        XCTAssertNil(movies)
    }

    func testGeners() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        SettingsDataSource.getSettings { result in
            switch result {
            case .success:
                let movies = JSONFactory.makeCorrectMoviesResponse()
                XCTAssertNotNil(movies?.movies[0].genres)
                expectation.fulfill()
            case .failure:
                XCTFail("Web Service Failed!")
            }
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
    
}
