//
//  ViewController.swift
//  BRCountDownLabel
//
//  Created by Seoksoon Jang on 2017. 10. 11..
//  Copyright © 2017년 Seoksoon Jang. All rights reserved.
//

import UIKit
import BRCountDownView

class ViewController: UIViewController {
  @IBOutlet var checkTestLabel: UILabel!
  
  // self.countdownView.stop()
  @IBAction func resume(_ sender: Any) {
    self.countdownView.resume()
  }
  
  @IBAction func stop(_ sender: Any) {
    self.countdownView.stop()
  }
  
  @IBAction func terminate(_ sender: Any) {
    self.countdownView.terminate()
  }
  
  @IBAction func repeatAction(_ sender: Any) {
    self.countdownView.repeatCountDown(in: 100)
  }
  
  lazy var countdownView: BRCountDownView = {
    let countdownView = BRCountDownView(timeSeconds: /* 30000 */ 5)
    countdownView.animationStyle = .slideInFromBottom
    
    /** you can make animate that you would like to perform in this closure if you would.
        To do this, you should change animationStyle property to 'true'.
     */
//    countdownView.animationStyle = .custom
//    countdownView.customAnimation = {
//      [unowned self] animateView, duration in
//      UIView.animate(withDuration: duration, animations: {
//        animateView.alpha = 0.0
//      }, completion:{ finished in
//        if finished {
//          animateView.alpha = 1.0
//        }
//      })
//    }

    countdownView.didFinish = {
      [unowned self] (countdownView) -> Void in
      
      DispatchQueue.main.async {
        self.checkTestLabel.text = "countdown is finished..."
      }
      
      /** you can again repeat countdown with seconds you want whenever you want. */
      // self.countdownView.repeatCountDown(in: 5)
    }

    countdownView.didRepeat = {
      [unowned self] (countdownView) -> Void in
      // it is fired when count-down repeat gets started.
      DispatchQueue.main.async {
        self.checkTestLabel.text = "countdown is repeated..."
      }
    }
    
    countdownView.didResume = {
      [unowned self] (countdownView) -> Void in
      /**
       do any task here if you need.
       */
      print("didResume!")
    }
    
    countdownView.didTerminate = {
      [unowned self] (countdownView) -> Void in
      /**
       do any task here if you need.
       */
      print("didTerminate!")
    }
    
    countdownView.didStop = {
      [unowned self] (countdownView) -> Void in
      /**
       do any task here if you need.
       */
      print("didStop!")
    }

    countdownView.isUserInteractionEnabled = true
    countdownView.didTouchBegin = {
      [unowned self] sender in
      print("didTouchBegin!?")
    }
    
    countdownView.didTouchEnd = {
      [unowned self] sender in
      print("didTouchEnd!?")
    }
    
    return countdownView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkTestLabel.text = "countdown is doing the job..."
    
    self.view.addSubview(countdownView)
    
    // get center.
    countdownView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
