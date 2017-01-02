//
//  MetronomeViewController.swift
//  Fermata
//
//  Created by jfang19 on 12/16/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class MetronomeViewController: UIViewController {
  // MARK: Instance variables
  var metronome: Metronome?

  // MARK: Outlets
  @IBOutlet weak var startMetronomeButton: UIButton!
  @IBOutlet weak var stopMetronomeButton: UIButton!
  @IBOutlet weak var inputTempoButton: UIButton!
  @IBOutlet weak var tempoSlider: UISlider!

  // MARK: Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.metronome = Metronome()
    do {
      try self.metronome?.setup()
      self.metronome?.onTempoChange = {(newTempo: Double) -> Void in
        self.tempoSlider.setValue(Float(newTempo), animated: false)
      }
    } catch {
      print("\(error)")
    }
  }

  // MARK: Actions
  @IBAction func startMetronome(_ sender: Any) {
    metronome!.start()
  }
  @IBAction func stopMetronome(_ sender: Any) {
    metronome!.stop()
  }
  @IBAction func changeMetronomeTempo(_ sender: Any) {
    metronome!.changeTempo(newTempo: Double(tempoSlider.value))
  }
  @IBAction func inputTempo(_ sender: Any) {
    metronome!.addTempoInput(tempoInput: Date().timeIntervalSince1970)
  }

}
