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
import os.log

/**
 Structure holding all things needed for settings: keyPath for UserDefaults and predefinied values which are filled
 after setting an option. Settings are split by timer modes: Battle and Qualifications.
 */
struct Settings: Codable {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "Settings")
    
    /** SettingsOptions are used to fill SettingsOptionsTableVC with predefinied data. It holds two properties,
     display name to show as a label in table cell and its value. */
    typealias SettingsOption = (name: String, value: Int)
    
    /** Keep track wheter settings were initialized with default data. */
    static let settingsInitializedKey = "settingsInitialized"
    
    /** Shorthand method to get values from UserDefaults.default object. */
    static func int(for key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    struct Battle {
        struct Keys {
            static let players = "settingsBattlePlayers"
            static let roundDuration = "settingsBattleRoundDuration"
            static let numberOfRounds = "settingsBattleNumberOfRounds"
            static let preparationTime = "settingsBattlePreparationTime"
        }
        
        struct Options {
            static let playerOptions = [SettingsOption("2 players", 2),
                                        SettingsOption("3 players", 3),
                                        SettingsOption("4 players", 4)]
            
            static let roundDuration = [SettingsOption("30 seconds", 30),
                                        SettingsOption("45 seconds", 45),
                                        SettingsOption("60 seconds", 60)]
            
            static let numberOfRounds = [SettingsOption("1 round", 1),
                                        SettingsOption("2 rounds", 2),
                                        SettingsOption("3 rounds", 3),
                                        SettingsOption("4 rounds", 4)]
            
            static let preparationTime = [SettingsOption("3 seconds", 3),
                                          SettingsOption("5 seconds", 5),
                                          SettingsOption("10 seconds", 10)]
        }
    }
    
    struct Qualification {
        struct Keys {
            static let duration = "settingsQualificationDuration"
            static let soundInterval = "settingsQualificationSoundInterval"
            static let preparationTime = "settingsQualificationPreparationTime"
        }
        
        struct Options {
            static let duration = [SettingsOption("30 seconds", 30),
                                   SettingsOption("45 seconds", 45),
                                   SettingsOption("60 seconds", 60),
                                   SettingsOption("75 seconds", 75),
                                   SettingsOption("90 seconds", 90),
                                   SettingsOption("120 seconds", 120),
                                   SettingsOption("180 seconds", 180)]
            
            static let soundInterval = [SettingsOption("15 seconds", 15),
                                         SettingsOption("30 seconds", 30),
                                         SettingsOption("45 seconds", 45),
                                         SettingsOption("60 seconds", 60)]
            
            static let preparationTime = [SettingsOption("3 seconds", 3),
                                          SettingsOption("5 seconds", 5),
                                          SettingsOption("10 seconds", 10)]
        }
    }
    
    /** Defaults used for first use of the app */
    static func initializeDefaults() {
        os_log("initializing defaults", log: Settings.log)
        let settings = UserDefaults.standard
        
        settings.set(2, forKey: Battle.Keys.players)
        settings.set(30, forKey: Battle.Keys.roundDuration)
        settings.set(3, forKey: Battle.Keys.numberOfRounds)
        settings.set(10, forKey: Battle.Keys.preparationTime)
        
        settings.set(90, forKey: Qualification.Keys.duration)
        settings.set(30, forKey: Qualification.Keys.soundInterval)
        settings.set(10, forKey: Qualification.Keys.preparationTime)
        
        settings.set(true, forKey: Settings.settingsInitializedKey)
        
        settings.synchronize()
    }
}
