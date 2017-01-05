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
  @discardableResult func addTextField(style: [String:Any], x: CGFloat, y: CGFloat) -> UITextField {
    let textField = UITextField()
    textField.setTextFieldStyle(LabelStyle.Body.Primary)
    self.addSubview(textField)
    constrain(textField) { textField in
      textField.centerX == textField.superview!.centerX * x
      textField.centerY == textField.superview!.centerY * y
    }
    return textField
  }
  @discardableResult func addLabel(style: [String:Any], x: CGFloat, y: CGFloat, text: String = "", initialLabel: UILabel? = nil) -> UILabel {
    let label = UILabel.labelWithStyle(style, initialLabel: initialLabel)!
    label.text = text
    self.addSubview(label)
    constrain(label) { label in
      label.centerX == label.superview!.centerX * x
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: [String:Any], alignLeft: UIView, y: CGFloat, text: String = "") -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, alignLeft) { label, alignLeft in
      align(left: label, alignLeft)
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: [String:Any], alignRight: UIView, y: CGFloat, text: String = "") -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, alignRight) { label, alignRight in
      align(right: label, alignRight)
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: [String:Any], rightOf: UIView, y: CGFloat, text: String) -> UILabel {
    let label = UILabel.labelWithStyle(style)!
    label.text = text
    self.addSubview(label)
    constrain(label, rightOf) { label, rightOf in
      label.left == rightOf.right
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addLabel(style: [String:Any], leftOf: UIView, y: CGFloat, text: String = "", initialLabel: UILabel? = nil) -> UILabel {
    let label = UILabel.labelWithStyle(style, initialLabel: initialLabel)!
    label.text = text
    self.addSubview(label)
    constrain(label, leftOf) { label, leftOf in
      label.right == leftOf.left
      label.centerY == label.superview!.centerY * y
    }
    return label
  }
  @discardableResult func addView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> UIView {
    let view = UIView()
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

  @discardableResult func addButton(style: [String:Any], x: CGFloat, y: CGFloat, text: String) -> UIButton {
    let button = UIButton.buttonWithStyle(style)!
    button.setTitle(text, for: .normal)

    self.addSubview(button)

    guard let w = style["width"] as? Double else {
      return button
    }
    guard let h = style["height"] as? Double else {
      return button
    }
    constrain(button) {button in
      button.centerX == button.superview!.centerX * x
      button.centerY == button.superview!.centerY * y
      button.width == button.superview!.width * CGFloat(w)
      button.height == button.superview!.height * CGFloat(h)
    }
    button.layer.cornerRadius = button.superview!.frame.height * CGFloat(h) * 0.5
    return button
  }

  @discardableResult func addImageView(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, name: String, isButton: Bool = false) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: name))
    if isButton {
      imageView.isUserInteractionEnabled = true
    }
    self.addSubview(imageView)
    constrain(imageView) { imageView in
      imageView.centerX == imageView.superview!.centerX * x
      imageView.centerY == imageView.superview!.centerY * y
      imageView.width == imageView.superview!.width * w
      imageView.height == imageView.superview!.height * h
    }
    return imageView
  }
}
