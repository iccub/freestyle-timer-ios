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

struct AlertFactory {
    static func noSongChosenDialog() -> UIAlertController {
        let alert = UIAlertController(title: "No song chosen", message: "Please choose a song by tapping at the toolbar button. Song duration can't be shorter than timer's time, multiple tracks can be chosen. You can adjust timer's total time in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        return alert
    }
    
    static func songTooShortDialog() -> UIAlertController {
        let alert = UIAlertController(title: "Too short music duration", message: "Chosen music duration is shorter than timer's total time. Please select longer song or add multiple songs.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        return alert
    }
}
