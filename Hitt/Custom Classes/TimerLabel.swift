//
//  TimerLabel.swift
//  Hitt
//
//  Created by Mohsin Khan on 22/03/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit

class TimerLabel: SKLabelNode {

    var touchLocation: CGPoint?
    var isRunning: Bool = true
    var delegate: TLProtocol?
    var timer: Timer?
    var count: Float?
    init(txt: String) {
        super.init()
        text = txt
        isUserInteractionEnabled = true
        count = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if count! >= 1{
            delegate?.exitGame()
        }
        count! = 0
        timer?.invalidate()
        
        let touch = touches.first?.location(in: parent!)
        if self.frame.contains(touch!){
            isRunning ? delegate?.pause() : delegate?.resume()
            isRunning = !(isRunning)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        runTimer()
    }

    func runTimer() {
        count! = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        count = count! + 1
    }
}
protocol TLProtocol {
    func pause()
    func resume()
    func exitGame()
}
