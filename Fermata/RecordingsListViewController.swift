//
//  RecordingsListViewController.swift
//  Fermata
//
//  Created by jfang19 on 11/17/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

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
		let recordingName = self.getRecordings()?[indexPath.row].lastPathComponent
		let timestamp = Date(timeIntervalSince1970: TimeInterval(recordingName!)!)
		let date = DateFormatter.localizedString(from: timestamp, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.short)
		cell?.setup(title: "\(date)")
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
				try FileManager.default.removeItem(at: recordingToDelete!)
				tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
			} catch {
				print("\(error)")
			}
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func getRecordings() -> [URL]? {
		let recordingsDirectory = Helper.getRecordingsDirectory()
		do {
			let recordings = try FileManager.default.contentsOfDirectory(at: recordingsDirectory!, includingPropertiesForKeys: nil, options: [])
			return recordings
		} catch {
			print("\(error)")
			return nil
		}
	}

}
