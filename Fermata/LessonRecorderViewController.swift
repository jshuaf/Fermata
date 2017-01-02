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
import RealmSwift

class LessonRecorderViewController: UIViewController {

  // MARK: Instance Properties
	var audioRecorder: AVAudioRecorder?
	var audioKitPlayer: AKAudioPlayer?
  var lastRecordingURL: URL?
  var recording: Recording?
  var plot: AKNodeOutputPlot?

  // MARK: Outlets
	@IBOutlet weak var waveformView: UIView!
  @IBOutlet weak var startRecordingButton: UIView!
  @IBOutlet weak var stopRecordingButton: UIImageView!
  @IBOutlet weak var pauseRecordingButton: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var recordingInfoView: UIView!
  @IBOutlet weak var recordingTimeElapsed: FMStopwatch!

  // MARK: Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()

    setupWaveformPlot()
		AudioKit.start()

    setupBackground()

    setupButtonGestures()
	}

  // MARK: Setup Methods
  func setupWaveformPlot() {
    let mic = AKMicrophone()
    let mainMixer = AKMixer(mic)
    AudioKit.output = AKBooster(mainMixer, gain: 0)

    self.plot = AKNodeOutputPlot.init(mainMixer, frame: waveformView.bounds)
    plot?.shouldMirror = true
    waveformView.addSubview(plot!)
    plot?.color = UIColor(hue: 0, saturation: 0, brightness: 0.22, alpha: 1)
    plot?.waveformLayer.lineWidth = 2.0
    plot?.backgroundColor = UIColor.clear

  }

  func setupBackground() {
    let backgroundGradient = [UIColor.grapefruit, UIColor.cookie].gradient()
    backgroundGradient.frame = view.bounds
    view.layer.insertSublayer(backgroundGradient, at: 0)
  }

  func setupButtonGestures() {
    let startRecordingClicked = UITapGestureRecognizer(target: self, action: #selector(startRecording))
    startRecordingButton.addGestureRecognizer(startRecordingClicked)
    let stopRecordingClicked = UITapGestureRecognizer(target: self, action: #selector(stopRecording))
    stopRecordingButton.addGestureRecognizer(stopRecordingClicked)
    let pauseRecordingClicked = UITapGestureRecognizer(target: self, action: #selector(togglePauseRecording))
    pauseRecordingButton.addGestureRecognizer(pauseRecordingClicked)
  }

  // MARK: Action Triggers
	func startRecording() {
		let audioSession = AVAudioSession.sharedInstance()
		audioSession.requestRecordPermission({(granted: Bool) -> Void in
			let recordingsDirectory = Helper.directory(atPath: "Recordings")
			let timestamp = Int(Date().timeIntervalSince1970)
			let url = recordingsDirectory?.appendingPathComponent("\(timestamp)")
      self.lastRecordingURL = url

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
        self.plot?.plotType = .rolling
			} catch {
				print("\(error)")
			}
		})
	}

	func stopRecording() {
		let audioSession = AVAudioSession.sharedInstance()
		if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
			audioRecorder?.stop()
      recordingTimeElapsed?.stopTiming()
      self.plot?.plotType = .buffer
      promptTitleEntry()
		}
	}

  func togglePauseRecording() {
    let audioSession = AVAudioSession.sharedInstance()
    if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
      if (audioRecorder?.isRecording)! {
        audioRecorder?.pause()
        recordingTimeElapsed?.pauseTiming()
        pauseRecordingButton?.image = UIImage(named: "Play Icon")
        self.plot?.plotType = .buffer
      } else {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category == AVAudioSessionCategoryPlayAndRecord {
          audioRecorder?.record()
          recordingTimeElapsed?.resumeTiming()
          pauseRecordingButton?.image = UIImage(named: "Pause Icon")
          self.plot?.plotType = .rolling
        }
      }
    }
  }

  func promptTitleEntry() {
    let alert = UIAlertController(title: "Enter Recording Title", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alertAction: UIAlertAction) in
      let titleText = alert.textFields?[0].text!
      let currentDateText = Helper.formattedDate(timestamp: NSDate().timeIntervalSince1970)!
      self.recording = Recording(value: ["title": titleText ?? currentDateText, "dateCreated": NSDate(), "url": self.lastRecordingURL!.path])
      do {
        let realm = try Realm()
        try realm.write {
          realm.add(self.recording!)
        }
      } catch {
        print("\(error)")
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    alert.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "Title"
    })

    self.present(alert, animated: true, completion: nil)
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
