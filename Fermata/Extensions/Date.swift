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
  var firstDateOfWeek: Date {
    get {
      let calendar = Calendar.current
      let dateComponents = DateComponents(
        calendar: calendar,
        weekOfYear: calendar.component(.weekOfYear, from: self),
        yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self)
      )
      return calendar.date(from: dateComponents)!
    }
  }
  var firstDateOfMonth: Date {
    get {
      let calendar = Calendar.current
      let dateComponents = DateComponents(
        calendar: calendar,
        month: calendar.component(.month, from: self),
        yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self)
      )
      return calendar.date(from: dateComponents)!
    }
  }
}
