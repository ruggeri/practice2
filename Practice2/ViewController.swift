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
    let audioPlayerNode = SeekingAudioPlayerNode()

    var playbackViewController: PlaybackViewController?
    var scrollingViewController: ScrollingViewController?
    var timePitchViewController: TimePitchViewController?
    var mixerViewController: MixerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayerNode.attach()
        playbackViewController!.selectSong(
            audioFilePath: Bundle.main.bundlePath + "/cant_find_my_way_home.mp3"
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            print("Why is segue identifier empty?")
            print(segue)
            return
        }

        switch segue.identifier! {
        case "EmbedPlaybackVC":
            playbackViewController = (segue.destination as! PlaybackViewController)
            playbackViewController!.audioPlayerNode = audioPlayerNode
        case "EmbedScrollingVC":
            scrollingViewController = (segue.destination as! ScrollingViewController)
            scrollingViewController!.audioPlayerNode = audioPlayerNode
        case "EmbedTimePitchVC":
            timePitchViewController = (segue.destination as! TimePitchViewController)
            timePitchViewController!.audioPlayerNode = audioPlayerNode
        case "EmbedMixerVC":
            mixerViewController = (segue.destination as! MixerViewController)
            mixerViewController!.audioPlayerNode = audioPlayerNode
        default:
            print("Unrecognized segue?")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

