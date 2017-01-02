//
//  Buttons.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

struct ButtonStyle {
  static let Long: [String:Any] = [
    "width": 0.75,
    "height": 0.06,
    "labelStyle": LabelStyle.Body.Primary
  ]
}

extension UIButton {
  static func buttonWithStyle(_ style: [String:Any]) -> UIButton? {
    guard let labelStyle = style["labelStyle"] as? [String:Any] else {
      return nil
    }
    guard let color = labelStyle["color"] as? UIColor else {
      return nil
    }
    guard let weight = labelStyle["weight"] as? FontWeight else {
      return nil
    }
    guard let size = labelStyle["size"] as? Int else {
      return nil
    }
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont(name: "Rubik-\(weight)", size: CGFloat(size))
    button.setTitleColor(color, for: .normal)

    button.backgroundColor = UIColor.clear
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.charcoal.cgColor
    return button
  }
}
