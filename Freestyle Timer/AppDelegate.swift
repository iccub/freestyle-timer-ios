//
//  AppDelegate.swift
//  Freestyle Timer
//
//  Created by bucci on 25.09.2015.
//  Copyright © 2015 Michał Buczek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  //let timer.update() run in background hack
  var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    
    //pageview "dots" customization
    let pageController = UIPageControl.appearance()
    pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
    pageController.currentPageIndicatorTintColor = UIColor.blackColor()
    pageController.backgroundColor = UIColor.whiteColor()
    
    
    
//    UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
//    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
//

    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
      self.endBackgroundUpdateTask()
    })
  }
  
  func endBackgroundUpdateTask() {
    UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
    self.backgroundUpdateTask = UIBackgroundTaskInvalid
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.endBackgroundUpdateTask()

  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    SoundEffects.sharedInstance.disposeSounds()
  }


}

