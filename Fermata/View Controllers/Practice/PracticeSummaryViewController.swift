//
//  PracticeSummaryViewController.swift
//  Fermata
//
//  Created by jfang19 on 1/12/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

class PracticeSummaryViewController: UIViewController {
  var practiceSessionDuration: TimeInterval
  let popoverView = Popover(size: .Large)
  var weekPracticeSessions: Results<PracticeSession>?
  var totalWeekPracticeTime: TimeInterval? {
    get {
      guard weekPracticeSessions != nil else {
        return nil
      }
      let calendar = NSCalendar.current
      var total = 0
      for practiceSession in weekPracticeSessions! {
        let start = practiceSession.startTime as? Date
        let end = practiceSession.endTime as? Date
        total += calendar.dateComponents(Set([Calendar.Component.second]), from: start!, to: end!).second!
      }
      return TimeInterval(total)
    }
  }

  init(practiceSessionDuration: TimeInterval) {
    self.practiceSessionDuration = practiceSessionDuration
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchPracticeSessions()
    view.addGradient(UIColor.sunrise)
    setupPopover()
    setupWeekStats()
    setupSessionDuration()
  }

  private func fetchPracticeSessions() {
    do {
      let realm = try Realm()
      weekPracticeSessions = realm.objects(PracticeSession.self).filter("endTime >= %@", Date().firstDateOfWeek)
    } catch {
      print("\(error)")
    }
  }

  private func setupPopover() {
    view.addSubview(popoverView)
    popoverView.addLabel(style: LabelStyle.HeaderTwo.Primary(), x: 1, y: 0.2, text: "Practice Complete!")
    popoverView.addButton(style: ButtonStyle.MediumIcon(), x: 1, y: 1.81, text: "Continue", iconName: "Continue Arrow", target: self, action: #selector(self.dismissSummary))
  }

  private func setupWeekStats() {
    let weekPositionView = popoverView.addView(x: 1, y: 0.52, w: 0.77, h: 0.15)
    weekPositionView.addLabel(style: LabelStyle.Massive.Primary(), x: 1, y: 0.74, text: weekPracticeSessions!.count.ordinal)
    weekPositionView.addLabel(style: LabelStyle.HeaderThree.Subtle(), x: 1.01, y: 1.74, text: "time this week")
    let weekTotalView = popoverView.addView(x: 1, y: 1.4, w: 0.77, h: 0.15)
    weekTotalView.addLabel(style: LabelStyle.Massive.Primary(), x: 1, y: 0.74, text: FMStopwatch.stringFromTime(timeInterval: totalWeekPracticeTime!))
    weekTotalView.addLabel(style: LabelStyle.HeaderThree.Subtle(), x: 1.01, y: 1.74, text: "total this week")
  }

  private func setupSessionDuration() {
    let sessionDurationView = popoverView.addView(x: 1, y: 0.98, w: 0.41, h: 0.15)
    sessionDurationView.addLabel(style: LabelStyle.Massive.Primary(), x: 1, y: 0.74, text: FMStopwatch.stringFromTime(timeInterval: practiceSessionDuration))
    sessionDurationView.addLabel(style: LabelStyle.HeaderThree.Subtle(), x: 1.01, y: 1.74, text: "session duration")
  }

  @objc private func dismissSummary() {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    present((appDelegate?.tabBarController())!, animated: true, completion: nil)
  }
}
