//
//  ViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/25/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    let audioGraph = AudioGraph()

    var playbackViewController: PlaybackViewController?
    var scrollingViewController: ScrollingViewController?
    var timePitchViewController: TimePitchViewController?
    var mixerViewController: MixerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Begin setting up the audio graph.
        audioGraph.attach() {
            // mixerViewController needs this, but it is late initialized...
            self.mixerViewController?.channelMixerNode = self.audioGraph.channelMixerNode!
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            print("Why is segue identifier empty?")
            print(segue)
            return
        }

        // Wire up the embedded views.
        switch segue.identifier! {
        case "EmbedPlaybackVC":
            playbackViewController = (segue.destination as! PlaybackViewController)
            playbackViewController!.audioPlaybackNode = audioGraph.audioPlaybackNode
        case "EmbedScrollingVC":
            scrollingViewController = (segue.destination as! ScrollingViewController)
            scrollingViewController!.audioPlaybackNode = audioGraph.audioPlaybackNode
        case "EmbedTimePitchVC":
            timePitchViewController = (segue.destination as! TimePitchViewController)
            timePitchViewController!.audioPlaybackNode = audioGraph.audioPlaybackNode
        case "EmbedMixerVC":
            mixerViewController = (segue.destination as! MixerViewController)
            mixerViewController!.channelMixerNode = audioGraph.channelMixerNode
        default:
            print("Unrecognized segue?")
        }
    }
}

