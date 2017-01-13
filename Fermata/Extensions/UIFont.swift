//
//  UIFont.swift
//  Fermata
//
//  Created by jfang19 on 12/20/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

  func smallCaps() -> UIFont {

    let settings = [[UIFontFeatureTypeIdentifierKey: kLowerCaseType, UIFontFeatureSelectorIdentifierKey: kLowerCaseSmallCapsSelector]]
    let attributes: [String: AnyObject] = [UIFontDescriptorFeatureSettingsAttribute: settings as AnyObject, UIFontDescriptorNameAttribute: fontName as AnyObject]

    return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: pointSize)
  }
}
