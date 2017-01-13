//
//  Popover.swift
//  Fermata
//
//  Created by jfang19 on 1/12/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import Cartography

enum PopoverSize {
  case Large
  case Small
}

class Popover: UIView {
  convenience init(size: PopoverSize) {
    self.init()
    self.backgroundColor = UIColor.air
    var w = CGFloat(), h = CGFloat()
    switch (size) {
    case .Large:
      w = 0.85
      h = 0.76
    default: break
    }
    constrain(self) {view in
      view.width == view.superview!.width * w
      view.height == view.superview!.height * h
    }
  }

  override func layoutSubviews() {
    self.layer.cornerRadius = frame.height / 3.0
  }

}
