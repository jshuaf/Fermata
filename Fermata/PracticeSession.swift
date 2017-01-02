//
//  PracticeSession.swift
//  Fermata
//
//  Created by jfang19 on 12/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import RealmSwift
import Foundation

class PracticeSession: Object {
  dynamic var startTime: NSDate?
  dynamic var endTime: NSDate?
  let goalDuration = RealmOptional<Double>()
  let piecesPracticed = List<PiecePractice>()
}
