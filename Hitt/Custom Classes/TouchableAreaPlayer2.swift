//
//  TouchableAreaPlayer1.swift
//  Hitt
//
//  Created by Mohsin Khan on 28/02/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit

class TouchableAreaPlayer2: SKSpriteNode {
    
    var delegate : Player2Delegate?
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: UIColor.clear, size: size)
        isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let height = UIScreen.main.bounds.width
        let child = childNode(withName: "player2")
        for touch in touches{
            let initialX = touch.previousLocation(in: (parent as! SKScene).view).x
            let currentX = touch.location(in: (parent as! SKScene).view).x
            let deltaX = currentX - initialX
            if deltaX > 0{
                child?.run(SKAction.rotate(byAngle: 0.06/375 * height, duration: 0))
            }else{
                
                child?.run(SKAction.rotate(byAngle: -0.06/375 * height, duration: 0))
                
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.createP2Dynamic()
    }
}
protocol Player2Delegate {
    func createP2Dynamic()
}

