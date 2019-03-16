//
//  ConfigurationTests.swift
//  NachosTimeTests
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import NachosTime

class ConfigurationTests: XCTestCase {

    func testParsingSuccess() {
        let configuration = JSONFactory.makeCorrectConfigurationResponse()
        XCTAssertNotNil(configuration)
    }
    
    func testParsingFailure() {
        let configuration: Configuration? = JSONFactory.makeWrongDataResponse()
        XCTAssertNil(configuration)
    }
    
    func testPosterSizeValueSuccess() {
        let configuration = JSONFactory.makeCorrectConfigurationResponse()
        XCTAssertEqual(configuration?.images.posterSizeValue(Images.PosterSize.w154), "w154")
    }
    
    
    func testPosterSizeValueFailure() {
        let configuration = JSONFactory.makeCorrectConfigurationWithMissingDataResponse()
        XCTAssertNil(configuration?.images.posterSizeValue(Images.PosterSize.w154))
    }
    
    func testBackdropSizeValueSuccess() {
        let configuration = JSONFactory.makeCorrectConfigurationResponse()
        XCTAssertEqual(configuration?.images.backdropSizeValue(Images.BackdropSize.w300), "w300")
    }
    
    
    func testBackdropSizeValueFailure() {
        let configuration = JSONFactory.makeCorrectConfigurationWithMissingDataResponse()
        XCTAssertNil(configuration?.images.backdropSizeValue(Images.BackdropSize.w300))
    }
    
}
