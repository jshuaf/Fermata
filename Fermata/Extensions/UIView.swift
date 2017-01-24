//
//  UIView.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  internal var rootSuperview: UIView {
    get {
      var currentView = self
      while currentView.superview != nil {
        currentView = currentView.superview!
      }
      return currentView
    }
  }
  internal func addTapEvent(target: Any?, action: Selector) {
    let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
    self.addGestureRecognizer(gestureRecognizer)
  }
  internal func addGradient(_ colors: [UIColor]) {
    let backgroundGradient = colors.gradient()
    backgroundGradient.frame = self.bounds
    self.layer.insertSublayer(backgroundGradient, at: 0)
  }
}
