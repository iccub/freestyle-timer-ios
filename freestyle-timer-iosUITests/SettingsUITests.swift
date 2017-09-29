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

class SettingsUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        app.launchArguments += ["UI-Testing"]
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
      
    }
    
    func testChangingSettings() {
        
        XCUIApplication().navigationBars["Freestyle Timer"].children(matching: .button).element.tap()
        
        // Total time
        XCTAssert(app.tables.cells.staticTexts["3:00"].exists)
        XCTAssertFalse(app.tables.cells.staticTexts["4:00"].exists)
        // Number of rounds
        XCTAssert(app.tables.cells.staticTexts["3"].exists)
        
        app.tables.cells.staticTexts["3"].tap()
        
        XCTAssert(app.navigationBars.staticTexts["Number of rounds"].exists)
        // Change to 4 rounds
        app.tables.cells.staticTexts["4 rounds"].tap()
        // Back
        app.navigationBars.buttons["Settings"].tap()
        
        // Total time should change
        XCTAssert(app.tables.cells.staticTexts["4:00"].exists)
        XCTAssertFalse(app.tables.cells.staticTexts["3:00"].exists)
        // Number of rounds should change
        XCTAssert(app.tables.cells.staticTexts["4"].exists)
        
        // Qualification timer duration
        XCTAssert(app.tables.cells.staticTexts["1:30"].exists)
        XCTAssertFalse(app.tables.cells.staticTexts["2:00"].exists)
        app.tables.cells.staticTexts["1:30"].tap()
        XCTAssert(app.navigationBars.staticTexts["Duration"].exists)
        app.tables.cells.staticTexts["120 seconds"].tap()
        // Back
        app.navigationBars.buttons["Settings"].tap()
        XCTAssert(app.tables.cells.staticTexts["4:00"].exists)
        XCTAssert(app.tables.cells.staticTexts["2:00"].exists)
        XCTAssertFalse(app.tables.cells.staticTexts["1:30"].exists)
    }
    
}
