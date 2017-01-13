//
//  FMProgressBar.swift
//  Fermata
//
//  Created by jfang19 on 11/19/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class FMProgressBar: UIProgressView {

  var updateTimer: Timer?
  var totalTime: TimeInterval?
  var timeElapsed: TimeInterval?

  var lastTime: TimeInterval?
  var hasStarted = false
  var isPaused = false

  convenience init(totalTime: TimeInterval) {
    self.init()
    self.totalTime = totalTime
    self.trackTintColor = UIColor.air
    self.backgroundColor = UIColor.clear
    self.progressTintColor = UIColor.charcoal
  }

  internal func start() {
    updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
    lastTime = NSDate.timeIntervalSinceReferenceDate
    timeElapsed = 0
    hasStarted = true
    isPaused = false
  }

  internal func pause() {
    updateTimer?.invalidate()
    isPaused = true
  }

  internal func reset() {
    updateTimer?.invalidate()
    timeElapsed = nil
    lastTime = nil
    hasStarted = false
    isPaused = false
  }

  internal func restart() {
    reset()
    start()
  }

  internal func resume() {
    guard isPaused == true else {
      return
    }
    updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
    lastTime = NSDate.timeIntervalSinceReferenceDate
    isPaused = false
  }

  @objc private func updateProgress() {
    let currentTime = NSDate.timeIntervalSinceReferenceDate

    let timeSinceLast = currentTime - lastTime!
    lastTime = currentTime
    timeElapsed! += TimeInterval(timeSinceLast)

    let currentProgress = Float(timeElapsed!) / Float(totalTime!)

    setProgress(currentProgress, animated: true)
  }
}
