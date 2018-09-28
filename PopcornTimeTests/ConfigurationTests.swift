//
//  ConfigurationTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class ConfigurationTests: XCTestCase {

    func testParsingSuccess() {
        let configuration = JSONFactory.makeCorrectConfigurationResponse()
        XCTAssertNotNil(configuration)
    }
    
    func testParsingFailure() {
        let configuration = JSONFactory.makeWrongConfigurationResponse()
        XCTAssertNil(configuration)
    }

}
