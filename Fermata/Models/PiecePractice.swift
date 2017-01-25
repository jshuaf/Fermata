//
//  PiecePractice.swift
//  Fermata
//
//  Created by jfang19 on 12/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import RealmSwift
import Foundation

class PiecePractice: Object {
  dynamic var piece: Piece?
  let duration = RealmOptional<Double>()
  let position = RealmOptional<Int>()
  dynamic var practiceSession: PracticeSession?
}
