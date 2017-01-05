//
//  SetupPracticeViewController.swift
//  Fermata
//
//  Created by jfang19 on 12/19/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import Cartography

class SetupPracticeViewController: UIViewController {

  private var goalDurationLabels: [UILabel] = []
  private var selectedGoalDuration: String? {
    get {
      let selectedLabel = goalDurationLabels.filter {$0.fontWeight == .Medium}.first
      return selectedLabel?.text
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Start Practice"
    setupBackground()
    setupLabels()
  }

  private func setupBackground() {
    let backgroundGradient = [UIColor.grapefruit, UIColor.cookie].gradient()
    backgroundGradient.frame = view.bounds
    view.layer.insertSublayer(backgroundGradient, at: 0)
  }

  private func setupLabels() {
    view.addLabel(style: LabelStyle.HeaderOne.Primary, x: 1, y: 0.59, text: "Ready to practice?")
    view.addLabel(style: LabelStyle.Body.Primary, x: 1, y: 0.72, text: "Set a rough goal time for yourself.")
    let startSessionButton = view.addButton(style: ButtonStyle.Long, x: 1, y: 1.53, text: "Start Practice Session")
    startSessionButton.addTarget(self, action: #selector(startPracticeSession), for: .touchUpInside)

    let goalDurationView = view.addView(x: 1, y: 1.07, w: 0.77, h: 0.18)
    let quickLabel = goalDurationView.addLabel(style: LabelStyle.Body.Emphasis, x: 0.17, y: 0.16, text: "Quick")
    goalDurationView.addLabel(style: LabelStyle.Body.Emphasis, alignLeft: quickLabel, y: 1, text: "Moderate")
    goalDurationView.addLabel(style: LabelStyle.Body.Emphasis, alignLeft: quickLabel, y: 1.84, text: "Long")

    let durationsFirstColumnLabel = goalDurationView.addLabel(style: LabelStyle.Body.Primary, x: 1.13, y: 1, text: "45:00")
    goalDurationLabels.append(durationsFirstColumnLabel)
    goalDurationLabels.append(goalDurationView.addLabel(style: LabelStyle.Body.Primary, alignRight: durationsFirstColumnLabel, y: 0.16, text: "15:00"))
    goalDurationLabels.append(goalDurationView.addLabel(style: LabelStyle.Body.Primary, alignRight: durationsFirstColumnLabel, y: 1.84, text: "1:30:00"))

    let durationsSecondColumnLabel = goalDurationView.addLabel(style: LabelStyle.Body.Primary, x: 1.84, y: 1, text: "60:00")
    goalDurationLabels.append(durationsSecondColumnLabel)
    goalDurationLabels.append(goalDurationView.addLabel(style: LabelStyle.Body.Primary, alignRight: durationsSecondColumnLabel, y: 0.16, text: "30:00"))
    goalDurationLabels.append(goalDurationView.addLabel(style: LabelStyle.Body.Primary, alignRight: durationsSecondColumnLabel, y: 1.84, text: "2:00:00"))

    for goalDurationLabel in goalDurationLabels {
      goalDurationLabel.isUserInteractionEnabled = true
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectGoalDuration))
      goalDurationLabel.addGestureRecognizer(gestureRecognizer)
    }
  }

  @objc private func selectGoalDuration(sender: UIGestureRecognizer) {
    let goalSelected = sender.view as? UILabel
    for goalDurationLabel in goalDurationLabels {
      if goalDurationLabel.fontWeight == .Medium {
        goalDurationLabel.setFontWeight(FontWeight.Regular)
      }
    }
    goalSelected?.setFontWeight(FontWeight.Medium)
  }

  private func timeDuration(forString stringDuration: String) -> TimeInterval {
    let durationParts = Array(stringDuration.components(separatedBy: ":").reversed())
    let minutes = durationParts[1]
    let hours = durationParts[safe: 2] ?? "0"
    return TimeInterval(Int(minutes)! * 60 + Int(hours)! * 3600)
  }

  @objc private func startPracticeSession() {
    guard selectedGoalDuration != nil else {
      return
    }
    let timeDuration = self.timeDuration(forString: selectedGoalDuration!)
    let practiceNavigationController = UINavigationController(rootViewController: PracticeSessionViewController(goalDuration: timeDuration))
    self.present(practiceNavigationController, animated: true, completion: {})
  }
}
