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

  lazy var countdownView: BRCountDownView = {
    let countdownView = BRCountDownView(timeSeconds: /* 30000 */ 5)
    countdownView.animationStyle = .slideInFromBottom
    
    countdownView.isUserInteractionEnabled = true
    for subview in countdownView.subviews {
      subview.isUserInteractionEnabled = true
    }
    
    countdownView.finished = {
      [unowned self] (countdownView) -> Void in
      
      DispatchQueue.main.async {
        self.checkTestLabel.text = "countdown is finished..."
      }
      self.countdownView.repeatCountDown(in: 5)
    }
    
    countdownView.repeated = {
      [unowned self] (countdownView) -> Void in
      
      DispatchQueue.main.async {
        self.checkTestLabel.text = "countdown is repeated..."
      }
    }
    
    return countdownView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.gray
    checkTestLabel.text = "countdown is doing the job..."
    
    self.view.addSubview(countdownView)
    countdownView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)

    countdownView.addTarget(self,
                            action: #selector(ViewController.countdownClicked(_:)),
                            for: .touchUpInside)
 
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc func countdownClicked(_ sender: Any) -> Void {
    print("countdownClicked!!")
  }
}
