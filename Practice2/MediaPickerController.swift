//
//  MediaPicker.swift
//  Practice2
//
//  Created by Ned Ruggeri on 9/17/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaPickerController: MPMediaPickerController {
    required init?(coder aDecoder: NSCoder) {
        super.init(mediaTypes: .music)
        self.allowsPickingMultipleItems = false
        self.showsCloudItems = false
    }
}
