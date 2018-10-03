//
//  SettingsDataSourcesTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class SettingsDataSourcesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let expectation = self.expectation(description: "\(#function)\(#line)")
        Api.settings.getSettings { result in
            XCTAssertTrue(result.isSuccess)
            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

    func testConfiguration() {
        XCTAssertNotNil(DataSource.settings.configutation)
    }

    func testGenres() {
        XCTAssertNotNil(DataSource.settings.genres)
    }

}
