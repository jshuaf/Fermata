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
  private var size: PopoverSize

  init(size: PopoverSize) {
    self.size = size
    super.init(frame: .zero)
    self.backgroundColor = UIColor.air
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    self.layer.cornerRadius = frame.width / 8.0
    var w = CGFloat(), h = CGFloat()
    switch size {
    case .Large:
      w = 0.85
      h = 0.76
    default: break
    }
    constrain(self) {view in
      view.width == view.superview!.width * w
      view.height == view.superview!.height * h
      view.centerX == view.superview!.centerX
      view.centerY == view.superview!.centerY
    }

  }

}
