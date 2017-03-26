//
//  MixerViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import UIKit

class MixerViewController: UIViewController {
    var audioPlayerNode: SeekingAudioPlayerNode?

    @IBOutlet weak var mixingModeSelector: UISegmentedControl!

    @IBAction func updateMixingMode() {
    }
}




//    // Prepare for segue to select audio.
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        (segue.destination as! SongsTableViewController).viewController = self
//    }
//
//    // Code to do phase cancellation or channel isolation
//    let stereoCallback: MTAudioProcessingTapProcessCallback = {
//        (tap: MTAudioProcessingTap,
//        numberFrames: CMItemCount,
//        flags: MTAudioProcessingTapFlags,
//        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
//        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
//        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
//
//        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
//    }
//
//    let rightMonoCallback: MTAudioProcessingTapProcessCallback = {
//        (tap: MTAudioProcessingTap,
//        numberFrames: CMItemCount,
//        flags: MTAudioProcessingTapFlags,
//        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
//        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
//        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
//
//        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
//        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
//        memcpy(audioBufferList[0].mData, audioBufferList[1].mData, Int(audioBufferList[0].mDataByteSize))
//    }
//
//    let leftMonoCallback: MTAudioProcessingTapProcessCallback = {
//        (tap: MTAudioProcessingTap,
//        numberFrames: CMItemCount,
//        flags: MTAudioProcessingTapFlags,
//        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
//        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
//        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
//
//        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
//        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
//        memcpy(audioBufferList[1].mData, audioBufferList[0].mData, Int(audioBufferList[0].mDataByteSize))
//    }
//
//    let phaseCancelCallback: MTAudioProcessingTapProcessCallback = {
//        (tap: MTAudioProcessingTap,
//        numberFrames: CMItemCount,
//        flags: MTAudioProcessingTapFlags,
//        bufferListInOut: UnsafeMutablePointer<AudioBufferList>,
//        numberFramesOut: UnsafeMutablePointer<CMItemCount>,
//        flagsOut: UnsafeMutablePointer<MTAudioProcessingTapFlags>) in
//
//        MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut, flagsOut, nil, numberFramesOut)
//        let audioBufferList: UnsafeMutableAudioBufferListPointer = UnsafeMutableAudioBufferListPointer(bufferListInOut)
//
//        let leftData = audioBufferList[0].mData!.assumingMemoryBound(to: Float.self)
//        let rightData = audioBufferList[1].mData!.assumingMemoryBound(to: Float.self)
//        let numFrames = Int(audioBufferList[0].mDataByteSize) / MemoryLayout<Float>.size
//        for i in 0..<numFrames {
//            let newSample = leftData[i] - rightData[i]
//            leftData[i] = newSample
//            rightData[i] = newSample
//        }
//    }
//
//    @IBAction func applyPhase() {
//        let avPlayerItem = self.audioFilePlayer!.currentItem!
//        let track = avPlayerItem.tracks[0].assetTrack
//        let inputParams = AVMutableAudioMixInputParameters(track: track)
//
//        var processCallback: MTAudioProcessingTapProcessCallback;
//        switch self.mixSegmentedSelector.selectedSegmentIndex {
//        case 0:
//            processCallback = stereoCallback
//        case 1:
//            processCallback = leftMonoCallback
//        case 2:
//            processCallback = rightMonoCallback
//        case 3:
//            processCallback = phaseCancelCallback
//        default:
//            print("WTF")
//            processCallback = stereoCallback
//        }
//
//        var callbacks = MTAudioProcessingTapCallbacks(
//            version: kMTAudioProcessingTapCallbacksVersion_0,
//            clientInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
//            init: nil,
//            finalize: nil,
//            prepare: nil,
//            unprepare: nil,
//            process: processCallback
//        )
//
//        var tap: Unmanaged<MTAudioProcessingTap>?
//        MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PostEffects, &tap)
//
//        inputParams.audioTapProcessor = tap!.takeUnretainedValue()
//        let audioMix = AVMutableAudioMix()
//        audioMix.inputParameters = [inputParams]
//        avPlayerItem.audioMix = audioMix
//    }
