//
//  Buttons.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonStyleProtocol {
  var width: CGFloat { get }
  var height: CGFloat { get }
  var labelStyle: LabelStyleProtocol { get }
}

struct ButtonStyle {
  struct Medium: ButtonStyleProtocol {
    internal let width: CGFloat = 0.53
    internal let height: CGFloat = 0.06
    internal let labelStyle: LabelStyleProtocol = LabelStyle.Body.Primary()
  }
  struct Long: ButtonStyleProtocol {
    internal let width: CGFloat = 0.75
    internal let height: CGFloat = 0.06
    internal let labelStyle: LabelStyleProtocol = LabelStyle.Body.Primary()
  }
  struct Circle: ButtonStyleProtocol {
    internal let width: CGFloat = 0.37
    internal let height: CGFloat = 0
    internal let labelStyle: LabelStyleProtocol = LabelStyle.HeaderOne.Primary()
  }
  static func areEqual(_ a: ButtonStyleProtocol, _ b: ButtonStyleProtocol) -> Bool {
    return (
      a.height == b.height &&
      a.width == b.width &&
      LabelStyle.areEqual(a.labelStyle, b.labelStyle)
    )
  }
}

extension UIButton {
  static func buttonWithStyle(_ style: ButtonStyleProtocol) -> UIButton? {
    let button = FMButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "Rubik-\(style.labelStyle.weight)", size: style.labelStyle.size)
    button.setTitleColor(style.labelStyle.color, for: .normal)
    return button
  }
}

class FMButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()

    backgroundColor = UIColor.clear
    layer.borderWidth = 2.0
    layer.borderColor = UIColor.charcoal.cgColor
    layer.cornerRadius = frame.height / 2.0
  }
}
