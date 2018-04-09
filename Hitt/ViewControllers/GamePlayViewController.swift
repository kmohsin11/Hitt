//
//  GamePlayViewController.swift
//  Hitt
//
//  Created by Mohsin Khan on 08/04/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GamePlayViewController: UIViewController, GameSceneProtocol {

    var gs : GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
            
            if let view = self.view as! SKView? {
                
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view.ignoresSiblingOrder = true
                    view.presentScene(scene)
                    gs = scene as? GameScene
                    gs?.godelegate = self
                }
            }
    }
    
    func gameover() {
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
