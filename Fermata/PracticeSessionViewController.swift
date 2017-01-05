//
//  PracticeSessionViewController.swift
//  Fermata
//
//  Created by jfang19 on 12/21/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

protocol PracticeSessionDelegate: class {
  func selectPiece(_ piece: Piece)
}

class PracticeSessionViewController: UIViewController, PracticeSessionDelegate {
  private var goalDuration: TimeInterval?
  private var currentPiece: Piece?

  private var sessionProgressLabel: FMStopwatch?
  private var currentPieceNameLabel: UILabel?
  private var currentPieceTimeLabel: FMStopwatch?
  private var togglePauseButton: UIImageView?
  private var isPaused: Bool = false

  convenience init(goalDuration: TimeInterval) {
    self.init()
    self.goalDuration = goalDuration
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.isNavigationBarHidden = true

    if currentPiece == nil {
      let nextViewController = SelectPieceViewController()
      nextViewController.delegate = self
      navigationController?.pushViewController(nextViewController, animated: true)
      return
    } else {
      currentPieceNameLabel?.text = currentPiece?.name
      sessionProgressLabel?.startTiming()
      currentPieceTimeLabel?.startTiming()
    }
  }

  override func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = true
    setupSessionProgress()
    setupCurrentPiece()
    setupTimeControls()
    setupBackground()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }

  func setupBackground() {
    let backgroundGradient = [UIColor.grapefruit, UIColor.cookie].gradient()
    backgroundGradient.frame = view.bounds
    view.layer.insertSublayer(backgroundGradient, at: 0)
  }

  func setupSessionProgress() {
    let sessionProgress = view.addView(x: 1, y: 0.16, w: 0.92, h: 0.06)
    sessionProgress.addLabel(style: LabelStyle.Body.Emphasis, alignLeft: sessionProgress, y: 0.44, text: "Session Progress")

    let sessionDurationString = FMStopwatch.stringFromTime(timeInterval: goalDuration!)
    let sessionDurationLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary, alignRight: sessionProgress, y: 0.44, text: " / \(sessionDurationString)")
    sessionProgressLabel = sessionProgress.addLabel(style: LabelStyle.Body.Primary, leftOf: sessionDurationLabel, y: 0.44, initialLabel: FMStopwatch()) as? FMStopwatch

    sessionProgress.addView(x: 1, y: 1.74, w: 1, h: 0.26)
  }

  func setupCurrentPiece() {
    let currentPiece = view.addView(x: 1, y: 0.48, w: 0.73, h: 0.04)
    currentPieceNameLabel = currentPiece.addLabel(style: LabelStyle.HeaderTwo.Primary, x: 1, y: 1)
    let editPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle, x: 0.11, y: 1.04, text: "Edit")
    let nextPieceButton = currentPiece.addLabel(style: LabelStyle.HeaderThree.Subtle, x: 1.86, y: 1.04, text: "Next")
  }

  func setupTimeControls() {
    let timeControls = view.addView(x: 1, y: 0.34, w: 0.45, h: 0.07)
    currentPieceTimeLabel = timeControls.addLabel(style: LabelStyle.Large.Primary, x: 1, y: 1, initialLabel: FMStopwatch()) as? FMStopwatch
    let stopButton = timeControls.addImageView(x: 1.89, y: 1.04, w: 0.11, h: 0.43, name: "Stop Icon", isButton: true)
    togglePauseButton = timeControls.addImageView(x: 0.1, y: 1.04, w: 0.1, h: 0.48, name: "Pause Icon", isButton: true)
    togglePauseButton?.addTapEvent(target: self, action: #selector(self.togglePause))
  }

  func togglePause() {
    isPaused ? unpauseSession() : pauseSession()
  }

  func pauseSession() {
    sessionProgressLabel?.pauseTiming()
    currentPieceTimeLabel?.pauseTiming()
    togglePauseButton?.image = UIImage(named: "Play Icon")
    isPaused = true
  }

  func unpauseSession() {
    sessionProgressLabel?.resumeTiming()
    currentPieceTimeLabel?.resumeTiming()
    togglePauseButton?.image = UIImage(named: "Pause Icon")
    isPaused = false
  }

  func selectPiece(_ piece: Piece) {
    self.currentPiece = piece
  }
}
