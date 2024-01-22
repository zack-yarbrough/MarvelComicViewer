//
//  MarvelComicViewerUITests.swift
//  MarvelComicViewerUITests
//
//  Created by Zack Yarbrough on 1/22/24.
//

import XCTest

final class MarvelComicViewerUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func test_comicView() {
        let app = XCUIApplication()
        
        sleep(2)
        
        XCTAssert(app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Comic.Title"]/*[[".staticTexts[\"Alien (2023) #3\"]",".staticTexts[\"Comic.Title\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Comic.Description"]/*[[".staticTexts[\"STAY FROSTY! The Yutani family has decided to settle the invasion of LV-695 personally. But no corporate executive has the authority to tell a Xenomorph what to do…unless the order is \\\"slaughter\\\"! And knowing the Weyland-Yutani Corp? It just might be. Trapped between an avalanche and a watery death, the mysterious \\\"Cole\\\" makes her hardest decisions yet.\"]",".staticTexts[\"Comic.Description\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Comic.Series"]/*[[".staticTexts[\"Series: Alien (2023 - Present)\"]",".staticTexts[\"Comic.Series\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Comic.Date"]/*[[".staticTexts[\"Published: Jan 16, 2024\"]",".staticTexts[\"Comic.Date\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(app.scrollViews.otherElements.staticTexts["Comic.Creator"].exists)
    }
    
}
