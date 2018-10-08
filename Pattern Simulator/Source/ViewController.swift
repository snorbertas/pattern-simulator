//
//  ViewController.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 2/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation
import Cocoa
import SpriteKit

class ViewController: NSViewController {
    @IBOutlet weak var sceneViewSpace: NSView!
    @IBOutlet weak var patternEditorSpace: NSView!
    @IBOutlet weak var emittersNumberField: NSTextField!
    @IBOutlet weak var phasesNumberField: NSTextField!
    @IBOutlet weak var timeIntervalNumberField: NSTextField!
    @IBOutlet weak var gravityNumberField: NSTextField!
    
    let sceneView = SKView()
    var simulation: Simulation!
    var patternEditor: UIPatternEditor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup scene
        sceneView.setFrameSize(sceneViewSpace.bounds.size)
        
        // Setup simulation
        simulation = Simulation()
        simulation.setup()
        sceneView.presentScene(simulation)
        simulation.fixEmitters()
        
        // Add to view
        sceneViewSpace.addSubview(sceneView, positioned: .below, relativeTo: sceneViewSpace.subviews.first!)
        
        // Add pattern editor
        patternEditor = UIPatternEditor(patternEditorSpace.frame)
        patternEditorSpace.addSubview(patternEditor)
        
        /// SpriteKit settings
        sceneView.ignoresSiblingOrder = true
        sceneView.scene?.size = sceneView.frame.size
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
    }
    
    @IBAction func emittersNumberUpdated(_ sender: NSTextField) {
        guard let emitters = Int(sender.stringValue) else { return }
        patternEditor.emitters = emitters
        simulation.emitters = emitters
    }
    
    @IBAction func phasesNumberUpdated(_ sender: NSTextField) {
        patternEditor.phases = Int(sender.stringValue)!
    }
    
    @IBAction func timeIntervalUpdated(_ sender: NSTextField) {
        patternEditor.timeInterval = TimeInterval(sender.stringValue)!
    }
    
    @IBAction func gravityNumberUpdated(_ sender: NSTextField) {
        let gravity = CGVector(dx: 0.0, dy: -Double(sender.stringValue)!)
        simulation.physicsWorld.gravity = gravity
    }
    
    @IBAction func clickedPlay(_ sender: Any) {
        simulation.clearParticles()
        simulation.play(pattern: patternEditor.getPattern())
    }
    
    @IBAction func clickedFreeze(_ sender: Any) {
        simulation.isPaused = !simulation.isPaused
    }
    
    @IBAction func clickedCopy(_ sender: Any) {
        let pattern = patternEditor.getPattern()
        let patternStr = pattern.toString()
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(patternStr, forType: .string)
    }
    
    @IBAction func clickedPaste(_ sender: Any) {
        if let patternStr = NSPasteboard.general.string(forType: .string){
            let pattern = Pattern(patternStr)
            loadPattern(pattern)
        } else {
            showMessage("Oops!", "Could not read clipboard!")
        }
        
    }
    
    @IBAction func clickedReset(_ sender: Any) {
        patternEditor.fixCheckboxes()
    }
    
    /**
     Displays a message to the user.
     - Parameter title: message title
     
     - Parameter message: message to display
     */
    func showMessage(_ title: String, _ message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    /**
     Handles all the necessary work to load the given pattern into the simulation and editor.
     - Parameter pattern: pattern to load
     */
    func loadPattern(_ pattern: Pattern){
        // Number of phases in this pattern
        let phases = pattern.count
        
        // Emitters per phase
        let emitters = pattern.countEmitters()
        
        // Retrieve time interval for this phase
        guard let timeInterval = pattern.first?.timeInterval else { return }
        
        // Simulation
        simulation.emitters = emitters
        simulation.play(pattern: pattern)
        
        // Editor
        patternEditor.phases = phases
        patternEditor.emitters = emitters
        patternEditor.timeInterval = timeInterval
        patternEditor.fixCheckboxes()
        
        // Tools
        emittersNumberField.stringValue = String(emitters)
        phasesNumberField.stringValue = String(phases)
        timeIntervalNumberField.stringValue = String(timeInterval)
        
        // Update checkboxes
        var y = 0
        for phase in pattern.reversed() {
            for spawnPos in phase.spawnPositions {
                patternEditor.setCheckboxState(spawnPos, y, to: .on)
            }
            y += 1
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

