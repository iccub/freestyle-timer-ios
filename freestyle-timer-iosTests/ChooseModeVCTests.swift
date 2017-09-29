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

class ChooseModeVCTests: XCTestCase {
    
    var vc: ChooseModeVC!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ChooseModeVC") as! ChooseModeVC
        
        let _ = vc.view
    }
    
    override func tearDown() {
        vc = nil
        super.tearDown()
    }
    
    func testTimerModeChanged() {
        let newPageIndex = 1
        XCTAssertNotEqual(vc.timerModesPageControl.currentPage, newPageIndex)
        
        vc.timerModeChanged(index: newPageIndex)
        XCTAssertEqual(vc.timerModesPageControl.currentPage, newPageIndex)
        
        let theSameIndex = vc.timerModesPageControl.currentPage
        vc.timerModeChanged(index: theSameIndex)
        XCTAssertEqual(vc.timerModesPageControl.currentPage, newPageIndex)
    }
}
