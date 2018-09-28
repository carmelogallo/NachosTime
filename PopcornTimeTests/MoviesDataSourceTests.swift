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
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Web Service Failed!")
            }
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
    
    func testGetNextNowPlaying() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        MoviesDataSource.getNextNowPlaying { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Web Service Failed!")
            }
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

}
