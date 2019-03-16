//
//  MoviesTest.swift
//  NachosTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import NachosTime

class MoviesTest: XCTestCase {
    
    func testParsingSuccess() {
        let movies = JSONFactory.makeCorrectMoviesResponse()
        XCTAssertNotNil(movies)
    }
    
    func testParsingFailure() {
        let movies: Movies? = JSONFactory.makeWrongDataResponse()
        XCTAssertNil(movies)
    }

    func testGeners() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        Manager.webService.settings.get { result in
            XCTAssertTrue(result.isSuccess)
            
            guard let values = result.value else {
                XCTFail()
                return
            }
            
            Manager.dataSource.settings.configuration = values.configuration
            Manager.dataSource.settings.genres = values.genres

            let movies = JSONFactory.makeCorrectMoviesResponse()
            XCTAssertNotNil(movies?.movies[0].genres)
            
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
    
}
