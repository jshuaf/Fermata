//
//  MetronomePreset.swift
//  Fermata
//
//  Created by jfang19 on 12/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import RealmSwift
import Foundation

class MetronomePreset: Object {
  dynamic var targetTempo: Int = 160
  let stretchTempo = RealmOptional<Int>()
  let practiceTempo = RealmOptional<Int>()
  dynamic var piece: Piece?
}
