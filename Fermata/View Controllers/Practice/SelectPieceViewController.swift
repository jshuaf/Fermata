//
//  SelectPieceViewController.swift
//  Fermata
//
//  Created by jfang19 on 12/21/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

class SelectPieceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private var allPieces: Results<Piece>?
  private var recentPieces: [Piece]?
  private var tableView: UITableView?

  weak var delegate: PracticeSessionDelegate?

  convenience init(title: String) {
    self.init()
    self.title = title
  }

  override internal func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    allPieces = getAllPieces()
    recentPieces = getRecentPieces()
    tableView?.reloadData()
  }

  override internal func viewDidLoad() {
    super.viewDidLoad()

    allPieces = getAllPieces()
    recentPieces = getRecentPieces()

    tableView = view.addTableView(x: 1, y: 1, w: 1, h: 1)
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = 44

    tableView?.register(OptionTableViewCell.self, forCellReuseIdentifier: "recentPiece")
    tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "pieceCategory")
    tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "addPiece")
  }

  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "recentPiece") as? OptionTableViewCell
      let piece = recentPieces?[indexPath.row]
      cell?.setup(text: (piece?.name)!)
      return cell!
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "pieceCategory") as? ButtonTableViewCell
      let category = PieceCategory.allCategories[indexPath.row]
      cell?.setup(text: category)
      return cell!
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "addPiece") as? ButtonTableViewCell
      cell?.setup(text: "Add a piece")
      return cell!
    default:
      return tableView.dequeueReusableCell(withIdentifier: "recentPiece")!
    }
  }

  internal func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if let recentPiecesCount = recentPieces?.count {
        return min(recentPiecesCount, 3)
      } else {
        return 0
      }
    case 1: return allPieces?.count == nil ? 0 : 5
    case 2: return 1
    default: return 0
    }
  }

  internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return allPieces?.count != nil ? "Recents" : nil
    case 1: return allPieces?.count != nil ? "Browse by Category" : nil
    case 2: return "Add a Piece"
    default: return nil
    }
  }

  internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let selectedPiece = recentPieces?[indexPath.row]
      delegate?.setPiece(selectedPiece!)
      _ = self.navigationController?.popViewController(animated: true)
    case 1:
      let selectedCategory = PieceCategory(rawValue: PieceCategory.allCategories[indexPath.row])
      let nextViewController = SelectPieceFromCategoryViewController(category: selectedCategory!)
      nextViewController.delegate = delegate
      self.navigationController?.pushViewController(nextViewController, animated: true)
    case 2:
      let nextViewController = AddPieceViewController()
      self.navigationController?.pushViewController(nextViewController, animated: true)
      return
    default: return
    }
  }

  internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if allPieces?.count == nil {
      return section != 2 ? 0.01 : 40
    } else {
      return section == 0 ? 40 : 20
    }
  }

  private func getAllPieces() -> Results<Piece>? {
    do {
      let realm = try Realm()
      return realm.objects(Piece.self).sorted(byProperty: "name")
    } catch {
      print("\(error)")
      return nil
    }
  }

  private func getRecentPieces() -> [Piece]? {
    let piecesSortedByTime = allPieces?.sorted(byProperty: "lastPracticed")
    let recentPieces = Array(piecesSortedByTime!.prefix(3))
    return recentPieces as [Piece]
  }
}
