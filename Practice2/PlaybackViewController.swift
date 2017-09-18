//
//  SeekingViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class PlaybackViewController: UIViewController, MPMediaPickerControllerDelegate {
    var audioPlaybackNode: AudioPlaybackNode?

    @IBOutlet weak var currentSongLabel: UILabel!

    // Functions to play/restart/pause.
    @IBAction func play() {
        audioPlaybackNode!.play()
    }

    @IBAction func restart() {
        audioPlaybackNode!.restart()
    }

    @IBAction func pause() {
        audioPlaybackNode!.pause()
    }

    func selectSong(audioFilePath: String) {
        currentSongLabel.text = audioFilePath.components(separatedBy: "/").last!
        print(audioFilePath)
        let audioFileURL = URL(string: audioFilePath)!
        audioPlaybackNode!.selectSong(audioFileURL: audioFileURL)
    }

    // Handle result from modal to pick a new song.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentSongsTable" {
            (segue.destination as! MPMediaPickerController).delegate = self;
        }
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaPicker.dismiss(animated: true, completion: nil)
        let pickedItem = mediaItemCollection.items.first!
        if let assetUrl = pickedItem.assetURL {
            currentSongLabel!.text = pickedItem.title
            selectSong(audioFilePath: assetUrl.absoluteString)
            self.restart()
        }
    }
}
