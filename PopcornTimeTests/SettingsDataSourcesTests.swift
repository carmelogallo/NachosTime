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
        SettingsDataSource.getSettings { result in
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

    func testConfiguration() {
        XCTAssertNotNil(SettingsDataSource.configutation)
    }

    func testGenres() {
        XCTAssertNotNil(SettingsDataSource.genres)
    }

}
