/**
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

import UIKit

let XIB_CONSTANT_NAME = "BRCountDownView"

public enum CountDownDefineAnimation {
  case slideInFromBottom
  case slideInFromLeft
  case custom
}

@IBDesignable
final public class BRCountDownView: UIControl {
  // MARK: IBOutlets, IBActions
  @IBOutlet public var hourLabel: UILabel!
  @IBOutlet public var minuteLabel: UILabel!
  @IBOutlet public var secondLabel: UILabel!
  
  public var countdownAnimationStyle: CountDownDefineAnimation = .slideInFromBottom
  
  public lazy var animateCountDown = {
    (target: UIView, duration: TimeInterval) in
    // Create a CATransition animation
    let slideUpFromBottomTransition = CATransition()
    
    // Customize the animation's properties
    slideUpFromBottomTransition.type = kCATransitionPush
    slideUpFromBottomTransition.subtype = kCATransitionFromTop
    slideUpFromBottomTransition.duration = duration
    slideUpFromBottomTransition.timingFunction =
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    slideUpFromBottomTransition.fillMode = kCAFillModeRemoved
    
    // Add the animation to the View's layer
    target.layer.add(slideUpFromBottomTransition,
                     forKey: "slideInFromBottomTransition")
  }
  
  // MARK: Properties
  public var finished: ((BRCountDownView) -> Void)?
  public var repeated: ((BRCountDownView) -> Void)?
  
  public func repeatCountDown(with seconds: Int) {
    innerTimer.invalidate()
    isTimerRunning = false
    self.resumeTapped = true
    
    self.seconds = seconds
    
    self.repeated?(self)
    
    if isTimerRunning == false {
      runTimer()
    }
  }
  
  fileprivate var innerTimer = Timer()
  fileprivate var seconds = 0
  
  fileprivate var isTimerRunning = false
  fileprivate var resumeTapped = false
  
  public var pressedAnimationDuration = 1.0
  public var unpressedAnimationDuration = 1.0
  /// public
  @IBInspectable
  public var pressedBackgroundColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  
  @IBInspectable
  public var unpressedBackgroundColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
    didSet {
      backgroundColor = unpressedBackgroundColor
    }
  }
  
  // MARK: UIControl LifeCycle APIs
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override private init(frame: CGRect) {
    super.init(frame: frame)
    initPhase(timeSeconds: seconds)
  }
  
  public required init(timeSeconds seconds: Int) {
    super.init(frame:CGRect(x: 0, y: 0, width: 1, height: 1))
    initPhase(timeSeconds: seconds)
  }
}

// MARK: API to expose publicly using Extension
public extension BRCountDownView {
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layoutMargins = UIEdgeInsets(
        top: newValue,
        left: newValue,
        bottom: newValue / 2,
        right: newValue
      )
      layer.borderWidth = newValue
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    animate(isPressed: true)
    
    if #available(iOS 10.0, *) {
      let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator.impactOccurred()
    } else {
      // Fallback on earlier versions
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    animate(isPressed: false)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    animate(isPressed: false)
  }
  
  // MARK: private
  private func animate(isPressed: Bool) {
    let (
    duration,
      backgroundColor,
        labelIsHidden
          ) = {
            isPressed
              ? (
                duration: pressedAnimationDuration,
                backgroundColor: pressedBackgroundColor,
                labelIsHidden: true
                )
              : (
                duration: unpressedAnimationDuration,
                backgroundColor: unpressedBackgroundColor,
                labelIsHidden: false
            )
        }()
    
    UIView.animate(withDuration: duration, animations: {
      self.backgroundColor = backgroundColor
      
      self.hourLabel.isHidden = labelIsHidden
      self.minuteLabel.isHidden = labelIsHidden
      self.secondLabel.isHidden = labelIsHidden
    }, completion: { animated in
      self.backgroundColor = UIColor.clear
    })
  }

  
}

// MARK: functions API
extension BRCountDownView {
  private func runTimer() {
    innerTimer = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: (#selector(self.updateTimer)),
                                      userInfo: nil,
                                      repeats: true)
    isTimerRunning = true
  }
  
  @objc private func updateTimer() {
    if seconds < 1 {
      innerTimer.invalidate()
      self.finished?(self)
    } else {
      seconds -= 1
      
      let timeTuple = tupleimeString(time:TimeInterval(seconds))
      let hourString = timeTuple.0
      let minuteString = timeTuple.1
      let secondString = timeTuple.2
      
      if let hourLabel = hourLabel {
        hourLabel.text = hourString
        if Int(minuteString)! == 59 {
          if Int(secondString)! == 59 {
            switch self.countdownAnimationStyle {
            case .slideInFromBottom:
              hourLabel.animateSlideInFromBottom(1.0)
            case .slideInFromLeft:
              hourLabel.animateSlideInFromLeft(1.0)
            case .custom:
              animateCountDown(hourLabel, 1.0)
            }
          }
        }
      }
      
      if let minuteLabel = minuteLabel {
        minuteLabel.text = minuteString
        if Int(secondString)! == 59 {
          switch self.countdownAnimationStyle {
          case .slideInFromBottom:
            minuteLabel.animateSlideInFromBottom(1.0)
          case .slideInFromLeft:
            minuteLabel.animateSlideInFromLeft(1.0)
          case .custom:
            animateCountDown(minuteLabel, 1.0)
          }
        }
      }
      
      if let secondLabel = secondLabel {
        if Int(secondString)! >= 0 {
          secondLabel.text = secondString
          switch self.countdownAnimationStyle {
          case .slideInFromBottom:
            secondLabel.animateSlideInFromBottom(1.0)
          case .slideInFromLeft:
            secondLabel.animateSlideInFromLeft(1.0)
          case .custom:
            animateCountDown(secondLabel, 1.0)
          }
        }
      }
    }
  }
  
  private func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }
  
  private func tupleimeString(time:TimeInterval) -> (String, String, String) {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    
    let hourString = String(format:"%02i", hours)
    let minuteString = String(format:"%02i", minutes)
    let secondString = String(format:"%02i", seconds)
    
    return (hourString, minuteString, secondString)
  }
  
  private func initPhase(timeSeconds seconds: Int) {
    self.backgroundColor = UIColor.white
    
    
    let podBundle = Bundle(for: self.classForCoder)
    
    if let bundleURL = podBundle.url(forResource: XIB_CONSTANT_NAME,
                                     withExtension: "bundle") {
      if let bundle = Bundle(url: bundleURL) {
        if let view = bundle.loadNibNamed(XIB_CONSTANT_NAME,
                                          owner:self,
                                          options:nil)?[0] as? UIView {
          self.initUserInteractionUnable()
          self.initCountdownData(with: seconds)
          self.initialize(countdownView: view)
          self.startCountdown()
        }
      }
    }
    let bundle = Bundle(for: BRCountDownView.self)
    if let view = bundle.loadNibNamed(XIB_CONSTANT_NAME,
                                      owner:self,
                                      options:nil)?[0] as? UIView {
      self.initUserInteractionUnable()
      self.initCountdownData(with: seconds)
      self.initialize(countdownView: view)
      self.startCountdown()
    }
  }
  
  private func initUserInteractionUnable() -> Void {
    for v in self.subviews {
      v.isUserInteractionEnabled = false
    }
    
    self.isUserInteractionEnabled = false
  }
  
  private func initCountdownData(with time: Int) -> Void {
    self.seconds = time
    let timeTuple = tupleimeString(time:TimeInterval(self.seconds))
    
    let hourString = timeTuple.0
    let minuteString = timeTuple.1
    let secondString = timeTuple.2
    
    self.hourLabel.text = hourString
    self.minuteLabel.text = minuteString
    self.secondLabel.text = secondString
  }
  
  private func initialize(countdownView view: UIView) -> Void {
    self.frame = view.frame
    self.backgroundColor = UIColor.clear
    self.addSubview(view)
  }
  
  private func startCountdown() {
    if isTimerRunning == false {
      runTimer()
    }
  }
  
  private func stopCountdown() {
    if self.resumeTapped == false {
      innerTimer.invalidate()
      isTimerRunning = false
      self.resumeTapped = true
    } else {
      runTimer()
      self.resumeTapped = false
      isTimerRunning = true
    }
  }
}

// MARK: Animations API
extension UIView {
  // Name this function in a way that makes sense to you...
  // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names.
  func animateSlideInFromBottom(_ duration: TimeInterval = 1.0,
                         completionDelegate: CAAnimationDelegate? = nil) {
    // Create a CATransition animation
    let slideUpFromBottomTransition = CATransition()
    
    // Set its callback delegate to the completionDelegate that was provided (if any)
    if let delegate: CAAnimationDelegate = completionDelegate {
      slideUpFromBottomTransition.delegate = delegate
    }
    
    // Customize the animation's properties
    slideUpFromBottomTransition.type = kCATransitionPush
    slideUpFromBottomTransition.subtype = kCATransitionFromTop
    slideUpFromBottomTransition.duration = duration
    slideUpFromBottomTransition.timingFunction =
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    slideUpFromBottomTransition.fillMode = kCAFillModeRemoved
    
    // Add the animation to the View's layer
    layer.add(slideUpFromBottomTransition,
              forKey: "slideInFromBottomTransition")
  }
  
  func animateSlideInFromLeft(_ duration: TimeInterval = 1.0,
                       completionDelegate: CAAnimationDelegate? = nil) {
    // Create a CATransition animation
    let slideInFromLeftTransition = CATransition()
    
    // Set its callback delegate to the completionDelegate that was provided (if any)
    if let delegate: CAAnimationDelegate = completionDelegate {
      slideInFromLeftTransition.delegate = delegate
    }
    
    // Customize the animation's properties
    slideInFromLeftTransition.type = kCATransitionPush
    slideInFromLeftTransition.subtype = kCATransitionFromLeft
    slideInFromLeftTransition.duration = duration
    slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    slideInFromLeftTransition.fillMode = kCAFillModeRemoved
    
    // Add the animation to the View's layer
    self.layer.add(slideInFromLeftTransition,
                   forKey: "slideInFromLeftTransition")
  }
}

