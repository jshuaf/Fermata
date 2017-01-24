//
//  Typography.swift
//  Fermata
//
//  Created by jfang19 on 12/19/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

enum FontWeight: String {
  case Regular = "Regular"
  case Bold = "Bold"
  case Medium = "Medium"
  case Black = "Black"
  case Heavy = "Heavy"
  case Light = "Light"
  case Thin = "Thin"
}

protocol LabelStyleProtocol {
  var color: UIColor { get }
  var size: CGFloat { get }
  var weight: FontWeight { get }
}

struct LabelStyle {
  struct Massive {
    struct Primary: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 49
      internal let weight = FontWeight.Regular
    }
    struct Emphasis: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 49
      internal let weight = FontWeight.Medium
    }
  }
  struct Large {
    struct Primary: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 37
      internal let weight = FontWeight.Regular
    }
    struct Emphasis: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 37
      internal let weight = FontWeight.Medium
    }

  }
  struct HeaderOne {
    struct Primary: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 28
      internal let weight = FontWeight.Regular
    }
    struct Emphasis: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 28
      internal let weight = FontWeight.Medium
    }
  }
  struct HeaderTwo {
    struct Primary: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 21
      internal let weight = FontWeight.Regular
    }
    struct Emphasis: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 21
      internal let weight = FontWeight.Medium
    }
  }
  struct HeaderThree {
    struct Subtle: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 17
      internal let weight = FontWeight.Light
    }
  }
  struct Body {
    struct Primary: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 17
      internal let weight = FontWeight.Regular
    }
    struct Emphasis: LabelStyleProtocol {
      internal let color = UIColor.charcoal
      internal let size: CGFloat = 17
      internal let weight = FontWeight.Medium
    }
  }
  struct Detail {
    struct Light: LabelStyleProtocol {
      internal let color = UIColor.white
      internal let size: CGFloat = 13
      internal let weight = FontWeight.Regular
    }
  }
  static func areEqual(_ a: LabelStyleProtocol, _ b: LabelStyleProtocol) -> Bool {
    return (
      a.color == b.color &&
      a.size == b.size &&
      a.weight == b.weight
    )
  }
}

extension UILabel {
  var fontWeight: FontWeight {
    get {
      return FontWeight(rawValue: self.font.fontName.components(separatedBy: "-")[1])!
    }
  }

  func setFontWeight(_ weight: FontWeight) {
    self.font = UIFont(name: "\(self.font.familyName)-\(weight)", size: self.font.pointSize)
  }

  static func labelWithStyle(_ style: LabelStyleProtocol, initialLabel: UILabel? = nil) -> UILabel? {
    let label = initialLabel ?? UILabel()
    label.textColor = style.color
    label.font = UIFont(name: "Rubik-\(style.weight)", size: style.size)
    return label
  }

  func setLabelStyle(_ style: LabelStyleProtocol) {
    self.textColor = style.color
    self.font = UIFont(name: "Rubik-\(style.weight)", size: style.size)
  }
}

extension UITextField {
  func setTextFieldStyle(_ style: LabelStyleProtocol) {
    self.textColor = style.color
    self.font = UIFont(name: "Rubik-\(style.weight)", size: style.size)
  }
}

extension UIFont {
  var textAttribute: [AnyHashable: Any] {
    get {
      return [ NSFontAttributeName: self ]
    }
  }
  static func fontWithStyle(_ style: LabelStyleProtocol) -> UIFont {
    return UIFont(name: "Rubik-\(style.weight)", size: style.size)!
  }
}
