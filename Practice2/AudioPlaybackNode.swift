//
//  SeekingAudioPlayerNode.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import Foundation

class AudioPlaybackNode {
    let audioPlayerNode = AVAudioPlayerNode()
    let timePitchNode = AVAudioUnitTimePitch()

    var audioFile: AVAudioFile?
    var audioFileStartFrame = AVAudioFramePosition(0)
    
    // Because this information is only available when playing, we will have to save it when pausing...
    var audioFileCurrentFramePosition: AVAudioFramePosition?
    var audioFileCurrentSampleRate: Double?

    func selectSong(audioFileURL: URL) {
        try! self.audioFile = AVAudioFile(forReading: audioFileURL)
    }

    // Start playing audio
    func play() {
        if (audioFile == nil) {
            return;
        }

        audioPlayerNode.stop()

        audioPlayerNode.scheduleSegment(
            audioFile!,
            startingFrame: AVAudioFramePosition(audioFileStartFrame),
            frameCount: AVAudioFrameCount(audioFile!.length - audioFileStartFrame),
            at: nil
        )
        audioPlayerNode.play()
    }

    func restart() {
        audioFileStartFrame = AVAudioFramePosition(0)
        play()
    }

    func pause() {
        if !self.audioPlayerNode.isPlaying {
            print("pause(): not playing?")
            return
        }

        audioFileStartFrame = currentFramePosition()
        // Hack to force this information to be saved
        currentFramePosition()
        sampleRate()

        audioPlayerNode.stop()
    }

    // Scrolling audio
    func scroll(sign: Double, secondsToStep: Double) {
        let framesToStep = sign * secondsToStep * sampleRate()
        let newStartFramePosition = Int(
            Double(currentFramePosition()) + framesToStep
        )
        audioFileStartFrame = AVAudioFramePosition(min(max(newStartFramePosition, 0), Int(audioFile!.length)))

        play()
    }

    // Change speed of playback
    func changeSpeed(playbackRate: Double, pitchShiftCents: Double) {
        timePitchNode.rate = Float(playbackRate)
        timePitchNode.pitch = Float(pitchShiftCents)
    }

    // Helpers
    func currentFramePosition() -> AVAudioFramePosition {
        // Since this info is only available when playing; use last recorded value when paused.
        if !self.audioPlayerNode.isPlaying {
            return audioFileCurrentFramePosition!
        }

        let sampleTime = audioPlayerNode.playerTime(
            forNodeTime: audioPlayerNode.lastRenderTime!
        )!.sampleTime

        let framePosition = AVAudioFramePosition(
            Int(audioFileStartFrame) + Int(sampleTime)
        )
        
        audioFileCurrentFramePosition = framePosition
        return framePosition
    }
    
    func sampleRate() -> Double {
        // Since this info is only available when playing; use last recorded value when paused.
        if !self.audioPlayerNode.isPlaying {
            return audioFileCurrentSampleRate!
        }

        let sampleRate = audioPlayerNode.playerTime(
            forNodeTime: audioPlayerNode.lastRenderTime!
        )!.sampleRate
        
        audioFileCurrentSampleRate = sampleRate
        return sampleRate
    }
}
