//
//  BrowseSessionsViewController.swift
//  Fermata
//
//  Created by jfang19 on 1/16/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift
import Timepiece

class BrowseSessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var tableView: UITableView?
  var sessionRangeControl: UISegmentedControl?

  var thisWeekSessions: [PracticeSession] = []
  var thisMonthSessions: [Int: [PracticeSession]] = [:]
  var allTimeSessions: [Int: [PracticeSession]] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Practice Sessions"
    view.addGradient(UIColor.sunrise)
    setupTableView()
    setupRangeControl()
    fetchPracticeSessions()
  }

  private func setupRangeControl() {
    let sessionRangeControlContainer = view.addView(x: 1, y: 0.26, w: 1, h: 0.07)
    sessionRangeControlContainer.backgroundColor = .air
    sessionRangeControl = UISegmentedControl(items: ["This Week", "This Month", "All Time"])
    sessionRangeControlContainer.addSubview(sessionRangeControl!)
    sessionRangeControl?.tintColor = .tangerine
    sessionRangeControl?.setTitleTextAttributes(UIFont.fontWithStyle(LabelStyle.Detail.Light()).textAttribute, for: .normal)
    sessionRangeControl?.selectedSegmentIndex = 0
    sessionRangeControl?.addConstraints(x: 1, y: 1, w: 0.91, h: 0.64)
  }

  private func setupTableView() {
    tableView = view.addTableView(x: 1, y: 0.9, w: 1, h: 0.83)
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.rowHeight = 86.0
    tableView?.register(DetailTableViewCell.self, forCellReuseIdentifier: "practiceSession")

    let refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.fetchPracticeSessions), for: .valueChanged)
    tableView?.refreshControl = refreshControl
  }

  @objc private func fetchPracticeSessions(sender: Any? = nil) {
    do {
      let realm = try Realm()
      let practiceSessions = realm.objects(PracticeSession.self)
      thisWeekSessions = Array(practiceSessions.filter("endTime >= %@", Date().firstDateOfWeek))
      thisMonthSessions = practiceSessions.filter("endTime >= %@", Date().firstDateOfMonth).sortedByWeeks()
      allTimeSessions = practiceSessions.sortedByWeeks()
    } catch {
      print("\(error)")
    }
    tableView?.refreshControl?.endRefreshing()
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "practiceSession") as? DetailTableViewCell
    let practiceSession = self.practiceSession(for: indexPath)
    let date = (practiceSession.endTime as? Date)?.dateString(in: .medium)
    let primaryPieceName = practiceSession.primaryPiece.name
    let secondaryPieceDetail = practiceSession.piecesPracticed.count > 1 ? "+ \(practiceSession.piecesPracticed.count - 1) more..." : nil
    cell?.setupTextLabels(titleText: date!, firstDetailText: primaryPieceName, secondDetailText: secondaryPieceDetail)

    let accent: DetailTableViewCellAccent
    let minutes = Int(practiceSession.duration / 60)
    switch practiceSession.duration {
    case 0...30 * 60:
      accent = .Small
    case 30 * 60...75 * 60:
      accent = .Medium
    case 75 * 60 ..< Int.max:
      accent = .Large
    default: accent = .Small
    }

    cell?.setupLeftBadge(accent: accent, mainText: String(minutes), detailText: "min")
    return cell!
  }

  internal func numberOfSections(in tableView: UITableView) -> Int {
    switch sessionRangeControl?.selectedSegmentIndex {
    case 0?: return 1
    case 1?: return thisMonthSessions.keys.count
    case 2?: return allTimeSessions.keys.count
    default: return 0
    }
  }

  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sessionRangeControl?.selectedSegmentIndex {
    case 0?: return thisWeekSessions.count
    case 1?: return thisMonthSessions[(thisMonthSessions.keys.sorted()[section])]!.count
    case 2?: return allTimeSessions[(allTimeSessions.keys.sorted()[section])]!.count
    default: return 0
    }
  }

  internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedSession = practiceSession(for: indexPath)
    _ = self.navigationController?.pushViewController(ViewSessionViewController(session: selectedSession), animated: true)
  }

  private func practiceSession(for indexPath: IndexPath) -> PracticeSession {
    let practiceSession: PracticeSession
    switch sessionRangeControl?.selectedSegmentIndex {
    case 0?:
      practiceSession = thisWeekSessions[indexPath.row]
    case 1?:
      practiceSession = thisMonthSessions[(thisMonthSessions.keys.sorted()[indexPath.section])]![indexPath.row]
    case 2?:
      practiceSession = allTimeSessions[(allTimeSessions.keys.sorted()[indexPath.section])]![indexPath.row]
    default: practiceSession = thisWeekSessions[indexPath.row]
    }
    return practiceSession
  }
}
