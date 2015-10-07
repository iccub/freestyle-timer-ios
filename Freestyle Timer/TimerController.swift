//
//  TimerController.swift
//  Freestyle Timer
//
//  Created by bucci on 30.09.2015.
//  Copyright © 2015 Michał Buczek. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AudioToolbox

class TimerController: UIViewController, MPMediaPickerControllerDelegate {
  
  @IBOutlet var songNameLabel: UILabel!
  @IBOutlet var timerLabel: UILabel!
  @IBOutlet var playButton: UIButton!
  @IBOutlet var pauseButton: UIButton!
  @IBOutlet var extraTimeButton: UIButton!
  @IBOutlet var stopButton: UIButton!
  @IBOutlet var titleNavigationItem: UINavigationItem!
  @IBOutlet var timerStartsInLabel: UILabel!
  
  var timerType: String?
  var startTime = 0
  var battleDuration = 0
  var preparationTime = 10
  var timePassed = 0
  var timer = NSTimer()
  var playURL: NSURL?
  
  var audioPlayer: AVAudioPlayer?
  var isPlaying = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleNavigationItem.title = timerType!
    print("timer type: \(timerType)") //działa
    initTimer(timerType!)
    
    
    // Do any additional setup after loading the view.
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    } catch {
      print("music background enable error")
    }
    
    timerLabel.font = UIFont(name: "DBLCDTempBlack", size: 130)
    songNameLabel.text = "🔇 No song chosen"
    
  }
  

  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    if (self.isMovingFromParentViewController()) {      
      timer.invalidate()
      audioPlayer?.stop()
    }
  }
  
 
  func initTimer(timerType: String) {
    switch timerType {
    case "Battle" :
        timerLabel.text = "3:00"
      battleDuration = 3 * 60
//      battleDuration = 20 //temp
    case "Qualification" :
      timerLabel.text = "1:30"
      battleDuration = (Int)(1.5 * 60)
    case "Routine" :
      timerLabel.text = "0:00"
      if audioPlayer != nil {
        battleDuration = Int((audioPlayer?.duration)!)
        timerLabel.text = formatTime(battleDuration)
      } else {
        battleDuration = 0
      }
    default:
      timerLabel.text = "0:00"
      //5 seconds for test purposes
      startTime = 0
    }
    
    //adding 10 sec preparation window
    startTime = preparationTime
    
  }
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
  }
  
  func playSound() {
    
  }
  
  @IBAction func chooseSong(sender: UIBarButtonItem) {
    let mpMediaPicker = MPMediaPickerController()
    mpMediaPicker.showsCloudItems = false
    
    mpMediaPicker.delegate = self
    self.presentViewController(mpMediaPicker, animated: true, completion: nil)
    
  }
  
  func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
    self.dismissViewControllerAnimated(true, completion: nil)
    let mediaItem = mediaItemCollection.items[0]
    print("count: \(mediaItemCollection.count)")
    
    //    print("\(mediaItem == nil)")
//    let songArtist = mediaItem.valueForProperty(MPMediaItemPropertyArtist) as! String
    let songTitle = mediaItem.valueForProperty(MPMediaItemPropertyTitle) as! String
    
//    print("url: \(mediaItem.valueForProperty(MPMediaItemPropertyAssetURL))")
    
    playURL = mediaItem.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL
    
    songNameLabel.text = "🔊 \(songTitle)"
    
    if !isPlaying && playURL != nil{
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: playURL!)
      } catch {
        print("Błąd")
      }
      
    }
    
    if timerType == "Routine" {
      battleDuration = Int((audioPlayer?.duration)!)
      timerLabel.text = formatTime(battleDuration)
    }
    
  }
  
  func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateTime() {
    timerLabel.text = "\(formatTime(--startTime))"

    timePassed++
    

    
    if timePassed == battleDuration + preparationTime {
      if timerType != "Routine" {
        SoundEffects.sharedInstance.playAirhornFinishSound()
      }
      
      stop(UIButton())
//      timerFinished()
      
      if timerType == "Battle" {
        extraTimeButton.hidden = false
      }
      return
    }
    
    if (timePassed - preparationTime) % 30 == 0 {
      switch timerType! {
        case "Battle":
          SoundEffects.sharedInstance.playAirhornSound()
        case "Qualification":
          SoundEffects.sharedInstance.playBeepSound()
      default:
        break
      }
      
    }
    
    //po 10 sek odpal muzę
    if timePassed == preparationTime {
      startTime = battleDuration
      timerStartsInLabel.hidden = true
      if !isPlaying && playURL != nil {
          audioPlayer!.prepareToPlay()
      }
      
      if playURL != nil {
        audioPlayer!.play()
      }
    }
    
    
    
  }
  
  func formatTime(timeInSeconds: Int) -> String {
    if timeInSeconds < 10 {
      return "\(timeInSeconds)"
    }
    
    let minutes: Int = timeInSeconds / 60
    let seconds =     String(format: "%02d", timeInSeconds - (minutes * 60))

    
//    String(format: "%02d", timeInSeconds - (minutes * 60))
    
    return "\(minutes):\(seconds)"
  }
  
  // MARK: Timer functions
  
  @IBAction func play(sender: UIButton) {
    if timerType == "Routine" && battleDuration == 0 {
      
      let alert = UIAlertController(title: "No song chosen", message: "Please choose song by using \"Pick Song\" button on navigation bar.", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
      
      return
    }
    
    playButton.hidden = true
    pauseButton.hidden = false
    extraTimeButton.hidden = true
    

    
    if !isPlaying {
      timerStartsInLabel.hidden = false
    }
    
    
    
    self.navigationItem.rightBarButtonItem?.enabled = false
    
    if (!timer.valid) {
      let aSelector : Selector = "updateTime"
      timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    if isPlaying && playURL != nil && timePassed > preparationTime {
      audioPlayer!.play()
    }
  }
  
  @IBAction func pause(sender: AnyObject) {
    pauseButton.hidden = true
    playButton.hidden = false
    
    timer.invalidate()
    
    if playURL != nil && audioPlayer!.playing{
      audioPlayer!.pause()
      
    }
    isPlaying = true
    
    //otherwise it means the app was paused during preparation time
    
  }
  
  @IBAction func extraTime(sender: UIButton) {
    extraTimeButton.hidden = true
    timerLabel.text = "1:00"
    
    battleDuration = 2 * 30
    play(UIButton())
  }
  
  func timerFinished() {
    playButton.hidden = false
    pauseButton.hidden = true
    startTime = preparationTime
    timerStartsInLabel.hidden = true
    timePassed = 0
    timer.invalidate()
    extraTimeButton.hidden = true
    self.navigationItem.rightBarButtonItem?.enabled = true
    
    if audioPlayer != nil {
      audioPlayer!.pause()
      audioPlayer?.currentTime = 0
      
    }
    
    isPlaying = false
  }
  
  @IBAction func stop(sender: UIButton) {
    timerFinished()
    
    initTimer(timerType!)
  }
  
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
