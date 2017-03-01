//
//  GitHubUsersViewerUITests.swift
//  GitHubUsersViewerUITests
//
//  Created by Hank on 15/02/2017.
//  Copyright © 2017 iDevHank. All rights reserved.
//

import XCTest

class GitHubUsersViewerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTitle() {
        XCTAssert(XCUIApplication().navigationBars["GitHub Users"].exists)
    }
    
    func testLoadData() {
        let userName = XCUIApplication().staticTexts["josh"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: userName, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(userName.exists)
    }
    
    func testSwipeUp() {
        let firstCell = XCUIApplication().staticTexts["josh"]
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: -200))
        start.press(forDuration: 0, thenDragTo: finish)
        let userName = XCUIApplication().staticTexts["rubyist"]
        XCTAssert(userName.exists)
    }
    
    func testTapAvatar() {
        testLoadData()
        XCUIApplication().collectionViews.cells.images.element(boundBy: 0).tap()
        XCTAssert(XCUIApplication().navigationBars["Detail"].exists)
    }

    func testTapLabel() {
        testLoadData()
        XCUIApplication().collectionViews.cells.staticTexts["josh"].tap()
        XCTAssertFalse(XCUIApplication().navigationBars["Detail"].exists)
    }

    func testPopBack() {
        testTapAvatar()
        XCUIApplication().buttons["GitHub Users"].tap()
        XCTAssert(XCUIApplication().navigationBars["GitHub Users"].exists)
    }
    
    func testUserDetails() {
        testTapAvatar()
        
        let userName = XCUIApplication().staticTexts["Simon Jefford"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: userName, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(userName.exists)
    }
}
