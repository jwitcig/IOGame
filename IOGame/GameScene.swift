//
//  GameScene.swift
//  IOGame
//
//  Created by Developer on 6/21/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import SpriteKit
import GameplayKit

import FirebaseDatabase

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var player : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        player = SKShapeNode(circleOfRadius: 30)
        player?.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        player?.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.friction = 0
        player?.physicsBody?.linearDamping = 0
        addChild(player!)
        
        Database.database().reference().observe(.value, with: { snapshot in
            self.changeDirection()
        })
    }
    
    func changeDirection() {
        player?.physicsBody?.velocity.dy *= -1
        
    }
    var status = false
    func touchDown(atPoint pos : CGPoint) {
//        changeDirection()
        
        Database.database().reference().setValue(!status)
        status = !status
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
