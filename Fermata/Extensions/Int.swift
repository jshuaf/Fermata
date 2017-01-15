//
//  Int.swift
//  Fermata
//
//  Created by jfang19 on 1/14/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import Foundation

extension Int {
  var ordinal: String {
    var suffix: String
    let ones: Int = self % 10
    let tens: Int = (self/10) % 10
    if tens == 1 {
      suffix = "th"
    } else if ones == 1 {
      suffix = "st"
    } else if ones == 2 {
      suffix = "nd"
    } else if ones == 3 {
      suffix = "rd"
    } else {
      suffix = "th"
    }
    return "\(self)\(suffix)"
  }

}
