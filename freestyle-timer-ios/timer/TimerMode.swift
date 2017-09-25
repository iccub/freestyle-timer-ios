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

/**
 This enum holds all Timer Mode info needed to set up a TimerViewController with proper values
 */
enum TimerMode: Int {
    // Int value is corresponding pageVC index
    case battle = 0, qualification
    
    func storyboardID() -> String {
        switch self {
        case .battle: return "mode-battle"
        case .qualification: return "mode-qualification"
        }
    }
    
    var switchSoundUrl: URL? {
        switch self {
            case .battle: return soundUrl(name: "airhorn")
            case .qualification: return soundUrl(name: "beep2")
        }
    }
    
    var endSoundUrl: URL? {
        switch self {
        case .battle: return soundUrl(name: "airhorn_finish")
        // For qualifications, end sounds is the same as interval sound
        case .qualification: return soundUrl(name: "beep2")
        }
    }
    
    private func soundUrl(name: String) -> URL? {
        return Bundle.main.url(forResource: name, withExtension: "mp3")
    }
    
    var duration: Int {
        switch self {
        case .battle:
            let players = Settings.int(for: Settings.Battle.Keys.players)
            let roundDuration = Settings.int(for: Settings.Battle.Keys.roundDuration)
            let numberOfRounds = Settings.int(for: Settings.Battle.Keys.numberOfRounds)
            
            return players * roundDuration * numberOfRounds
        case .qualification:
            return Settings.int(for: Settings.Qualification.Keys.duration)
        }
    }
    
    /** Determines how often interval sound should be played */
    var soundInterval: Int {
        switch self {
        case .battle:
            return Settings.int(for: Settings.Battle.Keys.roundDuration)
        case .qualification:
            return Settings.int(for: Settings.Qualification.Keys.soundInterval)
        }
    }
    
    var extraTimeDuration: Int {
        switch self {
        case .battle:
            let players = Settings.int(for: Settings.Battle.Keys.players)
            let roundDuration = Settings.int(for: Settings.Battle.Keys.roundDuration)
            
            return players * roundDuration
        case .qualification:
            return Settings.int(for: Settings.Qualification.Keys.duration)
        }
    }
    
    /** Preparation timer allows player to give some time before main timer starts,
     so they can phone down, prepare etc. */
    var preparationDuration: Int {
        switch self {
        case .battle: return Settings.int(for: Settings.Battle.Keys.preparationTime)
        case .qualification: return Settings.int(for: Settings.Qualification.Keys.preparationTime)
        }
    }
    
    /** Title for navigation bar */
    var title: String {
        switch self {
        case .battle: return "Battle"
        case .qualification: return "Qualification"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .battle: return Colors.appBlueColor
        case .qualification: return Colors.appGreenColor
        }
    }
    
    // MARK: - Static methods
    
    /** Return timerMode for pageViewController index */
    static func timerMode(for index: Int) -> TimerMode {
        return index == TimerMode.battle.rawValue ? .battle : .qualification
    }
    
    /** Background color changes with pageVC swipes, we need to keep track of it */
    static func backgroundColor(for index: Int) -> UIColor {
        switch index {
        case TimerMode.battle.rawValue: return Colors.appBlueColor
        case TimerMode.qualification.rawValue: return Colors.appGreenColor
        default: return UIColor(red: 133/255.0, green: 28/255.0, blue: 13/255.0, alpha: 1.0)
        }
    }
    
    static func getAllStoryboardIDs() -> [String] {
        return [TimerMode.battle.storyboardID(),
                TimerMode.qualification.storyboardID()]
    }
}
