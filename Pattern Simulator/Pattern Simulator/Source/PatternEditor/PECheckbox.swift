//
//  PEButton.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 2/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation
import Cocoa

/**
 A child class of the NSButton. Intended to be used as a checkbox. This button is meant specifically for the PatternEditor as it contains the x/y coordinates to help identify the button's function.
 */
class PEButton: NSButton {
    /**
     X coordinate for the checkbox matrix.
     */
    var x: Int = 0
    
    /**
     Y coordinate for the checkbox matrix.
     */
    var y: Int = 0
    
    override init(frame frameRect: NSRect) {
         super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
