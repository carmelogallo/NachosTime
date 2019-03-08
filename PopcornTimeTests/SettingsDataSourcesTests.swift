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
        Manager.webService.settings.get { result in
            XCTAssertTrue(result.isSuccess)
            
            guard let values = result.value else {
                XCTFail()
                return
            }
            
            Manager.dataSource.settings.configuration = values.configuration
            Manager.dataSource.settings.genres = values.genres

            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }

    func testConfiguration() {
        XCTAssertNotNil(Manager.dataSource.settings.configuration)
    }

    func testGenres() {
        XCTAssertNotNil(Manager.dataSource.settings.genres)
    }

}
