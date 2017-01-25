//
//  Layout.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//
//  swiftlint:disable line_length

import Foundation
import Cartography
import UIKit

extension UIView {
  @discardableResult func addTextField(style: LabelStyleProtocol, x: CGFloat, y: CGFloat) -> UITextField {
    let textField = UITextField()
    textField.setTextFieldStyle(style)
    self.addSubview(textField)
    textField.addConstraints(x: x, y: y)
    return textField
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, x: CGFloat? = nil, alignLeft: UIView? = nil, alignRight: UIView? = nil, leftOf: UIView? = nil, rightOf: UIView? = nil, y: CGFloat, text: String = "", initialLabel: UILabel? = nil, isButton: Bool = false, maxWidth: CGFloat? = nil) -> UILabel {
    let label = UILabel.labelWithStyle(style, initialLabel: initialLabel)!
    label.text = text
    self.addSubview(label)
    if isButton {
      label.isUserInteractionEnabled = true
    }
    if maxWidth != nil {
      label.textAlignment = .center
    }
    label.addConstraints(x: x, alignLeft: alignLeft, alignRight: alignRight, leftOf: leftOf, rightOf: rightOf, y: y, w: maxWidth)
    return label
  }
  @discardableResult func addView(x: CGFloat? = nil, alignLeft: UIView? = nil, alignRight: UIView? = nil, y: CGFloat? = nil, w: CGFloat? = nil, h: CGFloat? = nil, whRatio: CGFloat? = nil, view: UIView = UIView()) -> UIView {
    self.addSubview(view)
    view.addConstraints(x: x, alignLeft: alignLeft, alignRight: alignRight, y: y, w: w, h: h, whRatio: whRatio)
    return view
  }

  @discardableResult func addTableView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> UITableView {
    let view = UITableView(frame: CGRect.zero, style: .grouped)
    self.addSubview(view)
    constrain(view) {view in
      view.centerX == view.superview!.centerX * x
      view.centerY == view.superview!.centerY * y
      view.width == view.superview!.width * w
      view.height == view.superview!.height * h
    }
    return view
  }

  @discardableResult func addButton(style: ButtonStyleProtocol, x: CGFloat, y: CGFloat, text: String, target: Any? = nil, action: Selector? = nil) -> UIButton {
    let button = FMButton(style: style)
    button.setTitle(text, for: .normal)

    self.addSubview(button)

    let root = button.rootSuperview

    constrain(button, root) {button, root in
      button.centerX == button.superview!.centerX * x
      button.centerY == button.superview!.centerY * y
      button.width == root.width * style.width
    }

    if (ButtonStyle.areEqual(style, ButtonStyle.Circle())) {
      constrain(button, root) {button, root in
        button.height == button.width
      }
    } else {
      constrain(button, root) {button, root in
        button.height == root.height * style.height
      }
    }

    if (target != nil) && (action != nil) {
      button.addTapEvent(target: target!, action: action!)
    }

    return button
  }

  @discardableResult func addButton(style: ButtonWithIconStyleProtocol, x: CGFloat, y: CGFloat, text: String, iconName: String, target: Any? = nil, action: Selector? = nil) -> UIButton {
    let button = FMButton(style: style)
    button.setLabel(text: text)
    button.setIconImage(name: iconName)

    self.addSubview(button)

    let root = button.rootSuperview

    constrain(button, root) {button, root in
      button.centerX == button.superview!.centerX * x
      button.centerY == button.superview!.centerY * y
      button.width == root.width * style.width
      button.height == root.height * style.height
    }

    if (target != nil) && (action != nil) {
      button.addTapEvent(target: target!, action: action!)
    }

    return button
  }

  @discardableResult func addImageView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat? = nil, name: String? = nil, isButton: Bool = false, color: UIColor? = nil) -> UIImageView {
    let imageView = name != nil ? UIImageView(image: UIImage(named: name!)) : UIImageView()
    if isButton {
      imageView.isUserInteractionEnabled = true
    }
    if color != nil {
      imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
      imageView.tintColor = color
    }
    self.addSubview(imageView)
    imageView.addConstraints(x: x, y: y, w: w, h: h)
    return imageView
  }

  func addConstraints(x: CGFloat? = nil, alignLeft: UIView? = nil, alignRight: UIView? = nil, leftOf: UIView? = nil, rightOf: UIView? = nil, y: CGFloat? = nil, w: CGFloat? = nil, h: CGFloat? = nil, whRatio: CGFloat? = nil) {
    if x != nil {
      constrain(self) { view in
        view.centerX == view.superview!.centerX * x!
      }
    }
    if y != nil {
      constrain(self) { view in
        view.centerY == view.superview!.centerY * y!
      }
    }
    if w != nil {
      constrain(self) { view in
        view.width == view.superview!.width * w!
      }
    }
    if h != nil {
      constrain(self) { view in
        view.height == view.superview!.height * h!
      }
    }
    if alignLeft != nil {
      constrain(self, alignLeft!) { view, left in
        view.left == left.left
      }
    }
    if alignRight != nil {
      constrain(self, alignRight!) { view, right in
        view.right == right.right
      }
    }
    if leftOf != nil {
      constrain(self, leftOf!) { view, leftOf in
        view.right == leftOf.left
      }
    }
    if rightOf != nil {
      constrain(self, rightOf!) { view, rightOf in
        view.left == rightOf.right
      }
    }
    if whRatio != nil {
      constrain(self) { view in
        view.height == view.width * whRatio!
      }
    }
  }
}
