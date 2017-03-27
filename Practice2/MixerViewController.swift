//
//  MixerViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class MixerViewController: UIViewController {
    var channelMixerNode: AVAudioUnit?

    @IBOutlet weak var mixingModeSelector: UISegmentedControl!

    @IBAction func updateMixingMode() {
        var mode: ChannelMixerAudioUnit.Mode
        switch mixingModeSelector.selectedSegmentIndex {
        case 0:
            mode = .normal
        case 1:
            mode = .monoLeft
        case 2:
            mode = .monoRight
        case 3:
            mode = .cancelled
        default:
            print("Nonexistent mixingMode segment?")
            mode = .normal
        }

        (channelMixerNode?.auAudioUnit as! ChannelMixerAudioUnit).mode = mode
    }
}
