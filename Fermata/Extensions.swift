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
	static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

	static func getRecordingsDirectory() -> URL? {
		let recordingsDirectory = Helper.getDocumentsDirectory().appendingPathComponent("Recordings")
		do {
			try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)
			return recordingsDirectory
		} catch {
			print("\(error)")
			return nil
		}
	}
}

extension UILabel {
	var substituteFontName: String {
		get { return self.font.fontName }
		set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
	}

}
