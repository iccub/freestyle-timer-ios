//
//  PageItemController.swift
//  Freestyle Timer
//
//  Created by bucci on 25.09.2015.
//  Copyright © 2015 Michał Buczek. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
  
  var pageIndex: Int!
  var titleText: String!
  var imageFile: String!
  

  @IBOutlet var modeLabel: UILabel!
  @IBOutlet var contentImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.contentImageView.image = UIImage(named: self.imageFile)
      self.modeLabel.text = self.titleText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  @IBAction func tapAction(sender: UITapGestureRecognizer) {
    print(pageIndex)
    //po page index lub title text moge odpowiednio segue dac
    performSegueWithIdentifier("gotoTimer", sender: sender)
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "gotoTimer" {
      if let timerController = segue.destinationViewController as? TimerController {
        timerController.timerType = titleText
      }
    }
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
