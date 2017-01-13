//
//  Piece.swift
//  Fermata
//
//  Created by jfang19 on 12/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import RealmSwift
import Foundation

enum PieceCategory: String {
  case Technique = "Technique"
  case Sightreading = "Sightreading"
  case Theory = "Theory"
  case Repertoire = "Repertoire"
  case Other = "Other"
  static let allCategories = ["Technique", "Sightreading", "Theory", "Repertoire", "Other"]
}

class Piece: Object {
  dynamic var name = ""
  dynamic var category = ""
  dynamic var lastPracticed: NSDate?
  let metronomePresets = LinkingObjects(fromType: MetronomePreset.self, property: "piece")
}
