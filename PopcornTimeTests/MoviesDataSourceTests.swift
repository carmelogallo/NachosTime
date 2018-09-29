//
//  MoviesDataSourceTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class MoviesDataSourceTests: XCTestCase {
    
    func testGetNowPlaying() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        MoviesDataSource.getNowPlaying { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
    
    func testGetNextNowPlaying() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        MoviesDataSource.getNextNowPlaying { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

    func testGetSearch() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        MoviesDataSource.getSearch(keyWords: "Marvel") { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
    
    func testGetNextSearch() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        MoviesDataSource.getNextSearch { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

}
