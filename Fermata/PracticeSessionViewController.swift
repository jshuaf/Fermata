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
  private var practiceSession: PracticeSession?
  private var state: PracticeSessionState = .Practicing

  private var goalDuration: TimeInterval?
  private var currentPiece: Piece?
  private var currentPiecePractice: PiecePractice?

  private var sessionProgressLabel: FMStopwatch?
  private var currentPieceNameLabel: UILabel?
  private var currentPieceTimeLabel: FMStopwatch?
  private var togglePauseButton: UIImageView?
  private var isPaused: Bool = false

  convenience init(goalDuration: TimeInterval) {
    self.init()
    self.goalDuration = goalDuration
  }

  override internal func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.isNavigationBarHidden = true

    if currentPiece == nil {
      state = .AddingPiece
      return selectPiece()
    }

    if sessionProgressLabel!.isActive {
      sessionProgressLabel?.resumeTiming()
      currentPieceTimeLabel?.resumeTiming()
    } else {
      sessionProgressLabel?.startTiming()
      currentPieceTimeLabel?.startTiming()
    }

  }

  override internal func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = true

    setupPracticeSession()
    setupSessionProgress()
    setupCurrentPiece()
    setupTimeControls()
    setupBackground()
  }

  override internal func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }

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

  private func setPiecePractice() {
    do {
      let realm = try Realm()
      let piecePracticeData: [String:Any?] = ["piece": currentPiece!, "position": practiceSession?.piecesPracticed.count]
      currentPiecePractice = PiecePractice(value: piecePracticeData)
      try realm.write {
        practiceSession?.piecesPracticed.append(currentPiecePractice!)
      }
    } catch {
      print("\(error)")
    }
  }

  private func setupBackground() {
    let backgroundGradient = [UIColor.grapefruit, UIColor.cookie].gradient()
    backgroundGradient.frame = view.bounds
    view.layer.insertSublayer(backgroundGradient, at: 0)
  }

  private func setupSessionProgress() {
    let sessionProgress = view.addView(x: 1, y: 0.16, w: 0.92, h: 0.06)
    sessionProgress.addLabel(style: LabelStyle.Body.Emphasis, alignLeft: sessionProgress, y: 0.44, text: "Session Progress")

    let sessionDurationString = FMStopwatch.stringFromTime(timeInterval: goalDuration!)
    let sessionDurationLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary, alignRight: sessionProgress, y: 0.44, text: " / \(sessionDurationString)")
    sessionProgressLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary, leftOf: sessionDurationLabel, y: 0.44, initialLabel: FMStopwatch()) as? FMStopwatch

    sessionProgress.addView(x: 1, y: 1.74, w: 1, h: 0.26)
  }

  private func setupCurrentPiece() {
    let currentPiece = view.addView(x: 1, y: 0.48, w: 0.73, h: 0.04)
    currentPieceNameLabel = currentPiece.addLabel(style: LabelStyle.HeaderTwo.Primary, x: 1, y: 1)
    let editPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle, x: 0.11, y: 1.04, text: "Edit", isButton: true)
    let nextPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle, x: 1.86, y: 1.04, text: "Next", isButton: true)
    nextPieceButton.addTapEvent(target: self, action: #selector(self.moveToNextPiece))
    editPieceButton.addTapEvent(target: self, action: #selector(self.editCurrentPiece))

  }

  private func setupTimeControls() {
    let timeControls = view.addView(x: 1, y: 0.34, w: 0.45, h: 0.07)
    currentPieceTimeLabel = timeControls.addLabel(style: LabelStyle.Large.Primary, x: 1, y: 1, initialLabel: FMStopwatch()) as? FMStopwatch
    let stopButton = timeControls.addImageView(x: 1.89, y: 1.04, w: 0.11, h: 0.43, name: "Stop Icon", isButton: true)
    stopButton.addTapEvent(target: self, action: #selector(self.endSession))
    togglePauseButton = timeControls.addImageView(x: 0.1, y: 1.04, w: 0.1, h: 0.48, name: "Pause Icon", isButton: true)
    togglePauseButton?.addTapEvent(target: self, action: #selector(self.togglePause))
  }

  @objc private func togglePause() {
    isPaused ? unpauseSession() : pauseSession()
  }

  private func pauseSession() {
    sessionProgressLabel?.pauseTiming()
    currentPieceTimeLabel?.pauseTiming()
    togglePauseButton?.image = UIImage(named: "Play Icon")
    isPaused = true
  }

  private func unpauseSession() {
    sessionProgressLabel?.resumeTiming()
    currentPieceTimeLabel?.resumeTiming()
    togglePauseButton?.image = UIImage(named: "Pause Icon")
    isPaused = false
  }

  @objc private func endSession() {

  }

  private func selectPiece(title: String = "Select a Piece") {
    let nextViewController = SelectPieceViewController(title: title)
    nextViewController.delegate = self
    navigationController?.pushViewController(nextViewController, animated: true)
  }

  private func editCurrentPiece() {
    state = .EditingPiece
    selectPiece(title: "Edit Current Piece")
  }

  @objc private func moveToNextPiece() {
    state = .AddingPiece
    selectPiece(title: "Select Next Piece")
  }

  internal func setPiece(_ piece: Piece) {
    self.currentPiece = piece
    switch state {
    case .AddingPiece:
      let currentPieceDuration = currentPieceTimeLabel?.timeElapsed
      do {
        let realm = try Realm()
        try realm.write {
          currentPiecePractice?.duration.value = currentPieceDuration
        }
      } catch {
        print("\(error)")
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
    default: break
    }
    currentPieceNameLabel?.text = currentPiece?.name
  }
}
