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

struct LabelStyle {
  struct Large {
    static let Primary: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 37,
      "weight": FontWeight.Regular
    ]
    static let Emphasis: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 37,
      "weight": FontWeight.Medium
    ]
  }

  struct HeaderOne {
    static let Primary: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 28,
      "weight": FontWeight.Regular
    ]
    static let Emphasis: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 28,
      "weight": FontWeight.Medium
    ]
  }
  struct HeaderTwo {
    static let Primary: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 21,
      "weight": FontWeight.Regular
    ]
    static let Emphasis: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 21,
      "weight": FontWeight.Medium
    ]
  }
  struct HeaderThree {
    static let Subtle: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 17,
      "weight": FontWeight.Light
    ]
  }
  struct Body {
    static let Primary: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 17,
      "weight": FontWeight.Regular
    ]
    static let Emphasis: [String:Any] = [
      "color": UIColor.charcoal,
      "size": 17,
      "weight": FontWeight.Medium
    ]
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

  static func labelWithStyle(_ style: [String:Any], initialLabel: UILabel? = nil) -> UILabel? {
    let label = initialLabel ?? UILabel()
    guard let color = style["color"] as? UIColor else {
      return nil
    }
    guard let weight = style["weight"] as? FontWeight else {
      return nil
    }

    guard let size = style["size"] as? Int else {
      return nil
    }
    label.textColor = color
    label.font = UIFont(name: "Rubik-\(weight)", size: CGFloat(size))
    return label
  }

  func setLabelStyle(_ style: [String:Any]) {
    guard let color = style["color"] as? UIColor else {
      return
    }
    guard let weight = style["weight"] as? FontWeight else {
      return
    }

    guard let size = style["size"] as? Int else {
      return
    }
    self.textColor = color
    self.font = UIFont(name: "Rubik-\(weight)", size: CGFloat(size))
  }
}

extension UITextField {
  func setTextFieldStyle(_ style: [String:Any]) {
    guard let color = style["color"] as? UIColor else {
      return
    }
    guard let weight = style["weight"] as? FontWeight else {
      return
    }

    guard let size = style["size"] as? Int else {
      return
    }
    self.textColor = color
    self.font = UIFont(name: "Rubik-\(weight)", size: CGFloat(size))
  }
}
