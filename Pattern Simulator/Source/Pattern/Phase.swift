//
//  Phase.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 6/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation

/**
 A phase describes the moment when particles are being spawned. It holds the positions of where the particles should spawn. It also stores the time interval till next phase.
 */
class Phase {
    /**
     Time till next phase.
     */
    var timeInterval: TimeInterval = 0
    
    /**
     Indices of emitters that should spawn the particles.
     */
    var spawnPositions = [Int]()
}
