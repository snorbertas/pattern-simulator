//
//  Pattern.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 2/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation

/**
 A collection of phases describing the entire pattern. The pattern should be processed as a stack where the last (top) value should be popped first and so on... Tha phase of index 0 should be the last one to spawn.
 */
typealias Pattern = [Phase]

extension Array where Element : Phase {

    /**
     Collection of symbols used to proccess the string representation of the pattern.
     */
    private struct Separators {
        /**
         Symbol used to separate phases.
         */
        static var Phase: Character {
            get {
                return "|"
            }
        }
        
        /**
         Symbol used to separate spawn positions.
         */
        static var Spawn: Character {
            get {
                return ":"
            }
        }
    }
    
    /**
     Initializes the pattern from the given string.
     
     - Parameter string: String to convert.
     */
    init(_ string: String) {
        self.init()
        
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let phasesStr = trimmedString.split(separator: Separators.Phase)
        
        for str in phasesStr {
            let phaseSettings = str.split(separator: Separators.Spawn)
            
            // The first one should be the time interval
            let phase = Phase()
            guard let timeInterval = TimeInterval(phaseSettings.first!) else { continue }
            phase.timeInterval = timeInterval
            
            // The rest are spawn positions
            for spawnStr in 1 ..< phaseSettings.count {
                guard let spawnPos = Int(phaseSettings[spawnStr]) else { continue }
                phase.spawnPositions.append(spawnPos)
            }
            
            self.insert(phase as! Element, at: 0)
        }
    }
    
    /**
     Returns the string representation of current pattern that can later be used to reconstruct a new Pattern object.
     
     - Returns: String representation of pattern.
     */
    func toString() -> String {
        var string = ""
        for phase in self.reversed() {
            
            // Phase separator
            if(string != ""){
                string += String(Separators.Phase)
            }
            
            // Time interval
            string += String(phase.timeInterval)
            
            // Spawns
            for spawnPos in phase.spawnPositions {
                if(string.last != ":"){
                    string += String(Separators.Spawn)
                }
                
                string += String(spawnPos)
            }
        }
        
        return string
    }
    
    /**
     Counts and returns the number of emitters in this pattern.
     
     - Returns: Number of emitters in this pattern.
     */
    func countEmitters() -> Int {
        var maxPos = 0
        for phase in self {
            for spawnPos in phase.spawnPositions {
                if spawnPos > maxPos {
                    maxPos = spawnPos
                }
            }
        }
        
        return maxPos + 1
    }
}
