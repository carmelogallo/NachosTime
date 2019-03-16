//
//  SettingsWebServiceTests.swift
//  NachosTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import NachosTime

class SettingsWebServiceTests: XCTestCase {

    func testSettings() {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        Manager.webService.settings.get { result in
            XCTAssertTrue(result.isSuccess)

            guard let values = result.value else {
                XCTFail()
                return
            }

            XCTAssertNotNil(values.configuration)
            XCTAssertNotNil(values.genres)

            expectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result == .completed)
    }
}
