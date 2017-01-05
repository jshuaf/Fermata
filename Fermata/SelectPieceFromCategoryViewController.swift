//
//  SelectPieceFromCategoryViewController.swift
//  Fermata
//
//  Created by jfang19 on 1/3/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

class SelectPieceFromCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private var piecesInCategory: Results<Piece>?
  private var tableView: UITableView?
  private var category: PieceCategory?

  weak var delegate: PracticeSessionDelegate?

  convenience init(category: PieceCategory) {
    self.init()
    self.category = category
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    piecesInCategory = getPiecesInCategory()
    tableView?.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = category?.rawValue

    piecesInCategory = getPiecesInCategory()

    tableView = view.addTableView(x: 1, y: 1, w: 1, h: 1)
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = 44

    tableView?.register(OptionTableViewCell.self, forCellReuseIdentifier: "pieceInCategory")
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "pieceInCategory") as? OptionTableViewCell
    let piece = piecesInCategory?[indexPath.row]
    cell?.setup(text: (piece?.name)!)
    return cell!
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return piecesInCategory!.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return category?.rawValue
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPiece = piecesInCategory?[indexPath.row]
    delegate?.selectPiece(selectedPiece!)
    _ = self.navigationController?.popToRootViewController(animated: true)
  }

  func getPiecesInCategory() -> Results<Piece>? {
    do {
      let realm = try Realm()
      return realm.objects(Piece.self).filter("category == %@", category?.rawValue as Any)
    } catch {
      print("\(error)")
      return nil
    }
  }

}
