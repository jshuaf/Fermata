//
//  FMMetronome.swift
//  Fermata
//
//  Created by jfang19 on 12/16/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import AVFoundation

enum FMMetronomeError: Error {
  case audioSession
  case soundFilePath
}

class FMMetronome: NSObject {

  private var player: AVAudioPlayer?
  private var tempoInputs: [TimeInterval] = []
  private var timer: Timer?

  internal var tempo = 100.0 // BPM
  internal var minTempo = 50.0
  internal var maxTempo = 300.0
  internal var onTempoChange: ((Double) -> Void)?
  internal var isPlaying = false

  override init() {
    super.init()
    do {
      try setup()
    } catch {
      print("\(error)")
    }
  }

  private func setup() throws {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
      try audioSession.setActive(true)

      guard let sound = Bundle.main.url(forResource: "wooden", withExtension: "wav") else {
        throw FMMetronomeError.soundFilePath
      }
      player = try AVAudioPlayer(contentsOf: sound)
    } catch {
      throw FMMetronomeError.audioSession
    }
  }

  internal func start() {
    timer = Timer.scheduledTimer(timeInterval: 60.0 / tempo, target: self, selector: #selector(self.pulse), userInfo: nil, repeats: true)
    isPlaying = true
  }

  internal func stop() {
    timer?.invalidate()
    isPlaying = false
  }

  @objc private func pulse() {
    player?.play()
  }

  private func changeTempo(to newTempo: Double) {
    guard newTempo > minTempo && newTempo < maxTempo else {
      return
    }
    tempo = newTempo
    stop()
    start()
  }

  internal func decrementTempo(by difference: Double) {
    changeTempo(to: tempo - difference)
  }

  internal func incrementTempo(by difference: Double) {
    changeTempo(to: tempo + difference)
  }

  internal func addTempoInput(tempoInput: TimeInterval) {
    tempoInputs.append(tempoInput)
    updateTempoFromInput()
  }

  private func updateTempoFromInput() {
    let currentDate = Date().timeIntervalSince1970
    tempoInputs = tempoInputs.filter({ currentDate - $0 < 10.0 })

    let recentTempoInputs = Array(tempoInputs.suffix(3))
    let timeBetweenInputs = recentTempoInputs.enumerated().map {(index, tempo) -> TimeInterval? in
      return index == 0 ? nil : tempo - recentTempoInputs[index - 1]
      }.filter { $0 != nil }.map { $0!
    }
    changeTempo(to: 60.0 / timeBetweenInputs.average)
  }
}
