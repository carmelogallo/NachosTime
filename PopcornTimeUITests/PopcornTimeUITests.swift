//
//  PopcornTimeUITests.swift
//  PopcornTimeUITests
//
//  Created by Carmelo Gallo on 27/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest

class PopcornTimeUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testIfNowPlayingViewIsDisplayed() {
        XCTAssertTrue(XCUIApplication().navigationBars["Now Playing"].otherElements["Now Playing"].exists)
    }
    
    func testCollectionViewItemCount() {
        XCTAssertTrue(XCUIApplication().collectionViews.cells.count >= 0)
    }
    
    func testIfDetailsViewIsDisplayed() {
        let app = XCUIApplication()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        XCTAssertTrue(app.navigationBars["Movie Details"].exists)
    }

}
