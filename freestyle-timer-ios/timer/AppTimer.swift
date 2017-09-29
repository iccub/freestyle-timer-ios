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

import UIKit

/** Simple sublass of Timer that ticks every 1 seconds */
class TickTimer: Timer {
    static let tickInterval = 1
    
    static func fire(selector: Selector, target: Any) -> Timer {
        return Timer.scheduledTimer(timeInterval: Double(tickInterval), target: target,
                                    selector: selector, userInfo: nil, repeats: true)
    }
}
