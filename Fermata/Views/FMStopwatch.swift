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
  var hasStarted = false
  var isPaused = false

  internal func startTiming() {
    updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateTimeElapsed), userInfo: nil, repeats: true)
    lastTime = NSDate.timeIntervalSinceReferenceDate
    timeElapsed = 0
    hasStarted = true
    isPaused = false
  }

  internal func pauseTiming() {
    updateTimer?.invalidate()
    isPaused = true
  }

  internal func stopTiming() {
    updateTimer?.invalidate()
    timeElapsed = nil
    lastTime = nil
    hasStarted = false
    isPaused = false
  }

  internal func restartTiming() {
    stopTiming()
    startTiming()
  }

  internal func resumeTiming() {
    guard isPaused == true else {
      return
    }
    updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateTimeElapsed), userInfo: nil, repeats: true)
    lastTime = NSDate.timeIntervalSinceReferenceDate
    isPaused = false
  }

  @objc private func updateTimeElapsed() {
    let currentTime = NSDate.timeIntervalSinceReferenceDate

    let timeSinceLast = currentTime - lastTime!
    lastTime = currentTime
    timeElapsed! += TimeInterval(timeSinceLast)

    self.text = FMStopwatch.stringFromTime(timeInterval: timeElapsed!)
  }

  internal static func stringFromTime(timeInterval: TimeInterval) -> String {
    var currentTime = timeInterval

    let hours = Int(floor(currentTime / 3600))
    currentTime -= TimeInterval(hours * 3600)
    let minutes = Int(floor(currentTime / 60))
    currentTime -= TimeInterval(minutes * 60)
    let seconds = Int(floor(currentTime))

    if hours > 0 {
      return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
    } else {
      return String(format: "%02d:%02d", minutes, seconds)
    }
  }

}
