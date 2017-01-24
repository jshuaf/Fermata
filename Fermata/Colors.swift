//
//  Colors.swift
//  Fermata
//
//  Created by jfang19 on 11/18/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  // MARK: Methods
	convenience init(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat, _ a: CGFloat=100) {
		self.init(hue: h / 360, saturation: s / 100, brightness: b / 100, alpha: a / 100)
	}
  // MARK: Colors
	@nonobjc static var charcoal = UIColor(0, 0, 22)
	@nonobjc static var grapefruit = UIColor(10, 63, 100)
	@nonobjc static var cookie = UIColor(64, 48, 100)
  @nonobjc static var tangerine = UIColor(30, 64, 100)
  @nonobjc static var air = UIColor(0, 0, 100, 90)
  @nonobjc static var ghost = UIColor(0, 0, 100, 30)

  // MARK: Gradients
  @nonobjc static var sunrise = [UIColor.grapefruit, UIColor.cookie]
}
