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

class TimerVC: UIViewController {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "TimerVC")
    
    // MARK: - IBOutlets
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: BorderedButton!
    @IBOutlet weak var pauseButton: BorderedButton!
    @IBOutlet weak var extraRoundButton: BorderedButton!
    @IBOutlet weak var stopButton: BorderedButton!
    @IBOutlet weak var timerTooltipLabel: UILabel!
    @IBOutlet weak var chooseSongButton: UIBarButtonItem!
    
    // MARK: - prepareForSegue properties
    
    var timerMode: TimerMode!
    
    // MARK: - variables
    /** Main timer of the app */
    var timer: Timer?
    
    /** Keeps track of how much time left. */
    var timeLeft = 0 {
        didSet {
            timerLabel.text = timeLeft.secondsToTime()
            
            // Timer has finished
            guard timeLeft > 0 else {
                timerState = .finished
                audioPlayer?.playEndSound()
                os_log("Timer finished", log: TimerVC.log)
                return
            }
            
            guard let timer = timer else {
                os_log("Timer is nil", log: TimerVC.log, type: .debug)
                return
            }
            
            // Playing switch sound every interval.
            if timeLeft % timerMode.soundInterval == 0 && timer.isValid {
                audioPlayer?.playSwitchSound()
            }
        }
    }
    
    /** For preparation time, separate timer is used. */
    var preparationTimer: Timer?
    
    /** Keeps track of how much preparation time left. */
    var preparationTimeLeft = 0 {
        didSet {
            timerLabel.text = preparationTimeLeft.secondsToTime()
            
            if preparationTimeLeft == 0 {
                preparationTimer?.invalidate()

                // Preparation timer is called in two cases: on first timer run or after extra time is chosen
                timerState = .running
                
                timerLabel.text = timeLeft.secondsToTime()
                
                // First switch sound is played after preparation time because main timer has not started yet
                audioPlayer?.playSwitchSound()
                endBackgroundTask()
            }
        }
    }
    
    // MARK: - Background task handling
    
    /** Background task is needed for preparation timer, when sound is not playing(for cases when sound is playing,
     audio background playback mode is used). After preparation timer finished, this task is no longer needed. */
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    func registerBackgroundTask() {
        os_log("Background task registered", log: TimerVC.log, type: .debug)
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        if backgroundTask != UIBackgroundTaskInvalid {
            os_log("Background task ended", log: TimerVC.log, type: .debug)
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }
    }
    
    /** Controls music and interval sounds */
    var audioPlayer: AudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = timerMode?.backgroundColor
        navigationItem.title = timerMode?.title
        
        timerState = .resetted
        
        do {
            audioPlayer = try AudioPlayer(timerMode: timerMode)
        } catch {
            os_log("Failed to initialize AudioPlayer", log: TimerVC.log, type: .error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            timerState = .resetted
        }
    }
    
    // MARK: - IB Actions
    @IBAction func playTapped(_ sender: BorderedButton) {
        os_log("playTapped", log: TimerVC.log, type: .debug)
        // Timer doesn't work when no music is set
        guard let player = audioPlayer, player.isMusicSet() else {
            os_log("No music was chosen", log: TimerVC.log, type: .info)
            present(AlertFactory.noSongChosenDialog(), animated: true, completion: nil)
            return
        }
        
        // Play button can be tapped with in one of 3 timer states:
        // - timer paused
        // - initial state/timer resetted
        // - timer finished
        // Last two cases should behave the same
        
        if timerState == .paused {
            timerState = .running
        } else {
            timeLeft = timerMode.duration
            timerState = .preparation
        }
    }
    
    @IBAction func extraRoundTapped(_ sender: BorderedButton) {
        os_log("extraRoundTapped", log: TimerVC.log, type: .debug)
        timeLeft = timerMode.extraTimeDuration
        timerState = .preparation
    }
    
    @IBAction func pauseTapped(_ sender: BorderedButton) {
        os_log("pauseTapped", log: TimerVC.log, type: .debug)
        timerState = .paused
    }
    
    @IBAction func stopTapped(_ sender: BorderedButton) {
        os_log("stopTapped", log: TimerVC.log, type: .debug)
        timerState = .resetted
    }
    
    @IBAction func chooseSongTapped(_ sender: UIBarButtonItem) {
        os_log("chooseSongTapped", log: TimerVC.log, type: .info)
        self.present(SongMediaPickerVC(delegate: self), animated: true, completion: nil)
    }
    
    // MARK: - App state management
    /** Helps maintaining app timer state. When state is changed, ui, audio and timer logic are changed accordingly */
    enum TimerState {
        /** Starts main timer. Called after preparation timer ends. */
        case running
        /** Pauses timer. Called from `running` state */
        case paused
        /** Resets whole timer, also this is initial timer state. */
        case resetted
        /** Called after `running` state finishes. Resets timers similar to `resetted` state,
         but also shows extra time button if in battle mode */
        case finished
        /** Starts preparation timer, `running` state is called after preparation ends. */
        case preparation
    }
    
    /** Handles app logic after `timerState` changes */
    var timerState: TimerState? = nil {
        didSet {
            guard let state = timerState else {
                os_log("Timer state is nil", log: TimerVC.log, type: .error)
                return
            }
            updateUI(for: state)
            
            switch state {
            case .running:
                os_log("Timer state: .running", log: TimerVC.log, type: .debug)
                timer = fireTimer()
                audioPlayer?.play()
                break
            case .paused:
                os_log("Timer state: .paused", log: TimerVC.log, type: .debug)
                timer?.invalidate()
                audioPlayer?.pause()
                break
            case .resetted, .finished:
                os_log("Timer state: .resetted/.finished", log: TimerVC.log, type: .debug)
                timer?.invalidate()
                timeLeft = timerMode.duration
                preparationTimer?.invalidate()
                audioPlayer?.stop()
                break
            case .preparation:
                os_log("Timer state: .preparation ", log: TimerVC.log, type: .debug)
                preparationTimeLeft = timerMode.preparationDuration
                registerBackgroundTask()
                preparationTimer = firePreparationTimer()
                break
            }
        }
    }
    
    private func updateUI(for state: TimerState) {
        switch state {
        case .resetted, .paused:
            playButton.isHidden = false
            pauseButton.isHidden = true
            extraRoundButton.isHidden = true
            timerTooltipLabel.isHidden = true
            playButton.isEnabled = true
            if state == .resetted {
                chooseSongButton.isEnabled = true
            }
            break
        case .running:
            playButton.isHidden = true
            playButton.isEnabled = true
            pauseButton.isHidden = false
            extraRoundButton.isHidden = true
            timerTooltipLabel.isHidden = true
            chooseSongButton.isEnabled = false
            break
        case .finished:
            playButton.isHidden = false
            pauseButton.isHidden = true
            if timerMode == .battle {
                extraRoundButton.isHidden = false
            }
            timerTooltipLabel.isHidden = false
            chooseSongButton.isEnabled = true
            timerTooltipLabel.text = "Timer has finished."
            break
        case .preparation:
            playButton.isEnabled = false
            extraRoundButton.isHidden = true
            timerTooltipLabel.isHidden = false
            chooseSongButton.isEnabled = false
            timerTooltipLabel.text = "Timer will start in"
            break
        }
    }
    
    // MARK: - Timer methods
    // Main and preparation timers are kept separate.
    private func fireTimer() -> Timer {
        return TickTimer.fire(selector: #selector(TimerVC.updateTimer), target: self)
    }
    
    private func firePreparationTimer() -> Timer {
        return TickTimer.fire(selector: #selector(TimerVC.updatePreparationTimer), target: self)
    }
    
    @objc func updateTimer() {
        timeLeft -= TickTimer.tickInterval
    }
    
    @objc func updatePreparationTimer() {
        preparationTimeLeft -= TickTimer.tickInterval
    }
}
