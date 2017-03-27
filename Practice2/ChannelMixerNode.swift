//
//  ChannelMixerNode.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import Foundation

class ChannelMixerAudioUnit : AUAudioUnit {
    static let channelMixerDescription = AudioComponentDescription(
        componentType: kAudioUnitType_Effect,
        componentSubType: 0,
        componentManufacturer: 255,
        componentFlags: 0,
        componentFlagsMask: 0
    )

    static let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)

    enum Mode {
        case cancelled
        case monoLeft
        case monoRight
        case normal
    }

    class func getInstance(callback: @escaping (AVAudioUnit?, Error?) -> Void) {
        AVAudioUnit.instantiate(
            with: channelMixerDescription,
            options: AudioComponentInstantiationOptions(rawValue: 0),
            completionHandler: callback
        )
    }

    class func register() {
        AUAudioUnit.registerSubclass(
            ChannelMixerAudioUnit.self,
            as: channelMixerDescription,
            name: "ChannelMixerAudioUnit",
            version: 1
        )
    }

    var inputBusses_: AUAudioUnitBusArray?
    var outputBusses_: AUAudioUnitBusArray?
    var internalRenderBlock_: AUInternalRenderBlock?
    var mode: Mode

    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        mode = .normal

        try! super.init(componentDescription: componentDescription, options: options)

        internalRenderBlock_ = self.process
        inputBusses_ = AUAudioUnitBusArray(audioUnit: self, busType: .input, busses: [
            try AUAudioUnitBus(format: ChannelMixerAudioUnit.defaultFormat)
            ])
        outputBusses_ = AUAudioUnitBusArray(audioUnit: self, busType: .output, busses: [
            try AUAudioUnitBus(format: ChannelMixerAudioUnit.defaultFormat)
            ])
    }

    // Does the actual work of transforming the input.
    func process(actionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                 timestamp: UnsafePointer<AudioTimeStamp>,
                 frameCount: AUAudioFrameCount,
                 outputBusNumber: Int,
                 outputData: UnsafeMutablePointer<AudioBufferList>,
                 realtimeEventListHead: UnsafePointer<AURenderEvent>?,
                 pullInputBlock: AURenderPullInputBlock?) -> AUAudioUnitStatus {

        let err = pullInputBlock!(actionFlags, timestamp, frameCount, 0, outputData)
        if err != 0 { return err }
    
        withUnsafePointer(to: &outputData[0].mBuffers) { (buffersPointer) in
            let buffers = UnsafeBufferPointer<AudioBuffer>(start: buffersPointer, count: Int(outputData[0].mNumberBuffers))
    
            switch (self.mode) {
            case .normal:
                // Do nothing!
                break
            case .monoLeft:
                memcpy(buffers[1].mData, buffers[0].mData, Int(buffers[0].mDataByteSize))
            case .monoRight:
                memcpy(buffers[0].mData, buffers[1].mData, Int(buffers[0].mDataByteSize))
            case .cancelled:
                let leftData = buffers[0].mData!.assumingMemoryBound(to: Float.self)
                let rightData = buffers[1].mData!.assumingMemoryBound(to: Float.self)
                let numFrames = Int(buffers[0].mDataByteSize) / MemoryLayout<Float>.size
                for i in 0..<numFrames {
                    let newSample = leftData[i] - rightData[i]
                    leftData[i] = newSample
                    rightData[i] = newSample
                }
            }
        }
    
        return 0
    }

    override var internalRenderBlock: AUInternalRenderBlock {
        get {
            return internalRenderBlock_!
        }
    }

    override var inputBusses: AUAudioUnitBusArray {
        get {
            return inputBusses_!
        }
    }

    override var outputBusses: AUAudioUnitBusArray {
        get {
            return inputBusses_!
        }
    }
}
