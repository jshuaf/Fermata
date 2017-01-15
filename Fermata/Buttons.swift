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

protocol ButtonWithIconStyleProtocol: ButtonStyleProtocol {
  var labelWidth: CGFloat { get }
  var labelX: CGFloat { get }
  var iconWidth: CGFloat { get }
  var iconX: CGFloat { get }
}

struct ButtonStyle {
  struct Medium: ButtonStyleProtocol {
    internal let width: CGFloat = 0.53
    internal let height: CGFloat = 0.07
    internal let labelStyle: LabelStyleProtocol = LabelStyle.Body.Primary()
  }
  struct Long: ButtonStyleProtocol {
    internal let width: CGFloat = 0.75
    internal let height: CGFloat = 0.07
    internal let labelStyle: LabelStyleProtocol = LabelStyle.Body.Primary()
  }
  struct Circle: ButtonStyleProtocol {
    internal let width: CGFloat = 0.37
    internal let height: CGFloat = 0
    internal let labelStyle: LabelStyleProtocol = LabelStyle.HeaderOne.Primary()
  }
  struct MediumIcon: ButtonWithIconStyleProtocol {
    internal let width: CGFloat = 0.53
    internal let height: CGFloat = 0.07
    internal let labelStyle: LabelStyleProtocol = LabelStyle.Body.Primary()
    internal let labelWidth: CGFloat = 0.59
    internal let labelX: CGFloat = 0.81
    internal let iconWidth: CGFloat = 0.12
    internal let iconX: CGFloat = 1.52

  }
  static func areEqual(_ a: ButtonStyleProtocol, _ b: ButtonStyleProtocol) -> Bool {
    return (
      a.height == b.height &&
      a.width == b.width &&
      LabelStyle.areEqual(a.labelStyle, b.labelStyle)
    )
  }
}

class FMButton: UIButton {
  internal var label: UILabel?
  internal var iconView: UIImageView?

  convenience init(type buttonType: UIButtonType) {
    self.init()
    backgroundColor = UIColor.clear
    layer.borderWidth = 2.0
    layer.borderColor = UIColor.charcoal.cgColor
  }

  convenience init(style: ButtonStyleProtocol) {
    self.init(type: .custom)
    titleLabel?.font = UIFont(name: "Rubik-\(style.labelStyle.weight)", size: style.labelStyle.size)
    setTitleColor(style.labelStyle.color, for: .normal)
  }

  convenience init(style: ButtonWithIconStyleProtocol) {
    self.init(type: .custom)
    label = addLabel(style: style.labelStyle, x: style.labelX, y: 1, maxWidth: style.labelWidth)
    iconView = addImageView(x: style.iconX, y: 1, w: style.iconWidth)
  }

  internal override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2.0
  }

  internal func setIconImage(name: String) {
    iconView?.image = UIImage(named: name)
    iconView?.contentMode = .scaleAspectFit
  }

  internal func setLabel(text: String) {
    label?.text = text
  }
}
