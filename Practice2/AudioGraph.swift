//
//  AudioGraph.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/26/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import AVFoundation
import Foundation

// Just a helper to wire up the graph of audio nodes.
class AudioGraph {
    let audioEngine = AVAudioEngine()
    let audioPlaybackNode = AudioPlaybackNode()
    var channelMixerNode: AVAudioUnit?

    func attach(callback: @escaping () -> ()) {
        ChannelMixerAudioUnit.register()

        // Getting an AVAudioNode instance must be done asynchronously,
        // for some unknown reason.
        ChannelMixerAudioUnit.getInstance { (channelMixerNode, error) in
            self.channelMixerNode = channelMixerNode
            self.finishAttaching()
            callback()
        }
    }

    func finishAttaching() {
        let channelMixerNode = self.channelMixerNode!

        audioEngine.attach(audioPlaybackNode.audioPlayerNode)
        audioEngine.attach(audioPlaybackNode.timePitchNode)
        audioEngine.attach(channelMixerNode)
        audioEngine.connect(audioPlaybackNode.audioPlayerNode, to: audioPlaybackNode.timePitchNode, format: nil)
        audioEngine.connect(audioPlaybackNode.timePitchNode, to: channelMixerNode, format: nil)
        audioEngine.connect(channelMixerNode, to: audioEngine.mainMixerNode, format: nil)
        try! audioEngine.start()
    }

}
