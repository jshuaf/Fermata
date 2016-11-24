//
//  Extensions.swift
//  Fermata
//
//  Created by jfang19 on 11/14/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
	static func documentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

  static func directory(atPath: String) -> URL? {
    let recordingsDirectory = Helper.documentsDirectory().appendingPathComponent(atPath)
    do {
      try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)
      return recordingsDirectory
    } catch {
      print("\(error)")
      return nil
    }
  }

  static func formattedDate(timestamp: TimeInterval) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
  }
}

extension UILabel {
	var substituteFontName: String {
		get { return self.font.fontName }
		set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
	}
}

@IBDesignable extension UIView {
  @IBInspectable var borderColor: UIColor? {
    set {
      layer.borderColor = newValue!.cgColor
    }
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor:color)
      } else {
        return nil
      }
    }
  }
  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }
  @IBInspectable var cornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
      clipsToBounds = newValue > 0
    }
    get {
      return layer.cornerRadius
    }
  }
}

extension UIFont {

  func smallCaps() -> UIFont {

    let settings = [[UIFontFeatureTypeIdentifierKey: kLowerCaseType, UIFontFeatureSelectorIdentifierKey: kLowerCaseSmallCapsSelector]]
    let attributes: [String: AnyObject] = [UIFontDescriptorFeatureSettingsAttribute: settings as AnyObject, UIFontDescriptorNameAttribute: fontName as AnyObject]

    return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: pointSize)
  }
}
