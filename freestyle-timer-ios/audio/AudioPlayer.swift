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
import AudioToolbox
import CoreMedia
import os.log

/**
 This class holds all audio players used by app. The app uses separate players for playing music and interval sounds.
 AVQueuePlayer is used for music player, which allows multiple tracks to be played. This is used in case when timer
 length is longer than song duration which causes timer to stop while in background(app uses backgroud audio
 permission to run in background).
 */
class AudioPlayer {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "AudioPlayer")
    
    private var music: AVQueuePlayer?
    private let switchSound: AVAudioPlayer
    private let endSound: AVAudioPlayer
    /** We hold reference to all songs to reset them after user presses stop button or timer has finished. */
    private var songUrlsList: [URL]?
    
    init(timerMode: TimerMode) throws {
        guard let switchSoundURL = timerMode.switchSoundUrl, let endSoundURL = timerMode.endSoundUrl else {
            os_log("Could not find interval sound resources", log: AudioPlayer.log, type: .error)
            throw NSError()
        }
        
        do {
            switchSound = try AVAudioPlayer(contentsOf: switchSoundURL)
            switchSound.prepareToPlay()
            
            endSound = try AVAudioPlayer(contentsOf: endSoundURL)
            endSound.prepareToPlay()
        } catch {
            os_log("Failed to initialize interval sounds", log: AudioPlayer.log, type: .error)
            throw error
        }
    }
    
    func setSongs(urls: [URL]) {
        let items = urls.map { return AVPlayerItem(url: $0) }
        
        songUrlsList = urls
        music = AVQueuePlayer(items: items)
        os_log("Music player set with %i song/s", log: AudioPlayer.log, type: .info, items.count)
    }
    
    /** Check if music player was set. */
    func isMusicSet() -> Bool {
        return music != nil
    }
    
    // MARK: - Interval sounds
    
    func playSwitchSound() {
        os_log("Play switch sound", log: AudioPlayer.log, type: .info)
        switchSound.play()
    }
    
    func playEndSound() {
        os_log("Play end sound", log: AudioPlayer.log, type: .info)
        endSound.play()
    }
    
    // MARK: - Song controls
    func play() {
        music?.play()
    }
    
    func pause() {
        music?.pause()
    }
    
    func stop() {
        music?.pause()
        // Stopping should reset the playback queue, setting songs again is needed for that.
        if let urls = songUrlsList {
            setSongs(urls: urls)
        }
    }
}
