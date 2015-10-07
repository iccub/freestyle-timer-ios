//
//  SoundEffects.swift
//  Freestyle Timer
//
//  Created by bucci on 02.10.2015.
//  Copyright © 2015 Michał Buczek. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class SoundEffects {
  var airhornSound: SystemSoundID = 0
  var airhornFinishSound: SystemSoundID = 1
  var beep: SystemSoundID = 2
  
  static let sharedInstance = SoundEffects()
  
  private init() {
    initSounds()
  }

  func initSounds() {
    if let soundURL = NSBundle.mainBundle().URLForResource("airhorn", withExtension: "mp3") {
      AudioServicesCreateSystemSoundID(soundURL, &airhornSound)
    }
    if let soundURL = NSBundle.mainBundle().URLForResource("airhorn_finish", withExtension: "mp3") {
      AudioServicesCreateSystemSoundID(soundURL, &airhornFinishSound)
    }
    if let soundURL = NSBundle.mainBundle().URLForResource("beep2", withExtension: "mp3") {
      AudioServicesCreateSystemSoundID(soundURL, &beep)
    }
  }
  
  func playAirhornSound() {
    AudioServicesPlaySystemSound(airhornSound);
  }
  
  func playAirhornFinishSound() {
    AudioServicesPlaySystemSound(airhornFinishSound);
  }
  
  func playBeepSound() {
    AudioServicesPlaySystemSound(beep);
  }
  
  func disposeSounds() {
    AudioServicesDisposeSystemSoundID(airhornSound)
    AudioServicesDisposeSystemSoundID(airhornFinishSound)
    AudioServicesDisposeSystemSoundID(beep)
  }
  
}