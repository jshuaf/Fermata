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

  internal var primaryPiece: Piece {
    get {
      return piecesPracticed.max(by: { $0.duration.value! > $1.duration.value! })!.piece!
    }
  }
}

extension Results where T: PracticeSession {
  internal func sortedByWeeks() -> [Int: [PracticeSession]] {
    let calendar = Calendar.current
    var resultsByWeek: [Int: [PracticeSession]] = [:]
    for item in self {
      let session = item as PracticeSession
      let currentWeek = calendar.component(.weekOfMonth, from: (session.endTime as? Date)!)
      if resultsByWeek[currentWeek] != nil {
        resultsByWeek[currentWeek]?.append(session)
      } else {
        resultsByWeek[currentWeek] = []
      }
    }
    return resultsByWeek
  }
}
