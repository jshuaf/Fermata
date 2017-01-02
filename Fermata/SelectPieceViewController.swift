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

  var allPieces: Results<Piece>?
  var recentPieces: [Piece]?
  var tableView: UITableView?

  override func viewDidLoad() {
    super.viewDidLoad()
    allPieces = getAllPieces()

    self.title = "Select a Piece"
    tableView = view.addTableView(x: 1, y: 1, w: 1, h: 1)
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = 44
    tableView?.rowHeight = UITableViewAutomaticDimension

    tableView?.register(OptionTableViewCell.self, forCellReuseIdentifier: "recentPiece")
    tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "pieceCategory")
    tableView?.register(ButtonTableViewCell.self, forCellReuseIdentifier: "addPiece")
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if let recentPiecesCount = recentPieces?.count {
        return max(recentPiecesCount, 3)
      } else {
        return 0
      }
    case 1: return 5
    case 2: return 1
    default: return 0
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return recentPieces?.count != nil ? "Recents" : nil
    case 1: return "Browse by Category"
    case 2: return "Add a Piece"
    default: return nil
    }
  }

   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let cell = tableView.cellForRow(at: indexPath)
    return indexPath
  }

  func getAllPieces() -> Results<Piece>? {
    do {
      let realm = try Realm()
      return realm.objects(Piece.self).sorted(byProperty: "name")
    } catch {
      print("\(error)")
      return nil
    }
  }

  func getRecentPieces() -> [Piece]? {
    let piecesSortedByTime = allPieces?.sorted(byProperty: "lastPracticed")
    let recentPieces = Array(piecesSortedByTime!.prefix(3))
    return recentPieces as [Piece]
  }
}
