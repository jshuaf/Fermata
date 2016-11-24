//
//  RecordingsListViewController.swift
//  Fermata
//
//  Created by jfang19 on 11/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import RealmSwift

class RecordingsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var recordingsTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		recordingsTableView.delegate = self
		recordingsTableView.dataSource = self
		recordingsTableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: "recording")
  }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = recordingsTableView.dequeueReusableCell(withIdentifier: "recording") as? RecordingTableViewCell
		let recording = self.getRecordings()?[indexPath.row]
    guard (recording != nil) else {
      print("Recording not found.")
      return cell!
    }
    cell?.setup(recording: recording!)
    return cell!
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let recordings = self.getRecordings()
		return (recordings != nil ? recordings!.count : 0)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete {
			let recordingToDelete = self.getRecordings()?[indexPath.row]
			do {
				try FileManager.default.removeItem(at: URL(fileURLWithPath: recordingToDelete!.url))
				tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
			} catch {
				print("\(error)")
			}
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func getRecordings() -> [Recording]? {
    do {
      let realm = try Realm()
      return Array(realm.objects(Recording.self).sorted(byProperty: "dateCreated"))
    } catch {
      print("\(error)")
      return nil
    }
	}

}
