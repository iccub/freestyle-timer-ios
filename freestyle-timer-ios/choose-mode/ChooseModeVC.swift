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
import os.log

/**
 First app screen that allows user to choose timer mode or open settings. This ViewController embeds a page VC
 for swipe gestures to choose the right timer mode.
 */
class ChooseModeVC: UIViewController {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "ChooseModeVC")
    
    // MARK: - IBOutlets
    @IBOutlet weak var timerModesPageControl: UIPageControl!
    @IBOutlet weak var timerModeContainerView: UIView!
    
    var currentTimerModePageIndex = 0 {
        didSet {
            timerModesPageControl.currentPage = currentTimerModePageIndex
            view.backgroundColor = TimerMode.backgroundColor(for: currentTimerModePageIndex)
        }
    }
    
    weak var timerModeChangedDelegate: TimerTypesPageVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        timerModeChangedDelegate = self
        
        // Proceeding to a timer screen can be done by either clicking on select button or container view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChooseModeVC.timerModeTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        timerModeContainerView.addGestureRecognizer(tapGesture)
        timerModeContainerView.isUserInteractionEnabled = true
        
        currentTimerModePageIndex = 0
    }
    
    // MARK: - Segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTimerVC" {
            guard let vc = segue.destination as? TimerVC else {
                os_log("Destination segue is not of TimerVC type", log: ChooseModeVC.log, type: .error)
                return
            }
            let selectedTimerMode = TimerMode.timerMode(for: currentTimerModePageIndex)
            
            vc.timerMode = selectedTimerMode
            os_log("%@ timer mode was chosen", log: ChooseModeVC.log, type: .debug, selectedTimerMode.title)
        }
    }
    
    @objc func timerModeTapped() {
        performSegue(withIdentifier: "gotoTimerVC", sender: nil)
    }
}

// MARK: - Delegates
extension ChooseModeVC: TimerTypesPageVCDelegate {
    func timerModeChanged(index: Int) {
        guard currentTimerModePageIndex != index else {
            return
        }
        currentTimerModePageIndex = index
    }
}
