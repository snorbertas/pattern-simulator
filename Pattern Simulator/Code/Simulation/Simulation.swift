//
//  Simulation.swift
//  Pattern Simulator
//
//  Created by Norbert Staskevicius on 2/10/18.
//  Copyright © 2018 Norbert Staskevicius. All rights reserved.
//

import Foundation
import SpriteKit

class Simulation: SKScene {
    private var _emitters: Int = 5
    private let emittersNode = SKNode()
    private let particlesNode = SKNode()
    private var nextPhaseTime: TimeInterval = 0
    private var newPatternStart = false
    private var pattern: Pattern?
    
    func setup(){
        self.addChild(emittersNode)
        self.addChild(particlesNode)
        self.physicsWorld.gravity.dy = -2.0
    }
    
    func fixEmitters(){
        clearAll()
        guard let centerX = self.view?.frame.midX else { return }
        let spacing = 50
        let yOffset = 130
        let xOffset = Int(centerX) - (spacing * (_emitters - 1)) / 2
        for x in 0 ..< _emitters {
            let emitter = createEmitter(xOffset + (x * spacing), yOffset)
            emittersNode.addChild(emitter)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(pattern == nil) { return }
        if((pattern?.count)! == 0) { return }
        
        if(currentTime >= nextPhaseTime || newPatternStart){
            newPatternStart = false
            guard let phase = pattern?.popLast() else { return }
            
            // Emit this phase
            for position in phase.spawnPositions {
                emit(position)
            }
            
            // Prepare for next phase
            nextPhaseTime = currentTime + phase.timeInterval
        }
    }
    
    func play(pattern: Pattern){
        self.pattern = pattern
        self.newPatternStart = true
        self.isPaused = false
    }
    
    func emit(_ emitter: Int){
        let position = emittersNode.children[emitter].position
        
        let particle = createParticle()
        particle.position = position
        particlesNode.addChild(particle)
        
        let gravity = Float(-self.physicsWorld.gravity.dy)
        let desiredHeight: Float = 40
        let y: CGFloat = CGFloat(sqrt(2 * gravity * desiredHeight))
        
        particle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: y))
    }
    
    func clearAll(){
        emittersNode.removeAllChildren()
        particlesNode.removeAllChildren()
    }
    
    func clearParticles(){
        particlesNode.removeAllChildren()
    }
    
    func createEmitter(_ x: Int, _ y: Int) -> SKShapeNode {
        let emitter = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
        emitter.position = CGPoint(x: x, y: y)
        emitter.strokeColor = SKColor.black
        emitter.glowWidth = 1.0
        emitter.fillColor = SKColor.gray
        
        return emitter
    }
    
    func createParticle() -> SKShapeNode {
        let particle = SKShapeNode(circleOfRadius: 15 )
        particle.strokeColor = SKColor.black
        particle.glowWidth = 1.0
        particle.fillColor = SKColor.green
        particle.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        particle.physicsBody?.collisionBitMask = 0
        
        return particle
    }
    
    var emitters: Int {
        get {
            return _emitters
        }
        
        set {
            if(_emitters == newValue) { return }
            _emitters = newValue
            fixEmitters()
        }
    }
}
