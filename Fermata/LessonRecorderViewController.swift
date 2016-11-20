//
//  LessonRecorderViewController.swift
//  Fermata
//
//  Created by jfang19 on 11/13/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import AVFoundation
import AudioKit
import Cartography
import Hue

class LessonRecorderViewController: UIViewController {
	var audioRecorder: AVAudioRecorder?
	var audioKitPlayer: AKAudioPlayer?

	@IBOutlet weak var waveformView: UIView!
  @IBOutlet weak var startRecordingButton: UIView!
  @IBOutlet weak var stopRecordingButton: UIImageView!
  @IBOutlet weak var pauseRecordingButton: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var recordingInfoView: UIView!
  @IBOutlet weak var recordingTimeElapsed: FMStopwatch!

	override func viewDidLoad() {
		super.viewDidLoad()

		let mic = AKMicrophone()
		let mainMixer = AKMixer(mic)

		let plot = AKNodeOutputPlot.init(mainMixer, frame: self.waveformView.bounds)
		self.waveformView.addSubview(plot)
		plot.color = UIColor(hue: 0, saturation: 0, brightness: 0.22, alpha: 1)
    plot.waveformLayer.lineWidth = 2.0
    plot.backgroundColor = UIColor.clear

		AudioKit.output = AKBooster(mainMixer, gain: 0)
		AudioKit.start()

    let backgroundGradient = [UIColor.grapefruit, UIColor.cookie].gradient()
    backgroundGradient.frame = self.view.bounds
    self.view.layer.insertSublayer(backgroundGradient, at: 0)

    let startRecordingClicked = UITapGestureRecognizer(target: self, action: #selector(self.startRecording))
    self.startRecordingButton.addGestureRecognizer(startRecordingClicked)
    let stopRecordingClicked = UITapGestureRecognizer(target: self, action: #selector(self.stopRecording))
    self.stopRecordingButton.addGestureRecognizer(stopRecordingClicked)

    self.dateLabel.font = self.dateLabel.font.smallCaps()
	}

	func startRecording() {
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.requestRecordPermission({(granted: Bool) -> Void in
			let recordingsDirectory = Helper.getRecordingsDirectory()
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

        self.recordingTimeElapsed.startTiming()

        self.recordingInfoView.isHidden = false
        self.startRecordingButton.isHidden = true
        self.dateLabel.isHidden = true
			} catch {
				print("\(error)")
			}
		})
	}

	func stopRecording() {
		let audioSession = AVAudioSession.sharedInstance()
		if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
			self.audioRecorder?.stop()
		}
	}

  func pauseRecording() {
    let audioSession = AVAudioSession.sharedInstance()
    if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
      self.audioRecorder?.pause()
    }
  }

	/*@IBAction func playRecording(_ sender: Any) {
		let audioSession = AVAudioSession.sharedInstance()
		let selectedRecording = recordingsTableView.indexPathForSelectedRow?.row
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayback)
			try audioSession.setActive(true)

			let recordings = self.getRecordings()
			let url = (selectedRecording != nil) ? recordings?[selectedRecording!] : recordings?.last

			self.audioKitPlayer = try AKAudioPlayer(file: try AKAudioFile(forReading: url!))
			AudioKit.output = self.audioKitPlayer

			audioKitPlayer?.completionHandler = {
				AudioKit.stop()
			}

			AudioKit.stop()
			AudioKit.start()
			self.audioKitPlayer?.play()
		} catch {
			print("\(error)")
		}

	}*/
}
