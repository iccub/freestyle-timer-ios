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
import MediaPlayer
import os.log

extension TimerVC: MPMediaPickerControllerDelegate {
    func mediaPicker(_ picker: MPMediaPickerController, didPickMediaItems mediaCollection: MPMediaItemCollection) {
        self.dismiss(animated: true, completion: nil)
        
        guard let firstSong = mediaCollection.items.first else {
            os_log("Media collection is empty", log: TimerVC.log, type: .error)
            return
        }
        
        // Duration value is float, we don't need that kind of precision. Adding everything as Int is sufficient
        let totalDuration = mediaCollection.items.map {
            return $0.value(forProperty: MPMediaItemPropertyPlaybackDuration) as? Float ?? 0 }
            .map { return Int($0) }
            .reduce(0, +)
        
        os_log("Total media duration: %i", log: TimerVC.log, type: .debug, totalDuration)
        
        guard totalDuration >= timerMode.duration else {
            present(AlertFactory.songTooShortDialog(), animated: true, completion: nil)
            return
        }
        
        // Setting songs as URL array
        audioPlayer?.setSongs(urls: mediaCollection.items.filter { $0.assetURL != nil }
            .map { return $0.assetURL! })
        
        songNameLabel.text = setSongNameLabel(firstSong, songsCount: mediaCollection.count)
    }
    
    private func setSongNameLabel(_ firstSong: MPMediaItem, songsCount: Int) -> String {
        var musicText = ""
        if let artist = firstSong.artist {
            musicText += artist
        }
        
        // Text is 'Artist - Title' if both are provided, 'Artist' or 'Title' if not
        if let title = firstSong.title {
            musicText += musicText.count > 0 ? " - \(title)" : "\(title)"
        }
        
        // In case of multiple songs, only first one is printed, rest is shown as 'and X other/s'
        if songsCount == 2 {
            musicText += ", and 1 other"
        } else if songsCount > 2 {
            musicText += ", and \(songsCount - 1) others"
        }
        
        os_log("Music label: %@", log: TimerVC.log, type: .debug, musicText)
        return musicText
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
