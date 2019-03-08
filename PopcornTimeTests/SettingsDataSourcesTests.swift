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
        Manager.webService.settings.getSettings { result in
            XCTAssertTrue(result.isSuccess)
            
            guard let values = result.value else {
                XCTFail()
                return
            }
            
            Manager.dataSource.settings.configutation = values.configuration
            Manager.dataSource.settings.genres = values.genres

            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

    func testConfiguration() {
        XCTAssertNotNil(Manager.dataSource.settings.configutation)
    }

    func testGenres() {
        XCTAssertNotNil(Manager.dataSource.settings.genres)
    }

}
