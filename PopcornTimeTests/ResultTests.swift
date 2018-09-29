//
//  ResultTests.swift
//  PopcornTimeTests
//
//  Created by Carmelo Gallo on 29/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest
@testable import PopcornTime

class ResultTests: XCTestCase {

    func testExample() {
        let text = "Now Yes!"
        enum ResultError: Error {
            case nowYes
        }
        
        // success
        var result = Result<String>.success(value: text)
        XCTAssertTrue(result.isSuccess)
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.value == text)
        XCTAssertNil(result.error)
        XCTAssertTrue(result.description == "SUCCESS")
        XCTAssertTrue(result.debugDescription == "SUCCESS: \(text)")

        // failure
        result = Result<String>.failure(error: ResultError.nowYes)
        XCTAssertNil(result.value)
        guard let error = result.error as? ResultError else {
            XCTFail("The type must be ResultError!")
            return
        }
        XCTAssertTrue(error == .nowYes)
        XCTAssertTrue(result.description == "FAILURE")
        XCTAssertTrue(result.debugDescription == "FAILURE: \(ResultError.nowYes)")
    }

}
