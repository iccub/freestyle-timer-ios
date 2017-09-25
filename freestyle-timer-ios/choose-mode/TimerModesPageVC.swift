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

protocol TimerTypesPageVCDelegate: class {
    func timerModeChanged(index: Int)
}

/** Holds views with timer mode types. User can swipe them to choose the timer mode he likes. */
class TimerModesPageVC: UIPageViewController {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "TimerModesPageVC")
    
    private let timerModeIDs = TimerMode.getAllStoryboardIDs()
    
    lazy var pages: [UIViewController] = {
        return addViewControllers(timerModeIDs)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        guard let firstVC = pages.first else {
            os_log("Pages array is empty, check if storyboard IDs are set", log: TimerModesPageVC.log, type: .error)
            return
        }
        
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    /** Returns an array of ViewControllers by their Storyboard IDs */
    private func addViewControllers(_ identifiers: [String]) -> [UIViewController] {
        guard let storyboard = storyboard else {
            os_log("Storyboard is nil", log: TimerModesPageVC.log, type: .fault)
            return []
        }
        
        let viewControllers = identifiers.map { return storyboard.instantiateViewController(withIdentifier: $0) }
        
        os_log("%i view controllers added", log: TimerModesPageVC.log, type: .fault, viewControllers.count)
        return viewControllers
    }
}

// MARK: - Delegates
extension TimerModesPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageVC: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: vc) else {
            os_log("Could not find index of %@ ViewController", log: TimerModesPageVC.log, type: .error, vc)
            return nil
        }
        guard currentIndex > 0 else { return nil } // Prevents circular scrolling
        
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageVC: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: vc) else {
            os_log("Could not find index of %@ ViewController", log: TimerModesPageVC.log, type: .error, vc)
            return nil
        }
        guard currentIndex < pages.count - 1 else { return nil } // Prevents circular scrolling
        
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
    
    // Updates ChooseModeVC after page VC changes
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        (parent as? TimerTypesPageVCDelegate)?.timerModeChanged(index: pages.index(of: viewControllers!.first!)!)
    }
}
