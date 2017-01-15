//
//  Layout.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import Cartography
import UIKit

extension UIView {
  @discardableResult func addTextField(style: LabelStyleProtocol, x: CGFloat, y: CGFloat) -> UITextField {
    let textField = UITextField()
    textField.setTextFieldStyle(style)
    self.addSubview(textField)
    constrain(textField) { textField in
      textField.centerX == textField.superview!.centerX * x
      textField.centerY == textField.superview!.centerY * y
    }
    return textField
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, x: CGFloat, y: CGFloat, text: String = "", initialLabel: UILabel? = nil, isButton: Bool = false, maxWidth: CGFloat? = nil) -> UILabel {
    let label = UILabel.labelWithStyle(style, initialLabel: initialLabel)!
    label.text = text
    self.addSubview(label)
    if isButton {
      label.isUserInteractionEnabled = true
    }
    if maxWidth != nil {
      constrain(label) { label in
        label.width == label.superview!.width * maxWidth!
      }
      label.textAlignment = .center
    }
    constrain(label) { label in
      label.centerX == label.superview!.centerX * x
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, alignLeft: UIView, y: CGFloat, text: String = "") -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, alignLeft) { label, alignLeft in
      align(left: label, alignLeft)
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, alignRight: UIView, y: CGFloat, text: String = "") -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, alignRight) { label, alignRight in
      align(right: label, alignRight)
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, rightOf: UIView, y: CGFloat, text: String) -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, rightOf) { label, rightOf in
      label.left == rightOf.right
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: LabelStyleProtocol, leftOf: UIView, y: CGFloat, text: String = "", initialLabel: UILabel? = nil) -> UILabel {
    let label = UILabel.labelWithStyle(style, initialLabel: initialLabel)!
    label.text = text
    self.addSubview(label)
    constrain(label, leftOf) { label, leftOf in
      label.right == leftOf.left
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, view: UIView = UIView()) -> UIView {
    self.addSubview(view)
    constrain(view) {view in
      view.centerX == view.superview!.centerX * x
      view.centerY == view.superview!.centerY * y
      view.width == view.superview!.width * w
      view.height == view.superview!.height * h
    }
    return view
  }
  @discardableResult func addView(alignLeft: UIView, y: CGFloat, w: CGFloat, h: CGFloat) -> UIView {
    let view = UIView()
    self.addSubview(view)
    constrain(view, alignLeft) {view, alignLeft in
      align(left: view, alignLeft)
      view.centerY == view.superview!.centerY * y
      view.width == view.superview!.width * w
      view.height == view.superview!.height * h
    }
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

  @discardableResult func addImageView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat? = nil, name: String? = nil, isButton: Bool = false) -> UIImageView {
    let imageView = name != nil ? UIImageView(image: UIImage(named: name!)) : UIImageView()
    if isButton {
      imageView.isUserInteractionEnabled = true
    }
    self.addSubview(imageView)
    constrain(imageView) { imageView in
      imageView.centerX == imageView.superview!.centerX * x
      imageView.centerY == imageView.superview!.centerY * y
      imageView.width == imageView.superview!.width * w
    }
    if h != nil {
      constrain(imageView) { imageView in
        imageView.height == imageView.superview!.height * h!
      }
    }
    return imageView
  }
}
