//
//  ViewController.swift
//  Fermata
//
//  Created by jfang19 on 11/13/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import AVFoundation

class LessonRecorderViewController: UIViewController {
	var audioRecorder: AVAudioRecorder?
	var audioPlayer: AVAudioPlayer?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBOutlet weak var startRecordingButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!
	@IBOutlet weak var playRecordingButton: UIButton!
	
	@IBAction func startRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.requestRecordPermission({(granted: Bool)-> Void in
			try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			try! audioSession.setActive(true)
			
			let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
			let settings: [String : Any] = [
				AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey:44100.0,
				AVNumberOfChannelsKey:2,
				AVEncoderAudioQualityKey:AVAudioQuality.medium.rawValue,
				]
			
			do {
				try self.audioRecorder = AVAudioRecorder(url: url, settings: settings)
				self.audioRecorder?.record()
			} catch {
				print("\(error)")
			}
		})
	
	}
	@IBAction func stopRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		if (audioSession.category == AVAudioSessionCategoryPlayAndRecord) {
			self.audioRecorder?.stop()
		} else if (audioSession.category == AVAudioSessionCategoryPlayback) {
			self.audioPlayer?.stop()
		}
	}
	@IBAction func playRecording(_ sender: Any) {
		let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayback)
			try audioSession.setActive(true)

			self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: "m4a")
			self.audioPlayer?.play()
		} catch {
			print("\(error)")
		}
		
	}
}

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	let documentsDirectory = paths[0]
	return documentsDirectory
}
