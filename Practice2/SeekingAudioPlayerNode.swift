//
//  SeekingAudioPlayerNode.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import Foundation

class SeekingAudioPlayerNode {
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile?
    var audioFileStartFrame = AVAudioFramePosition(0)
    let timePitchNode = AVAudioUnitTimePitch()

    func attach() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(timePitchNode)
        audioEngine.connect(audioPlayerNode, to: timePitchNode, format: nil)
        audioEngine.connect(timePitchNode, to: audioEngine.mainMixerNode, format: nil)
        try! audioEngine.start()
    }

    func selectSong(audioFileURL: URL) {
        try! self.audioFile = AVAudioFile(forReading: audioFileURL)
    }

    // Start and stop audio
    func play() {
        if audioPlayerNode.isPlaying {
            return
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
        audioPlayerNode.stop()
        play()
    }

    func pause() {
        audioFileStartFrame = currentFramePosition()
        audioPlayerNode.stop()
    }

    // Scrolling audio
    func scroll(sign: Double, secondsToStep: Double) {
        let framesToStep = sign * secondsToStep * sampleRate()
        let newStartFramePosition = Int(
            Double(currentFramePosition()) + framesToStep
        )
        audioFileStartFrame = AVAudioFramePosition(min(max(newStartFramePosition, 0), Int(audioFile!.length)))

        audioPlayerNode.stop()
        play()
    }

    // Change speed of playback
    func changeSpeed(playbackRate: Double, pitchShiftCents: Double) {
        timePitchNode.rate = Float(playbackRate)
        timePitchNode.pitch = Float(pitchShiftCents)
    }

    // Helpers
    func currentFramePosition() -> AVAudioFramePosition {
        let sampleTime = audioPlayerNode.playerTime(
            forNodeTime: audioPlayerNode.lastRenderTime!
        )!.sampleTime

        return AVAudioFramePosition(
            Int(audioFileStartFrame) + Int(sampleTime)
        )
    }
    
    func sampleRate() -> Double {
        return audioPlayerNode.playerTime(
            forNodeTime: audioPlayerNode.lastRenderTime!
        )!.sampleRate
    }
}
