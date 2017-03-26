//
//  SeekingViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import UIKit

class PlaybackViewController: UIViewController {
    var audioPlayerNode: SeekingAudioPlayerNode?

    @IBOutlet weak var currentSongLabel: UILabel!

    // Functions to play/restart/pause.
    @IBAction func play() {
        audioPlayerNode!.play()
    }

    @IBAction func restart() {
        audioPlayerNode!.restart()
    }

    @IBAction func pause() {
        audioPlayerNode!.pause()
    }

    func selectSong(audioFilePath: String) {
        currentSongLabel.text = audioFilePath.components(separatedBy: "/").last!
        print(audioFilePath)
        let audioFileURL = URL(fileURLWithPath: audioFilePath)
        audioPlayerNode!.selectSong(audioFileURL: audioFileURL)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentSongsTable" {
            (segue.destination as! SongsTableViewController).songSelectionCallback = {
                (audioFilePath: String) in
                self.selectSong(audioFilePath: audioFilePath)
                self.restart()
            }
        }
    }
}
