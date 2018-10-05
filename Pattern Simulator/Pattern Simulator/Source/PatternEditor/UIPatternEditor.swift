//
//  UIPatternEditor.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 2/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation
import Cocoa

/**
 A simple pattern editor as a child of NSView.
 */
class UIPatternEditor: NSView {
    /**
     The default time interval inbetween each phase.
     */
    var timeInterval: TimeInterval = 0.1
    
    /**
     Number of emittters. Note: Use *emitters* instead.
     */
    private var _emitters = 5
    
    /**
     Number of phases. Note: Use *phases* instead.
     */
    private var _phases = 10
    
    /**
     A matrix of PEButtons which represented checkboxes to toggle the emitters *X* spawn state at the given phase *Y*. In the form of *checkboxes[X][Y]*
     */
    private var checkboxes = [[PEButton]]()
    
    /**
     Constructor for UIPatternEditor.
     - Parameter fitInto: Initial frame.
     */
    init(_ fitInto: NSRect){
        super.init(frame: fitInto)
        
        fixCheckboxes()
    }

    /**
     Event triggered by checkboxes being changed by the user.
     */
    @objc func checkBoxChanged(_ sender: PEButton) {
        // Can be used for future improvements.
        //print(sender.x, sender.y)
    }
    
    /**
     Removes all checkboxes from editor.
     */
    func removeAllCheckboxes(){
        for y in 0 ..< checkboxes.count {
            for x in 0 ..< checkboxes[y].count {
                checkboxes[y][x].removeFromSuperview()
            }
            checkboxes[y].removeAll()
        }
        checkboxes.removeAll()
    }
    
    /**
     Sets the state of given checkbox matrix coordinates.
     - Parameter x: x index for checkbox matrix.
     
     - Parameter y: y index for checkbox matrix.
     
     - Parameter to: the state to change to.
     */
    func setCheckboxState(_ x: Int, _ y: Int, to: NSControl.StateValue){
        if(y >= checkboxes.count) { return }
        if(x >= checkboxes[y].count) { return }
        checkboxes[y][x].state = to
    }
    
    /**
     Creates and returns a new checkbox as a PEButton.
     - Parameter x: x index for checkbox matrix.
     
     - Parameter y: y index for checkbox matrix.
     */
    func newCheckbox(_ x: Int, _ y: Int) -> PEButton {
        let checkbox = PEButton(checkboxWithTitle: "", target: self, action: #selector(checkBoxChanged(_:)))
        
        checkbox.frame.size = CGSize(width: 14, height: 14)
        checkbox.x = x
        checkbox.y = y
        
        self.addSubview(checkbox)
        
        return checkbox
    }
    
    /**
     Reconstruct all checkboxes according to current emitter and phases count.
     */
    func fixCheckboxes(){
        removeAllCheckboxes()
        
        for y in 0 ..< _phases {
            var spawns = [PEButton]()
            for x in 0 ..< _emitters {
                spawns.append(newCheckbox(x, y))
            }
            
            checkboxes.append(spawns)
        }
        
        fixPositions()
    }
    
    /**
     Adjusts every checkbox's position to tidy spacing according to current emitter and phases count.
     */
    func fixPositions(){
        let gapX = self.frame.width / CGFloat(_emitters)
        let boxSize: CGFloat = 15
        let offsetX = (gapX / 2) - (boxSize / 2)
        let topY = self.frame.size.height - (boxSize * 1.5)
        
        for y in 0 ..< _phases {
            for x in 0 ..< _emitters {
                checkboxes[y][x].frame.origin.x = CGFloat(x) * gapX + offsetX
                checkboxes[y][x].frame.origin.y = topY - (CGFloat(y) * boxSize * 1.5)
            }
        }
    }
    
    /**
     Using the current state of the editor, constructs and returns a Pattern.
     */
    func getPattern() -> Pattern {
        var pattern = Pattern()
        
        for y in 0 ..< _phases {
            let phase = Phase()
            phase.timeInterval = timeInterval
            
            for x in 0 ..< _emitters {
                if(checkboxes[y][x].state == .on){
                    phase.spawnPositions.append(x)
                }
            }
            
            pattern.insert(phase, at: 0)
        }
        
        return pattern
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Number of emittters.
     */
    var emitters: Int {
        get {
            return _emitters
        }
        
        set {
            if(_emitters == newValue) { return }
            _emitters = newValue
            fixCheckboxes()
        }
    }
    
    /**
     Number of phases.
     */
    var phases: Int {
        get {
            return _phases
        }
        
        set {
            if(_phases == newValue) { return }
            _phases = newValue
            fixCheckboxes()
        }
    }
}
