/*
 Copyright © 2017 Michał Buczek.
 
 This file is part of Freestyle Timer.
 
 Freestyle Timer is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Freestyle Timer is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Freestyle Timer.  If not, see <http://www.gnu.org/licenses/>.
 */

import XCTest

class ChooseModeScreenTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTimerModeSwipes() {
        let app = XCUIApplication()
        
        let pageElement = app.otherElements.containing(.navigationBar, identifier:"Freestyle Timer").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
    
        XCTAssert(app.staticTexts["Battle"].exists)
        pageElement.swipeLeft()
        XCTAssert(app.staticTexts["Qualification"].exists)
        // Can't swipe more, testing bounds
        pageElement.swipeLeft()
        XCTAssert(app.staticTexts["Qualification"].exists)
        pageElement.swipeRight()
        XCTAssert(app.staticTexts["Battle"].exists)
        pageElement.swipeRight()
        XCTAssert(app.staticTexts["Battle"].exists)
    }
    
    func testNavigation() {
        let app = XCUIApplication()
        XCTAssertFalse(app.navigationBars.staticTexts["Battle"].exists)
        
        // Tap battle timer
        app.buttons["Select"].tap()
        XCTAssert(app.navigationBars.staticTexts["Battle"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Qualification"].exists)
        
        // Back
        app.navigationBars.buttons["Freestyle Timer"].tap()
        XCTAssert(app.staticTexts["Battle"].exists)
        XCTAssertFalse(app.staticTexts["Qualification"].exists)
        
        // Tap qualification timer
        app.swipeLeft()
        app.buttons["Select"].tap()
        XCTAssert(app.navigationBars.staticTexts["Qualification"].exists)
        XCTAssertFalse(app.navigationBars.staticTexts["Battle"].exists)
        
        // Back
        app.navigationBars.buttons["Freestyle Timer"].tap()
        XCTAssert(app.staticTexts["Qualification"].exists)
        XCTAssertFalse(app.staticTexts["Battle"].exists)
        
        // Tap settings button
        XCUIApplication().navigationBars["Freestyle Timer"].children(matching: .button).element.tap()
        XCTAssert(app.navigationBars.staticTexts["Settings"].exists)
        app.navigationBars.buttons["Freestyle Timer"].tap()
        XCTAssert(app.staticTexts["Qualification"].exists)
        
    }
}
