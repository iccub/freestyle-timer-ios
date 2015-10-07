//
//  ViewController.swift
//  Freestyle Timer
//
//  Created by bucci on 25.09.2015.
//  Copyright © 2015 Michał Buczek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
  
  var pageViewController: UIPageViewController!
  var pageTitles: NSArray!
  var pageImages: NSArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pageTitles = NSArray(objects: "Battle", "Qualification", "Routine")
    self.pageImages = NSArray(objects: "battle", "qualification", "routine")
    
    self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
    self.pageViewController.dataSource = self
    
    let startVC = self.viewControllerAtIndex(0) as PageItemController
    let viewControllers = NSArray(object: startVC)
    
    self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
    
    self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
    
    self.addChildViewController(self.pageViewController)
    self.view.addSubview(self.pageViewController.view)
    self.pageViewController.didMoveToParentViewController(self)
    
    self.navigationController?.navigationBar.barStyle = UIBarStyle.Black //rozwiązuje problem różnokolorowych status barów

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func viewControllerAtIndex(index: Int) -> PageItemController {
    if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
      return PageItemController()
    }
    
    let vc: PageItemController = self.storyboard?.instantiateViewControllerWithIdentifier("PageItemController") as! PageItemController
    
    vc.imageFile = self.pageImages[index] as! String
    vc.titleText = self.pageTitles[index] as! String
    vc.pageIndex = index
    
    return vc
    
    
  }
  

  
  // MARK: - Page View Controller Data Source
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
    let vc = viewController as! PageItemController
    var index = vc.pageIndex as Int
    
    
    if (index == 0 || index == NSNotFound) {
      return nil
      
    }
    
    index--
    return self.viewControllerAtIndex(index)
    
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
    let vc = viewController as! PageItemController
    var index = vc.pageIndex as Int
    
    if (index == NSNotFound) {
      return nil
    }
    
    index++
    
    if (index == self.pageTitles.count)    {
      return nil
    }
    
    return self.viewControllerAtIndex(index)
    
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return self.pageTitles.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
}

