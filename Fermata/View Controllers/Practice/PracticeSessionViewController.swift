//
//  PracticeSessionViewController.swift
//  Fermata
//
//  Created by jfang19 on 12/21/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

enum PracticeSessionState {
  case EditingPiece
  case AddingPiece
  case Practicing
}

protocol PracticeSessionDelegate: class {
  func setPiece(_ piece: Piece)
}

class PracticeSessionViewController: UIViewController, PracticeSessionDelegate {
  // MARK: Constants
  private let tempoIncrement = 4.0

  // MARK: Singleton Properties
  private var practiceSession: PracticeSession?
  private var state: PracticeSessionState = .Practicing
  private var metronome: FMMetronome?

  private var goalDuration: TimeInterval?
  private var currentPiece: Piece?
  private var currentPiecePractice: PiecePractice?

  private var sessionProgressLabel: FMStopwatch?
  private var sessionProgressBar: FMProgressBar?
  private var currentPieceNameLabel: UILabel?
  private var currentPieceTimeLabel: FMStopwatch?
  private var togglePauseButton: UIImageView?
  private var currentMetronomeTempoLabel: UILabel?
  private var toggleMetronomeButton: UIButton?

  convenience init(goalDuration: TimeInterval) {
    self.init()
    self.goalDuration = goalDuration
    self.metronome = FMMetronome()
  }

  // MARK: Lifecycle Methods
  override internal func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.isNavigationBarHidden = true

    if currentPiece == nil {
      state = .AddingPiece
      currentPieceTimeLabel?.startTiming()
      sessionProgressBar?.start()
      sessionProgressLabel?.startTiming()
      return selectPiece()
    }
  }

  override internal func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    view.addGradient(UIColor.sunrise)

    setupBackground()
    setupPracticeSession()
    setupSessionProgress()
    setupCurrentPiece()
    setupTimeControls()
    setupMetronome()
  }

  override internal func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.pauseSession()
    self.navigationController?.isNavigationBarHidden = false
  }

  // MARK: View Setup

  private func setupPracticeSession() {
    do {
      let realm = try Realm()
      let practiceSessionData: [String:Any?] = ["startTime": NSDate(), "goalDuration": goalDuration!]
      practiceSession = PracticeSession(value: practiceSessionData)
      try realm.write {
        realm.add(practiceSession!)
      }
    } catch {
      print("\(error)")
    }
  }

  private func setupBackground() {
    view.addGradient(UIColor.sunrise)
    let controlsView = view.addView(x: 1, y: 0.29, w: 1, h: 0.29)
    controlsView.backgroundColor = UIColor.ghost
  }

  private func setupSessionProgress() {
    let sessionProgress = view.addView(x: 1, y: 0.16, w: 0.92, h: 0.06)
    sessionProgress.addLabel(style: LabelStyle.Body.Emphasis(), alignLeft: sessionProgress, y: 0.44, text: "Session Progress")

    let sessionDurationString = FMStopwatch.stringFromTime(timeInterval: goalDuration!)
    let sessionDurationLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary(), alignRight: sessionProgress, y: 0.44, text: " / \(sessionDurationString)")
    sessionProgressLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary(), leftOf: sessionDurationLabel, y: 0.44, initialLabel: FMStopwatch()) as? FMStopwatch
    sessionProgressBar = sessionProgress.addView(x: 1, y: 1.74, w: 1, h: 0.26, view: FMProgressBar(totalTime: goalDuration!)) as? FMProgressBar
    sessionProgress.addView(x: 1, y: 1.74, w: 1, h: 0.26)
  }

  private func setupCurrentPiece() {
    let currentPiece = view.addView(x: 1, y: 0.48, w: 0.73, h: 0.04)
    currentPieceNameLabel = currentPiece.addLabel(style: LabelStyle.HeaderTwo.Primary(), x: 1, y: 1, maxWidth: 0.75)
    let editPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle(), x: 0.05, y: 1.04, text: "Edit", isButton: true)
    let nextPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle(), x: 2, y: 1.04, text: "Next", isButton: true)
    nextPieceButton.addTapEvent(target: self, action: #selector(self.moveToNextPiece))
    editPieceButton.addTapEvent(target: self, action: #selector(self.editCurrentPiece))

  }

  private func setupTimeControls() {
    let timeControls = view.addView(x: 1, y: 0.34, w: 0.45, h: 0.07)
    currentPieceTimeLabel = timeControls.addLabel(style: LabelStyle.Large.Primary(), x: 1, y: 1, initialLabel: FMStopwatch()) as? FMStopwatch
    let stopButton = timeControls.addImageView(x: 1.89, y: 1.04, w: 0.11, h: 0.43, name: "Stop Icon", isButton: true)
    stopButton.addTapEvent(target: self, action: #selector(self.endSession))
    togglePauseButton = timeControls.addImageView(x: 0.1, y: 1.04, w: 0.1, h: 0.48, name: "Pause Icon", isButton: true)
    togglePauseButton?.addTapEvent(target: self, action: #selector(self.togglePause))
  }

  private func setupMetronome() {
    let metronomeView = view.addView(x: 1, y: 1.1, w: 0.72, h: 0.41)
    let decrementTempoButton = metronomeView.addLabel(style: LabelStyle.Massive.Primary(), x: 0.11, y: 0.48, text: "–", isButton: true)
    decrementTempoButton.addTapEvent(target: self, action: #selector(self.decrementTempo))
    let incrementTempoButton = metronomeView.addLabel(style: LabelStyle.Massive.Primary(), x: 1.89, y: 0.48, text: "+", isButton: true)
    incrementTempoButton.addTapEvent(target: self, action: #selector(self.incrementTempo))
    toggleMetronomeButton = metronomeView.addButton(style: ButtonStyle.Circle(), x: 1, y: 0.52, text: "Start", target: self, action: #selector(self.toggleMetronome))
    metronomeView.addButton(style: ButtonStyle.Medium(), x: 1, y: 1.85, text: "Tap to Input Tempo", target: self, action: #selector(self.addTempoInput))
    currentMetronomeTempoLabel = metronomeView.addLabel(style: LabelStyle.Large.Primary(), x: 1, y: 1.32, text: String(format: "%.0f BPM", metronome!.tempo))
  }

  // MARK: Actions
  @objc private func togglePause() {
    (sessionProgressLabel?.isPaused)! ? unpauseSession() : pauseSession()
  }

  private func pauseSession() {
    sessionProgressLabel?.pauseTiming()
    sessionProgressBar?.pause()
    currentPieceTimeLabel?.pauseTiming()
    togglePauseButton?.image = UIImage(named: "Play Icon")
  }

  private func unpauseSession() {
    sessionProgressLabel?.resumeTiming()
    sessionProgressBar?.pause()
    currentPieceTimeLabel?.resumeTiming()
    togglePauseButton?.image = UIImage(named: "Pause Icon")
  }

  @objc private func endSession() {
    let currentPieceDuration = currentPieceTimeLabel?.timeElapsed
    do {
      let realm = try Realm()
      try realm.write {
        currentPiecePractice?.duration.value = currentPieceDuration
        practiceSession?.endTime = NSDate()
      }
    } catch {
      print("\(error)")
    }
    present(PracticeSummaryViewController(practiceSessionDuration: (sessionProgressLabel?.timeElapsed)!), animated: true, completion: {})
  }

  private func selectPiece(title: String = "Select a Piece") {
    let nextViewController = SelectPieceViewController(title: title)
    nextViewController.delegate = self
    navigationController?.pushViewController(nextViewController, animated: true)
  }

  @objc private func editCurrentPiece() {
    state = .EditingPiece
    selectPiece(title: "Edit Current Piece")
  }

  @objc private func moveToNextPiece() {
    state = .AddingPiece
    selectPiece(title: "Select Next Piece")
  }

  @objc private func toggleMetronome() {
    if (metronome?.isPlaying)! {
      metronome?.stop()
      toggleMetronomeButton?.setTitle("Start", for: .normal)
    } else {
      metronome?.start()
      toggleMetronomeButton?.setTitle("Stop", for: .normal)
    }
  }

  @objc private func decrementTempo() {
    metronome?.decrementTempo(by: tempoIncrement)
    updateCurrentTempo()
  }

  @objc private func incrementTempo() {
    metronome?.incrementTempo(by: tempoIncrement)
    updateCurrentTempo()
  }

  @objc private func addTempoInput() {
    metronome?.addTempoInput(tempoInput: Date().timeIntervalSince1970)
    updateCurrentTempo()
  }

  private func updateCurrentTempo() {
    currentMetronomeTempoLabel?.text = String(format: "%.0f BPM", metronome!.tempo)
  }

  private func setPiecePractice() {
    do {
      let realm = try Realm()
      let piecePracticeData: [String:Any?] = ["piece": currentPiece!, "position": practiceSession?.piecesPracticed.count, "practiceSession": practiceSession]
      currentPiecePractice = PiecePractice(value: piecePracticeData)
      try realm.write {
        realm.add(currentPiecePractice!)
      }
    } catch {
      print("\(error)")
    }
  }

  internal func setPiece(_ piece: Piece) {
    self.currentPiece = piece
    unpauseSession()
    switch state {
    case .AddingPiece:
      if currentPiecePractice != nil {
        let currentPieceDuration = currentPieceTimeLabel?.timeElapsed
        do {
          let realm = try Realm()
          try realm.write {
            currentPiecePractice?.duration.value = currentPieceDuration
          }
        } catch {
          print("\(error)")
        }
      }
      setPiecePractice()
      currentPieceTimeLabel?.restartTiming()
    case .EditingPiece:
      do {
        let realm = try Realm()
        try realm.write {
          currentPiecePractice?.piece = currentPiece
        }
      } catch {
        print("\(error)")
      }
      currentPieceTimeLabel?.resumeTiming()
    default: break
    }
    state = .Practicing
    sessionProgressLabel?.resumeTiming()
    sessionProgressBar?.resume()
    currentPieceNameLabel?.text = currentPiece?.name
  }
}
