//
//  Player1.swift
//  Hitt
//
//  Created by Mohsin Khan on 28/02/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit

class Player1: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "arrow")
        
       // let width = UIScreen.main.bounds.width
       // let height = UIScreen.main.bounds.height
        super.init(texture: texture,color: UIColor.clear, size: CGSize(width: 20, height: 80))
        name = "player1"
        
        physicsBody = SKPhysicsBody(texture: texture , size: CGSize(width: 20, height: 80))
       // physicsBody = SKPhysicsBody(
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 2
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
}
