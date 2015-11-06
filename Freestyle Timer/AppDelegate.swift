import UIKit




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  struct Constants {
    static let pageIndicatorColor: UIColor = UIColor(red: 43.0/255.0, green: 179.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    static let backgroundUpdateTaskIdentifier = 0
  }
  
  var window: UIWindow?
  //hack to let timer.update() run in background
  var backgroundUpdateTask: UIBackgroundTaskIdentifier = Constants.backgroundUpdateTaskIdentifier
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    customizePageViewDots()
    
    return true
  }
  
  func customizePageViewDots() {
    let pageController = UIPageControl.appearance()
    pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
    pageController.currentPageIndicatorTintColor = Constants.pageIndicatorColor
    pageController.backgroundColor = UIColor.whiteColor()
  }
  
  func applicationWillResignActive(application: UIApplication) {
    self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
      self.endBackgroundUpdateTask()
    })
  }
  
  func endBackgroundUpdateTask() {
    UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
    self.backgroundUpdateTask = UIBackgroundTaskInvalid
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    self.endBackgroundUpdateTask()
    
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
  }
  
  func applicationWillTerminate(application: UIApplication) {
    SoundEffects.sharedInstance.disposeSounds()
  }
  
  
}

