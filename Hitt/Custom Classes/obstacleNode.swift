//
//  obstacleNode.swift
//  Hitt
//
//  Created by Mohsin Khan on 18/03/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit

class obstacleNode{

    var node: SKSpriteNode?
    var points = [CGPoint]()
    var currentIndex: Int?
    var path = CGMutablePath()
    
    
    init(skn: SKSpriteNode) {
        node = skn
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        let strideX = width/7
        var pointY = height/6
        
        points.append(CGPoint(x: -width, y: 0))
        path.move(to: points[0])
       // print(strideX)
        
        for i in 1..<7{
            
            points.append(CGPoint(x: -width + (((CGFloat)(i)) * strideX), y: pointY))
            path.addLine(to: points[i])
            pointY = -pointY
        }
        
        points.append(CGPoint(x: width, y: 0))
        path.addLine(to: points[7])
       // print(points)
        //path.ad

        currentIndex = 1
    }
    
   // override upda
    
}
