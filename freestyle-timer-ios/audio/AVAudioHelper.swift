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
import AVFoundation
import os.log

/**
 Helper class for allowing background audio playback.
 */
struct AVAudioHelper {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "AVAudioHelper")
    
    static func activateBackgroundAudioPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            os_log("Failed to activate background audio playback, error: %@",
                   log: AVAudioHelper.log, type: .fault, error.localizedDescription)
        }
    }
    
    static func deactivateBackgroundAudioPlayback() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            os_log("Failed to deactivate background audio playback, error: %@",
                   log: AVAudioHelper.log, type: .fault, error.localizedDescription)
        }
    }
}
