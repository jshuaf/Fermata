//
//  UIView.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
  @IBInspectable var borderColor: UIColor? {
    set {
      layer.borderColor = newValue!.cgColor
    }
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor:color)
      } else {
        return nil
      }
    }
  }
  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }
  @IBInspectable var cornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
      clipsToBounds = newValue > 0
    }
    get {
      return layer.cornerRadius
    }
  }
}

extension UIView {
  var rootSuperview: UIView {
    get {
      var currentView = self
      while currentView.superview != nil {
        currentView = currentView.superview!
      }
      return currentView
    }
  }
  func addTapEvent(target: Any?, action: Selector) {
    let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
    self.addGestureRecognizer(gestureRecognizer)
  }
}
