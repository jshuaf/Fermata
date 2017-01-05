//
//  AddPieceViewController.swift
//  Fermata
//
//  Created by jfang19 on 1/2/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

class AddPieceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private var tableView: UITableView?
  private var selectedCategoryIndexPath = IndexPath(row: 0, section: 1)

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Add a Piece"

    setupNavigationBar()

    tableView = view.addTableView(x: 1, y: 1, w: 1, h: 1)
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = 44

    tableView?.register(InputTableViewCell.self, forCellReuseIdentifier: "pieceName")
    tableView?.register(CheckmarkTableViewCell.self, forCellReuseIdentifier: "pieceCategory")
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "pieceName") as? InputTableViewCell
      cell?.setup(text: "Title", placeholder: "C Major Scales")
      return cell!
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "pieceCategory") as? CheckmarkTableViewCell
      let category = PieceCategory.allCategories[indexPath.row]
      cell?.setup(text: category, checked: indexPath.row == 0)
      return cell!
    default:
      return tableView.dequeueReusableCell(withIdentifier: "pieceName")!
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      let cellToCheck = tableView.cellForRow(at: indexPath) as? CheckmarkTableViewCell
      let cellToUncheck = tableView.cellForRow(at: selectedCategoryIndexPath) as? CheckmarkTableViewCell
      cellToCheck?.check()
      cellToUncheck?.uncheck()
      selectedCategoryIndexPath = indexPath
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : 5
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "Description" : "Category"
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }

  func setupNavigationBar() {
    let doneItem = UIBarButtonItem()
    doneItem.title = "Done"
    doneItem.action = #selector(self.addPiece)
    self.navigationItem.rightBarButtonItem = doneItem
  }

  func addPiece() {
    let pieceTitleCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? InputTableViewCell
    let pieceTitle = pieceTitleCell?.textField?.text
    let pieceCategory = PieceCategory.allCategories[selectedCategoryIndexPath.row]
    guard pieceTitle != nil else {
      return
    }

    let piece = Piece(value: ["name": pieceTitle, "category": pieceCategory])
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(piece)
      }
    } catch {
      print("\(error)")
    }
    let numberOfControllers = self.navigationController?.viewControllers.count
    _ = self.navigationController?.viewControllers[numberOfControllers! - 1] as? SelectPieceViewController
    _ = self.navigationController?.popViewController(animated: true)

  }

}
