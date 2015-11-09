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
  
  struct Constants {
    static let timerFontName = "DBLCDTempBlack"
    static let timerFontSize: CGFloat = 130
    
    static let emptySongLabelText = "🔇 No song chosen"
    
    static let preparationDuration = 10
    static let battleDuration = 3 * 60
    static let qualificationDuration = (Int)(1.5 * 60)
    static let extraTimeDuration = 2 * 30
    
    
    static let noSongChosenNotificationTitle = "No song chosen"
    static let noSongChosenNotificationMsg = "Please choose song by using \"Pick Song\" button on navigation bar."
    
    static let updateTimeMethodName: Selector = "updateTime"
  }
  
  var timerType: String = ""
  var startTime = 0
  var battleDuration = 0
  var timePassed = 0
  var timer = NSTimer()
  var playURL: NSURL?
  
  var audioPlayer: AVAudioPlayer?
  var isPlaying = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    pauseButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    extraTimeButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    stopButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    
    titleNavigationItem.title = timerType
    initTimer(timerType)
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    } catch {
      print("music background enable error")
    }
    
    timerLabel.font = UIFont(name: Constants.timerFontName, size: Constants.timerFontSize)
    songNameLabel.text = Constants.emptySongLabelText
    
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
    case GlobalConstants.TimerTypeID.battle:
      battleDuration = Constants.battleDuration
    case GlobalConstants.TimerTypeID.qualification:
      battleDuration = Constants.qualificationDuration
    case GlobalConstants.TimerTypeID.routine:
      if audioPlayer != nil {
        battleDuration = Int((audioPlayer?.duration)!)
        //        timerLabel.text = formatTime(battleDuration)
      } else {
        battleDuration = 0
      }
    default:
      timerLabel.text = "0:00"
      startTime = 0
    }
    
    timerLabel.text = formatDurationToLabelText(battleDuration)
    
    
    //adding 10 sec preparation window
    startTime = Constants.preparationDuration
    
  }
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.Default
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
    
    let songTitle = mediaItem.valueForProperty(MPMediaItemPropertyTitle) as! String
    playURL = mediaItem.valueForProperty(MPMediaItemPropertyAssetURL) as? NSURL
    
    songNameLabel.text = "🔊 \(songTitle)"
    
    if !isPlaying && playURL != nil{
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: playURL!)
      } catch {
        print("Error while setting song url")
      }
      
    }
    
    if timerType == GlobalConstants.TimerTypeID.routine {
      battleDuration = Int((audioPlayer?.duration)!)
      timerLabel.text = formatDurationToLabelText(battleDuration)
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
    func hasTimerFinished() -> Bool {
      return timePassed == battleDuration + Constants.preparationDuration
    }
    
    func has30secondsPassed() -> Bool  {
      return (timePassed - Constants.preparationDuration) % 30 == 0
    }
    
    func hasPreparationTimeFinished() -> Bool {
      return timePassed == Constants.preparationDuration
    }
    
    func playIntervalSound() {
      switch timerType {
      case GlobalConstants.TimerTypeID.battle:
        SoundEffects.sharedInstance.playAirhornSound()
      case GlobalConstants.TimerTypeID.qualification:
        SoundEffects.sharedInstance.playBeepSound()
      default:
        break
      }
    }
    
    func startBattle() {
      startTime = battleDuration
      timerStartsInLabel.hidden = true
      if !isPlaying && playURL != nil {
        audioPlayer!.prepareToPlay()
      }
      
      if playURL != nil {
        audioPlayer!.play()
      }
    }
    
    timerLabel.text = "\(formatDurationToLabelText(--startTime))"
    timePassed++
    
    
    if hasTimerFinished() {
      if timerType != GlobalConstants.TimerTypeID.routine {
        SoundEffects.sharedInstance.playAirhornFinishSound()
      }
      
      stop(UIButton())
      
      if timerType == GlobalConstants.TimerTypeID.battle {
        extraTimeButton.hidden = false
      }
      return
    }
    
    if has30secondsPassed() {
      playIntervalSound()
    }
    
    //po 10 sek odpal muzę
    if hasPreparationTimeFinished() {
      startBattle()
    }
    
    
    
  }
  
  
  
  func formatDurationToLabelText(timeInSeconds: Int) -> String {
    if timeInSeconds < 10 {
      return "\(timeInSeconds)"
    }
    
    let minutes: Int = timeInSeconds / 60
    let seconds =     String(format: "%02d", timeInSeconds - (minutes * 60))
    
    return "\(minutes):\(seconds)"
  }
  
  // MARK: Timer functions
  
  @IBAction func play(sender: UIButton) {
    if timerType == GlobalConstants.TimerTypeID.routine && !isSongForRoutineSet() {
      notifyUserToPickSong()
      return
    }
    
    playButton.hidden = true
    pauseButton.hidden = false
    extraTimeButton.hidden = true
    self.navigationItem.rightBarButtonItem?.enabled = false
    
    if !isPlaying {
      timerStartsInLabel.hidden = false
    }
    
    
    if (!timer.valid) {
      initNSTimer()
    }
    
    if isPlaying && playURL != nil && timePassed > Constants.preparationDuration {
      audioPlayer!.play()
    }
  }
  
  func isSongForRoutineSet() -> Bool {
    return battleDuration != 0
  }
  
  func notifyUserToPickSong() {
    let alert = UIAlertController(title: Constants.noSongChosenNotificationTitle, message: Constants.noSongChosenNotificationMsg, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func initNSTimer() {
    let selector : Selector = Constants.updateTimeMethodName
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: selector, userInfo: nil, repeats: true)
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
    battleDuration = Constants.extraTimeDuration
    timerLabel.text = formatDurationToLabelText(battleDuration)
    play(UIButton())
  }
  
  func timerFinished() {
    playButton.hidden = false
    pauseButton.hidden = true
    startTime = Constants.preparationDuration
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
    initTimer(timerType)
  }
  
}
