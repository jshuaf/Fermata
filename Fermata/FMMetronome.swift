//
//  Metronome.swift
//  Fermata
//
//  Created by jfang19 on 12/16/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import AVFoundation

enum MetronomeError: Error {
  case audioSession
  case soundFilePath
}

class Metronome: NSObject {

  private var player: AVAudioPlayer?
  private var tempo = 100.0 // BPM
  private var tempoInputs: [TimeInterval] = []
  private var timer: Timer?

  var onTempoChange: ((Double) -> Void)?
  var minTempo = 50.0
  var maxTempo = 300.0

  override init() {
    super.init()
  }

  func setup() throws {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
      try audioSession.setActive(true)

      guard let sound = Bundle.main.url(forResource: "wooden", withExtension: "wav") else {
        throw MetronomeError.soundFilePath
      }
      player = try AVAudioPlayer(contentsOf: sound)
    } catch {
      throw MetronomeError.audioSession
    }
  }

  func start() {
    timer = Timer.scheduledTimer(timeInterval: 60.0 / tempo, target: self, selector: #selector(self.pulse), userInfo: nil, repeats: true)
  }

  func stop() {
    timer?.invalidate()
  }

  func pulse() {
    player?.play()
  }

  func changeTempo(newTempo: Double) {
    guard newTempo > minTempo && newTempo < maxTempo else {
      return
    }
    tempo = newTempo
    stop()
    start()
  }

  func addTempoInput(tempoInput: TimeInterval) {
    tempoInputs.append(tempoInput)
    updateTempoFromInput()
  }

  func updateTempoFromInput() {
    let currentDate = Date().timeIntervalSince1970
    tempoInputs = tempoInputs.filter({ currentDate - $0 < 10.0 })

    let recentTempoInputs = Array(tempoInputs.suffix(3))
    let timeBetweenInputs = recentTempoInputs.enumerated().map {(index, tempo) -> TimeInterval? in
      return index == 0 ? nil : tempo - recentTempoInputs[index - 1]
      }.filter { $0 != nil }.map { $0!
    }
    changeTempo(newTempo: 60.0 / timeBetweenInputs.average)
  }
}
