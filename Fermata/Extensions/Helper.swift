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

extension Collection where Iterator.Element == Double, Index == Int {
  // Returns the average of all elements in the collection
  var average: Double {
    return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
  }
}

extension Collection where Indices.Iterator.Element == Index {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
