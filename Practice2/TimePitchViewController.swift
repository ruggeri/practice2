//
//  TimePitchViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import UIKit

class TimePitchViewController: UIViewController {
    let STEP_SIZE = pow(2.0, 1.0 / 12.0)

    var audioPlaybackNode: AudioPlaybackNode?

    @IBOutlet weak var speedModeSelector: UISegmentedControl!
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var stepsLabel: UILabel!

    @IBAction func changeSpeed() {
        let numSteps = speedStepper.value
        let playbackRate = pow(STEP_SIZE, Double(numSteps))

        switch speedModeSelector.selectedSegmentIndex {
        case 0:
            audioPlaybackNode!.changeSpeed(playbackRate: 1.0, pitchShiftCents: 0.0)
        case 1:
            audioPlaybackNode!.changeSpeed(playbackRate: playbackRate, pitchShiftCents: 0.0)
        case 2:
            audioPlaybackNode!.changeSpeed(playbackRate: playbackRate, pitchShiftCents: numSteps * 100.0)
        default:
            print("Invalid speed selection?")
        }

        draw()
    }

    func draw() {
        stepsLabel.text = "Steps: \(self.speedStepper.value)"
    }
}
