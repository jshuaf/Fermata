//
//  NSDate.swift
//  Fermata
//
//  Created by jfang19 on 1/13/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import Foundation
import UIKit

extension Date {
  static func firstDateOfWeek(forDate date: Date = Date()) -> Date {
    let calendar = Calendar.current
    let dateComponents = DateComponents(
      calendar: calendar,
      weekOfYear: calendar.component(.weekOfYear, from: date),
      yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: date)
    )
    return calendar.date(from: dateComponents)!
  }
}
