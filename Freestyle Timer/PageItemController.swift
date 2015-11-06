import UIKit

class PageItemController: UIViewController {
  struct Constants {
    static let segueID = "gotoTimer" //must be the same as storyboard ID
  }
  
  var pageIndex: Int!
  var titleText: String!
  var imageFile: String!
  
  
  @IBOutlet var modeLabel: UILabel!
  @IBOutlet var contentImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.contentImageView.image = UIImage(named: self.imageFile)
    self.modeLabel.text = self.titleText
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func tapAction(sender: UITapGestureRecognizer) {
    performSegueWithIdentifier(Constants.segueID, sender: sender)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == Constants.segueID {
      if let timerController = segue.destinationViewController as? TimerController {
        timerController.timerType = titleText
      }
    }
  }
  
}
