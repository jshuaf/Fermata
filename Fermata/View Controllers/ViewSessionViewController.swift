//
//  ViewSessionViewController.swift
//  Fermata
//
//  Created by jfang19 on 1/24/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import Timepiece

class ViewSessionViewController: UIViewController {
  private let practiceSession: PracticeSession
  private var dateTitle: UILabel?

  init(session: PracticeSession) {
    self.practiceSession = session
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override internal func viewDidLoad() {
    super.viewDidLoad()
    view.addGradient(UIColor.sunrise)
    setupBackground()
    setupNavigation()
  }

  private func setupBackground() {
    let background = view.addView(x: 1, y: 1.09, w: 1, h: 0.76)
    background.backgroundColor = .chalk
  }

  private func setupNavigation() {
    let dateNavigation = view.addView(x: 1, y: 0.26, w: 1, h: 0.07)
    dateNavigation.backgroundColor = .air
    dateTitle = dateNavigation.addLabel(style: LabelStyle.Body.AccentOne(), x: 1, y: 0.98, text: Date().dateString(in: .medium))

    let leftNavigation = dateNavigation.addImageView(x: 0.17, y: 1.02, w: 0.06, name: "Go Back Arrow", isButton: true, color: .tangerine)
    leftNavigation.addTapEvent(target: self, action: #selector(self.goToPreviousSession))
    let rightNavigation = dateNavigation.addImageView(x: 1.83, y: 1.02, w: 0.06, name: "Continue Arrow", isButton: true, color: .tangerine)
    rightNavigation.addTapEvent(target: self, action: #selector(self.goToNextSession))
  }

  @objc private func goToPreviousSession() {

  }

  @objc private func goToNextSession() {

  }
}
