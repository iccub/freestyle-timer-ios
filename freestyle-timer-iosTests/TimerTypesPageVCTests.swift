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

class TimerTypesPageVCTests: XCTestCase {
    
    var vc: TimerModesPageVC!
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "TimerTypesPageVC") as! TimerModesPageVC
        let _ = vc.view
    }
    
    override func tearDown() {
        vc = nil
        super.tearDown()
    }
    
    func testPagesLoadCorrectly() {
        XCTAssertEqual(vc.pages.count, 2)
        XCTAssert(vc.delegate != nil)
        XCTAssert(vc.dataSource != nil)
        
        XCTAssertNotNil(vc.viewControllers?.first)
        XCTAssertNotNil(vc.pages.first)
        
        XCTAssertEqual(vc.viewControllers!.first!, vc.pages.first!)
    }
    
    func testPageVCSetting() {
        let firstVC = vc.pages.first!
        let lastVC = vc.pages.last!
        let randomVC = UIViewController()
        
        // First element, should return second
        XCTAssertEqual(vc.pageViewController(vc, viewControllerAfter: firstVC), vc.pages[1])
        // Last element, should return nil
        XCTAssertNil(vc.pageViewController(vc, viewControllerAfter: lastVC))
        // Wrong element should return nil
        XCTAssertNil(vc.pageViewController(vc, viewControllerAfter: randomVC))
        
        // Test VC before
        // First element, should return nil
        XCTAssertNil(vc.pageViewController(vc, viewControllerBefore: firstVC))
        // Last element, should return last - 1
        XCTAssertEqual(vc.pageViewController(vc, viewControllerBefore: lastVC), vc.pages[vc.pages.count - 2])
        // Wrong element should return nil
        XCTAssertNil(vc.pageViewController(vc, viewControllerBefore: randomVC))
    }
}
