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

import Foundation

extension Int {
    /**
     Converts time in seconds to mm:ss format or to seconds only if time in seconds is less than 10.
     */
    func secondsToTime() -> String {
        guard self > 10 else {
            return "\(self)"
        }
        
        let minutes = self / 60
        let seconds = self % 60
        
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return "\(minutes):\(secondsString)"
    }
}
