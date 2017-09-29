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
@testable import freestyle_timer_ios

class SettingsTests: XCTestCase {
    let ud = UserDefaults.standard
  
    override func setUp() {
        super.setUp()
        Settings.initializeDefaults()
    }
    
    override func tearDown() {
        ud.removeObject(forKey: Settings.Battle.Keys.players)
        ud.removeObject(forKey: Settings.Battle.Keys.roundDuration)
        ud.removeObject(forKey: Settings.Battle.Keys.numberOfRounds)
        ud.removeObject(forKey: Settings.Battle.Keys.preparationTime)
        
        ud.removeObject(forKey: Settings.Qualification.Keys.duration)
        ud.removeObject(forKey: Settings.Qualification.Keys.soundInterval)
        ud.removeObject(forKey: Settings.Qualification.Keys.preparationTime)
        ud.removeObject(forKey: Settings.settingsInitializedKey)
        
        super.tearDown()
    }
    
    func testDefaults() {
     
        XCTAssertEqual(Settings.int(for: Settings.Battle.Keys.players), 2)
        XCTAssertEqual(ud.integer(forKey: Settings.Battle.Keys.roundDuration), 30)
        XCTAssertEqual(ud.integer(forKey: Settings.Battle.Keys.numberOfRounds), 3)
        XCTAssertEqual(ud.integer(forKey: Settings.Battle.Keys.preparationTime), 10)
        
        XCTAssertEqual(ud.integer(forKey: Settings.Qualification.Keys.duration), 90)
        XCTAssertEqual(ud.integer(forKey: Settings.Qualification.Keys.soundInterval), 30)
        XCTAssertEqual(ud.integer(forKey: Settings.Qualification.Keys.preparationTime), 10)
    }
}
