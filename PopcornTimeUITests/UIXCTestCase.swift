//
// Created by Carmelo Gallo on 2019-03-09.
// Copyright (c) 2019 Carmelo Gallo. All rights reserved.
//

import XCTest

class UIXCTestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = [LaunchArguments.StubNetworkResponses.rawValue]
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
