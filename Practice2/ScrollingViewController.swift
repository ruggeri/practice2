//
//  ScrollingViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import UIKit

class ScrollingViewController: UIViewController {
    var audioPlayerNode: SeekingAudioPlayerNode?

    @IBOutlet weak var scrollSecondsSelector: UISegmentedControl!

    // Functions to scroll backward/forward
    @IBAction func scrollBack() {
        audioPlayerNode!.scroll(sign: -1.0, secondsToStep: secondsToStep())
    }

    @IBAction func scrollForward() {
        audioPlayerNode!.scroll(sign: +1.0, secondsToStep: secondsToStep())
    }

    func secondsToStep() -> Double {
        switch scrollSecondsSelector.selectedSegmentIndex {
        case 0:
            return 1.0
        default:
            return Double(scrollSecondsSelector.selectedSegmentIndex) * 2.0
        }
    }
}
