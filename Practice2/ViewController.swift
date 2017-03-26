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
    let stepSize = pow(2.0, 1.0 / 12.0)

    var audioFilePlayer: AVPlayer?
    
    // For playback speed adjustment
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var speedSegmentedControl: UISegmentedControl!
    // For jumping back/forward
    @IBOutlet weak var segmentedScrollSelector: UISegmentedControl!

    // Used for phase cancelation.
    @IBOutlet weak var mixSegmentedSelector: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectSong(Bundle.main.bundlePath + "/cant_find_my_way_home.mp3")
        self.draw();
    }
    
    func selectSong(_ audioFilePath: String) {
        print(audioFilePath)
        let audioFileURL = URL(fileURLWithPath: audioFilePath)
        self.audioFilePlayer = AVPlayer(url: audioFileURL)
    }
    
    func draw() {
        self.stepLabel.text = "Steps: \(self.speedStepper.value)"
    }
    
    // Start and stop audio
    @IBAction func playAudio() {
        self.audioFilePlayer!.play()
        applyPhase()
        changeSpeed()
    }
    
    @IBAction func restartAudio() {
        self.audioFilePlayer!.seek(to: kCMTimeZero)
        self.audioFilePlayer!.play()
    }
    
    @IBAction func pauseAudio() {
        self.audioFilePlayer!.pause()
    }

    // Adjust playback speed
    @IBAction func changeSpeed() {
        var rate = 0.0
        if self.speedSegmentedControl.selectedSegmentIndex == 0 {
            rate = 1.0
        } else {
            let numSteps = self.speedStepper.value
            rate = pow(self.stepSize, Double(numSteps))
        }

        self.audioFilePlayer!.rate = Float(rate)
        
        if self.speedSegmentedControl.selectedSegmentIndex == 2 {
            self.audioFilePlayer!.currentItem!.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmVarispeed
        } else {
            self.audioFilePlayer!.currentItem!.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmSpectral
        }

        self.draw()
    }

    // Scrolling audio
    @IBAction func scrollBack() {
        scroll(-1.0)
    }
    
    @IBAction func scrollForward() {
        scroll(+1.0)
    }
    
    func scroll(_ sign: Double) {
        let newStartSeconds: Double = max(
            self.audioFilePlayer!.currentTime().seconds + sign * secondsToStep(),
            0
        )
        
        let newStartTime = CMTime(
            seconds: newStartSeconds, preferredTimescale: self.audioFilePlayer!.currentTime().timescale
        )
        
        self.audioFilePlayer!.seek(to: newStartTime)
    }

    func secondsToStep() -> Double {
        switch self.segmentedScrollSelector.selectedSegmentIndex {
        case 0: return 1.0
        default:
            return Double(self.segmentedScrollSelector.selectedSegmentIndex) * 2.0
        }
    }
    
    // Prepare for segue to select audio.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! SongsTableViewController).viewController = self
    }
    
    // Code to do phase cancellation or channel isolation
    let stereoCallback: MTAudioProcessingTapProcessCallback = {
        (tap: MTAudioProcessingTap,
        numberFrames: CMItemCount,
        flags: MTAudioProcessingTapFlags,
        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
        
        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
    }

    let rightMonoCallback: MTAudioProcessingTapProcessCallback = {
        (tap: MTAudioProcessingTap,
        numberFrames: CMItemCount,
        flags: MTAudioProcessingTapFlags,
        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
        
        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
        memcpy(audioBufferList[0].mData, audioBufferList[1].mData, Int(audioBufferList[0].mDataByteSize))
    }
    
    let leftMonoCallback: MTAudioProcessingTapProcessCallback = {
        (tap: MTAudioProcessingTap,
        numberFrames: CMItemCount,
        flags: MTAudioProcessingTapFlags,
        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
        
        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
        memcpy(audioBufferList[1].mData, audioBufferList[0].mData, Int(audioBufferList[0].mDataByteSize))
    }
    
    let phaseCancelCallback: MTAudioProcessingTapProcessCallback = {
        (tap: MTAudioProcessingTap,
        numberFrames: CMItemCount,
        flags: MTAudioProcessingTapFlags,
        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
        
        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
        
        let leftData = audioBufferList[0].mData!.assumingMemoryBound(to: Float.self)
        let rightData = audioBufferList[1].mData!.assumingMemoryBound(to: Float.self)
        let numFrames = Int(audioBufferList[0].mDataByteSize) / MemoryLayout<Float>.size
        for i in 0..<numFrames {
            let newSample = leftData[i] - rightData[i]
            leftData[i] = newSample
            rightData[i] = newSample
        }
    }
    
    @IBAction func applyPhase() {
        let avPlayerItem = self.audioFilePlayer!.currentItem!
        let track = avPlayerItem.tracks[0].assetTrack
        let inputParams = AVMutableAudioMixInputParameters(track: track)
        
        var processCallback: MTAudioProcessingTapProcessCallback;
        switch self.mixSegmentedSelector.selectedSegmentIndex {
        case 0:
            processCallback = stereoCallback
        case 1:
            processCallback = leftMonoCallback
        case 2:
            processCallback = rightMonoCallback
        case 3:
            processCallback = phaseCancelCallback
        default:
            print("WTF")
            processCallback = stereoCallback
        }
        
        var callbacks = MTAudioProcessingTapCallbacks(
            version: kMTAudioProcessingTapCallbacksVersion_0,
            clientInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            init: nil,
            finalize: nil,
            prepare: nil,
            unprepare: nil,
            process: processCallback
        )
        
        var tap: Unmanaged<MTAudioProcessingTap>?
        MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PostEffects, &tap)
        
        inputParams.audioTapProcessor = tap!.takeUnretainedValue()
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = [inputParams]
        avPlayerItem.audioMix = audioMix
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

