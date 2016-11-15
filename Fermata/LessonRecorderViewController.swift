//
//  LessonRecorderViewController.swift
//  Fermata
//
//  Created by jfang19 on 11/13/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import AVFoundation

class LessonRecorderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	var audioRecorder: AVAudioRecorder?
	var audioPlayer: AVAudioPlayer?

	override func viewDidLoad() {
		super.viewDidLoad()

		recordingsTableView.delegate = self
		recordingsTableView.dataSource = self
		recordingsTableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: "recording")
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

	func getRecordingsDirectory() -> URL? {
		let recordingsDirectory = Helper.getDocumentsDirectory().appendingPathComponent("Recordings")
		do {
			try FileManager.default.createDirectory(at: recordingsDirectory, withIntermediateDirectories: true, attributes: nil)
			return recordingsDirectory
		} catch {
			print("\(error)")
			return nil
		}
	}

	func getRecordings() -> [URL]? {
		let recordingsDirectory = self.getRecordingsDirectory()
		do {
			let recordings = try FileManager.default.contentsOfDirectory(at: recordingsDirectory!, includingPropertiesForKeys: nil, options: [])
			return recordings
		} catch {
			print("\(error)")
			return nil
		}
	}

	@IBOutlet weak var startRecordingButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	@IBOutlet weak var playRecordingButton: UIButton!
	@IBOutlet weak var recordingsTableView: UITableView!

	@IBAction func startRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.requestRecordPermission({(granted: Bool) -> Void in
			let recordingsDirectory = self.getRecordingsDirectory()
			let timestamp = NSDate().timeIntervalSince1970
			let url = recordingsDirectory?.appendingPathComponent("\(timestamp)")
			let settings: [String : Any] = [
				AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey:44100.0,
				AVNumberOfChannelsKey:2,
				AVEncoderAudioQualityKey:AVAudioQuality.medium.rawValue,
				]

			do {
				try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
				try audioSession.setActive(true)
				try self.audioRecorder = AVAudioRecorder(url: url!, settings: settings)
				self.audioRecorder?.record()
			} catch {
				print("\(error)")
			}
		})

	}
	@IBAction func stopRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
			self.audioRecorder?.stop()
			self.recordingsTableView.reloadData()
		} else if audioSession.category == AVAudioSessionCategoryPlayback {
			self.audioPlayer?.stop()
		}
	}
	@IBAction func playRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		let selectedRecording = recordingsTableView.indexPathForSelectedRow?.row
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayback)
			try audioSession.setActive(true)

			let recordings = self.getRecordings()
			let url = (selectedRecording != nil) ? recordings?[selectedRecording!] : recordings?.last
			self.audioPlayer = try AVAudioPlayer(contentsOf: url!, fileTypeHint: "m4a")
			self.audioPlayer?.play()
		} catch {
			print("\(error)")
		}

	}
}
