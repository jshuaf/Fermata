//
//  FMStopwatch.swift
//  Fermata
//
//  Created by jfang19 on 11/19/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class FMStopwatch: UILabel {

  var updateTimer: Timer?
  var timeElapsed: TimeInterval?
  var lastTime: TimeInterval?

  func startTiming() {
    updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateTimeElapsed), userInfo: nil, repeats: true)
    lastTime = NSDate.timeIntervalSinceReferenceDate
    timeElapsed = 0
  }

  func pauseTiming() {
    updateTimer?.invalidate()
  }

  func stopTiming() {
    updateTimer?.invalidate()
    timeElapsed = nil
    lastTime = nil
  }

  func updateTimeElapsed() {
    let currentTime = NSDate.timeIntervalSinceReferenceDate

    let timeSinceLast = currentTime - lastTime!
    lastTime = currentTime
    timeElapsed! += TimeInterval(timeSinceLast)

    var currentTimeElapsed = timeElapsed!

    let elapsedHours = floor(currentTimeElapsed / 3600)
    currentTimeElapsed -= TimeInterval(elapsedHours * 3600)
    let elapsedMinutes = floor(currentTimeElapsed / 60)
    currentTimeElapsed -= TimeInterval(elapsedMinutes * 60)
    let elapsedSeconds = floor(currentTimeElapsed)

    self.text = String(format: "%.0f:%.0f:%.0f", elapsedHours, elapsedMinutes, elapsedSeconds)
  }

}
