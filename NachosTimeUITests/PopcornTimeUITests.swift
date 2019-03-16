//
//  NachosTimeUITests.swift
//  NachosTimeUITests
//
//  Created by Carmelo Gallo on 27/10/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import XCTest

class NachosTimeUITests: UIXCTestCase {

    func testIfNowPlayingViewIsDisplayed() {
        XCTAssertTrue(app.navigationBars["Now Playing"].exists)
    }

    func testIfDetailsViewIsDisplayed() {
        let item = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(item.exists)
        item.tap()

        let navigationBarTitle = app.navigationBars["The Nun"]
        XCTAssertTrue(navigationBarTitle.exists)

        let genres = app.staticTexts["MovieDetails.Movie.Genres"]
        XCTAssertTrue(genres.exists)
        XCTAssertEqual(genres.label, "Horror • Mystery • Thriller")

        let overview = app.staticTexts["MovieDetails.Movie.Overview"]
        XCTAssertTrue(overview.exists)
        XCTAssertEqual(overview.label, "When a young nun at a cloistered abbey in Romania takes her own life, a priest with a haunted past and a novitiate on the threshold of her final vows are sent by the Vatican to investigate. Together they uncover the order’s unholy secret. Risking not only their lives but their faith and their very souls, they confront a malevolent force in the form of the same demonic nun that first terrorized audiences in “The Conjuring 2,” as the abbey becomes a horrific battleground between the living and the damned.")
    }

}
