//
//  GameScene.swift
//  Hitt
//
//  Created by Mohsin Khan on 26/02/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, Player1Delegate, Player2Delegate, TLProtocol {
    
    var godelegate: GameSceneProtocol?
    
    var player1Static = SKSpriteNode()
    var player1Dynamic : SKSpriteNode?
    
    var player2Static = SKSpriteNode()
    var player2Dynamic : SKSpriteNode?
    
    var obstaclePresets = [SKSpriteNode]()
    var obstacleSpeed = CGFloat()
    var playerSpeed = CGFloat()
    var shoot1 = false
    var canRotate = true
    var obstacles = [SKSpriteNode]()
    
    var graphs = [String : GKGraph]()
    var navigationGraph: GKGridGraph<GKGridGraphNode>!
    
    var player1Label: SKLabelNode?
    var player2Label: SKLabelNode?

    var player1Score: Int = 0
    var player2Score: Int = 0
    
    var timerLabel: TimerLabel?
    var timer = Timer()
    var isTimerRunning = false
    var minutes = 2
    var seconds = 6
    var hitSoundP1 : SKAudioNode?
    var hitSoundP2 : SKAudioNode?
    var emitterPresets = ["obstacle1" : "orangeBreak", "obstacle2" : "purpleBreak", "obstacle3" : "redBreak", "obstacle4" : "blueBreak", "obstacle5" : "yellowBreak", "obstacle6" : "greenBreak"]
    override func didMove(to view: SKView) {
        
        addSound()
    
        view.isMultipleTouchEnabled = true

        scaleMode = .resizeFill
    
        setBorders()
        
        setPlayers()
        
        setObstacles()
        
        physicsWorld.contactDelegate = self

        setTimer()
        
        runTimer()

    }
    
    func addSound() {
        let hurl = Bundle.main.url(forResource: "hitMusic.mp3", withExtension: nil)
        hitSoundP1 = SKAudioNode(url: hurl!)
        hitSoundP1?.autoplayLooped = false
        hitSoundP1?.run(.stop())
        addChild(hitSoundP1!)
        
        hitSoundP2 = SKAudioNode(url: hurl!)
        hitSoundP2?.autoplayLooped = false
        hitSoundP2?.run(.stop())
        addChild(hitSoundP2!)
    }
    func setPlayers() {
        
        let width = UIScreen.main.bounds.width * 2
        let height = UIScreen.main.bounds.height * 2
        
        //player1 setup
        let area1 = TouchableAreaPlayer1(texture: nil, color: UIColor.clear, size: CGSize(width: width, height: height/4))
        area1.name = "area-player-1"
        area1.position = CGPoint(x: 0, y: -height/8)
        area1.delegate = self
        player1Static = Player1()
        player1Static.position = area1.position
        area1.addChild(player1Static)
        self.addChild(area1)
        
        //player2 setup
        let area2 = TouchableAreaPlayer2(texture: nil, color: UIColor.clear, size: CGSize(width: width, height: height/4))
        area2.name = "area-player-2"
        area2.position = CGPoint(x: 0, y: height/8)
        area2.delegate = self
        player2Static = Player2()
        player2Static.position = area2.position
        area2.addChild(player2Static)
        self.addChild(area2)
        
        let zRange1 = SKRange(lowerLimit: -0.78, upperLimit: 0.78)
        let zRange2 = SKRange(lowerLimit: -0.78, upperLimit: 0.78)
        let rotationConstraints1 = SKConstraint.zRotation(zRange1)
        let rotationConstraints2 = SKConstraint.zRotation(zRange2)
        
        player1Static.constraints = [rotationConstraints1]
        player2Static.constraints = [rotationConstraints2]
        
        playerSpeed = 15/1334 * height * 1.5
        
        player1Label = SKLabelNode(text: "0")
        player1Label?.fontColor = #colorLiteral(red: 0, green: 0.7087574601, blue: 1, alpha: 1)
        player1Label?.fontName = UIFont.boldSystemFont(ofSize: 40).familyName
        player1Label?.position = CGPoint(x: -width/4 + (player1Label?.frame.width)!, y: -height/4 + (player1Label?.frame.height)!/2)
        addChild(player1Label!)
        
        player2Label = SKLabelNode(text: "0")
        player2Label?.fontName = UIFont.boldSystemFont(ofSize: 40).familyName
        player2Label?.fontColor = #colorLiteral(red: 0, green: 0.7087574601, blue: 1, alpha: 1)
        player2Label?.position = CGPoint(x: -width/4 + (player1Label?.frame.width)!, y: height/4 - (player1Label?.frame.height)!/2)
        player2Label?.run(SKAction.rotate(byAngle: CGFloat.pi, duration: 0))
        addChild(player2Label!)

    }
    
    func setObstacles() {
        
        let height = UIScreen.main.bounds.height * 2
        
        obstaclePresets.append(self.childNode(withName: "obstacle1") as! SKSpriteNode)
        obstaclePresets.append(self.childNode(withName: "obstacle2") as! SKSpriteNode)
        obstaclePresets.append(self.childNode(withName: "obstacle3") as! SKSpriteNode)
        obstaclePresets.append(self.childNode(withName: "obstacle4") as! SKSpriteNode)
        obstaclePresets.append(self.childNode(withName: "obstacle5") as! SKSpriteNode)
        obstaclePresets.append(self.childNode(withName: "obstacle6") as! SKSpriteNode)
        
        for i in 0..<obstaclePresets.count{
            let oh = 110/1334 * height
            obstaclePresets[i].run(SKAction.resize(toWidth: 1.09 * oh, height: oh, duration: 0))
            obstaclePresets[i].xScale = 0.5
            obstaclePresets[i].yScale = 0.5
            obstaclePresets[i].physicsBody = SKPhysicsBody(texture: obstaclePresets[i].texture!, size: CGSize(width: 1.09 * oh * 0.5, height: oh * 0.5))
            obstaclePresets[i].physicsBody?.isDynamic = true
            obstaclePresets[i].physicsBody?.affectedByGravity = false
            obstaclePresets[i].physicsBody?.allowsRotation = false
            obstaclePresets[i].physicsBody?.categoryBitMask = 2
            obstaclePresets[i].physicsBody?.collisionBitMask = 1
            obstaclePresets[i].physicsBody?.contactTestBitMask = 1
   
        }
        
        obstacleSpeed = -2
    }
    
    func setTimer() {
        
        let width = UIScreen.main.bounds.width * 2
        let height = UIScreen.main.bounds.height * 2
        
        timerLabel = TimerLabel(txt: timeString(time: TimeInterval(seconds)))
        timerLabel?.fontColor = UIColor.black
        timerLabel?.fontName = UIFont.boldSystemFont(ofSize: 30).familyName
        timerLabel?.delegate = self
        timerLabel?.position = CGPoint(x: width/4 - (timerLabel?.frame.width)!/2 - 15  , y: -height/4 + (timerLabel?.frame.height)! - 10)
        addChild(timerLabel!)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(GameScene.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if (timerLabel?.text)! == "00:00"{
            timer.invalidate()
            gameOver()
            return
        }
        seconds -= 1
        timerLabel?.text = timeString(time: TimeInterval(seconds))
    }
    
    func pause() {
        scene?.isPaused = true
        timer.invalidate()
    }
    
    func resume() {
        scene?.isPaused = false
        runTimer()
    }
    func exitGame() {
        godelegate?.gameover()
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func setBorders() {
        let width = UIScreen.main.bounds.width * 2
        let height = UIScreen.main.bounds.height * 2
        
        let bordermid = childNode(withName: "border_mid")
        
        bordermid?.position = CGPoint(x: 0, y: 0)
        bordermid?.run(SKAction.resize(toWidth: width, height: (bordermid?.frame.height)! , duration: 0))
 
        let borderleft = bordermid?.copy() as! SKNode
        borderleft.position = CGPoint(x: -width/4, y: 0)
        borderleft.run(SKAction.rotate(byAngle: CGFloat.pi/2, duration: 0))
        borderleft.run(SKAction.resize(toWidth: height/2, height: (bordermid?.frame.height)! , duration: 0))
        addChild(borderleft)
        
        let borderright = bordermid?.copy() as! SKNode
        borderright.position = CGPoint(x: width/4, y: 0)
        borderright.run(SKAction.rotate(byAngle: CGFloat.pi/2, duration: 0))
        borderright.run(SKAction.resize(toWidth: height/2, height: (bordermid?.frame.height)! , duration: 0))
        addChild(borderright)

    }
    func createP1Dynamic() {
        if player1Dynamic == nil{
            let height = UIScreen.main.bounds.height * 2
            player1Dynamic = player1Static.copy() as? SKSpriteNode
            player1Dynamic?.position = CGPoint(x: 0, y: -height/4)
            self.addChild(player1Dynamic!)
        }
    }
    func createP2Dynamic() {
        if player2Dynamic == nil{
            let height = UIScreen.main.bounds.height * 2
            player2Dynamic = player2Static.copy() as? SKSpriteNode
            player2Dynamic?.position = CGPoint(x: 0, y: height/4)
            self.addChild(player2Dynamic!)
        }
    }
    

    
    func getObstaclePath(w: CGFloat) -> CGPath {
        
        let path = UIBezierPath()
        let width = (self.view?.frame.width)! * 2
        let height = (self.view?.frame.height)! * 2
        let arr : [CGFloat] = [1.0,-1.0]
        let i = Int(arc4random_uniform(2))
        var pointY = arr[i] * height/18
        
        path.move(to: CGPoint(x: -width/4 - (w * 2), y: 0))
        let n = Int(arc4random_uniform(5)) + 7

        let strideX = width/CGFloat(2*n)

        for i in 1..<n{
            path.addLine(to: CGPoint(x: -width/4 + (((CGFloat)(i)) * strideX), y: pointY))
            pointY = -pointY
        }
        
        path.addLine(to: CGPoint(x: width/4 + (w * 2), y: 0))
        return path.cgPath

    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let lastObstacle = obstacles.last{
            if (lastObstacle.position.x) > -(view?.frame.width)!/8{
                let i = Int(arc4random_uniform(UInt32(obstaclePresets.count)))
                let temp = obstaclePresets[i].copy() as! SKSpriteNode
                temp.position = CGPoint(x: -(self.view?.frame.width)! - temp.size.width, y: 0)
                
                obstacles.append(temp)
                
                self.addChild(temp)
                let time = Int(arc4random_uniform(5)) + 3
                temp.run(.group([
                    SKAction.follow(getObstaclePath(w: temp.size.width), asOffset: false, orientToPath: false, duration: TimeInterval(time)),
                    SKAction.rotate(byAngle: .pi * 4, duration: TimeInterval(time))
                    ]
                ))

            }
        }else{
            if obstaclePresets.count > 0{
                let i = Int(arc4random_uniform(UInt32(obstaclePresets.count)))
                let temp = obstaclePresets[i].copy() as! SKSpriteNode
                temp.position = CGPoint(x: -(self.view?.frame.width)! - temp.size.width, y: 0)
                obstacles.append(temp)
                let time = Int(arc4random_uniform(5)) + 3
                self.addChild(temp)
                temp.run(.group([
                    SKAction.follow(getObstaclePath(w: temp.size.width), asOffset: false, orientToPath: false, duration: TimeInterval(time)),
                    SKAction.rotate(byAngle: .pi * 4, duration: TimeInterval(time))
                    ]
                    ))
            }
        }

        
        for i in 0..<obstacles.count{
            if (obstacles[i].position.x) > ((self.view?.frame.width)!/2){
                obstacles[i].removeFromParent()
                obstacles.remove(at: i)
                break
            }
        }
        
        
        if let p1d = player1Dynamic{
            let angle = player1Dynamic?.zRotation
            let dy : CGFloat = playerSpeed
            let dx = -dy*tan(angle!)
            p1d.run(SKAction.moveBy(x: dx, y: dy, duration: 0))
        }
        
        if let p2d = player2Dynamic{
            let angle = player2Dynamic?.zRotation
            let dy : CGFloat = -playerSpeed
            let dx = -dy*tan(angle!)
            p2d.run(SKAction.moveBy(x: dx, y: dy, duration: 0))
        }
        
    }
    
    func gameOver(){
        deleteObstacles()
        displayMessage()
        timer.invalidate()
    }
    func deleteObstacles() {
        
        for child in children{
            if let name = child.name, (name.hasPrefix("obstacle")){
                child.removeFromParent()
            }
        }
        obstacles.removeAll()
        obstaclePresets.removeAll()
    }
    func displayMessage() {
        backgroundMusicPlayer.pause()
        
        let curl = Bundle.main.url(forResource: "clapMusic.m4a", withExtension: nil)
        let clap = SKAudioNode(url: curl!)
        clap.autoplayLooped = false
        clap.run(.stop())
        addChild(clap)
        clap.run(.play())
        
        let height = 2 * UIScreen.main.bounds.height
        let winMsg = SKLabelNode(text: "you win")
        winMsg.fontName = "Gameshow"
        winMsg.fontSize = 70
        winMsg.fontColor = #colorLiteral(red: 0.9400261045, green: 0.2808550596, blue: 0.1589604616, alpha: 1)
        if player1Score > player2Score{
            winMsg.position = CGPoint(x: 0, y: -height/8 - winMsg.frame.height/2)
        }else if player1Score < player2Score{
            winMsg.position = CGPoint(x: 0, y: height/8 + winMsg.frame.height/2)
            winMsg.run(.rotate(toAngle: CGFloat.pi, duration: 0))
        }else{
            winMsg.text = "tie"
            winMsg.position = CGPoint(x: 0, y: 0 - winMsg.frame.height/2)
        }
        addChild(winMsg)
        
        winMsg.run(.repeat(.sequence([
            .fadeOut(withDuration: 0.1),
            .fadeIn(withDuration: 0.1)
            ]), count: 40)){
            clap.run(.stop())
            clap.removeFromParent()
            if let isMute = UserDefaults.standard.object(forKey: "isMute") as? Bool{
                if !isMute{
                    backgroundMusicPlayer.prepareToPlay()
                    backgroundMusicPlayer.play()
                }
            }else{
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
            }
            self.godelegate?.gameover()
            }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAname : String = (contact.bodyA.node?.name) ?? "123"
        let bodyBname : String = (contact.bodyB.node?.name) ?? "abc"
        
        if bodyAname != "border_mid" && bodyBname != "border_mid"{
            
            
            if bodyAname == "player1" || bodyBname == "player1"{
            
                hitSoundP1?.run(.stop())
                hitSoundP1?.run(.play())
                let point = contact.contactPoint
                
                var minIndex:Int = 0, minDist:CGFloat = 20000
                
                for i in 0..<obstacles.count{
                    
                    let pt = (obstacles[i].position)
                    
                    if (abs(pt.x - point.x )) < minDist {
                        minIndex = i
                        minDist = abs(pt.x - point.x)
                    }
                }
                
                let particles = SKEmitterNode(fileNamed: emitterPresets[(obstacles[minIndex].name)!]!)!
                particles.position = contact.contactPoint
                particles.zPosition = 3
                addChild(particles)
                particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                 SKAction.removeFromParent()]))

                
        
                obstacles.remove(at: minIndex)
                
                player1Score += 1
                player1Label?.text = "\(player1Score)"

                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                player1Dynamic = nil
            }
            if bodyAname == "player2" || bodyBname == "player2"{
                hitSoundP2?.run(.stop())
                hitSoundP2?.run(.play())
                let point = contact.contactPoint
                
                var minIndex:Int = 0, minDist:CGFloat = 20000
                
                for i in 0..<obstacles.count{
                    
                    let pt = (obstacles[i].position)
                    
                    if (abs(pt.x - point.x )) < minDist {
                        minIndex = i
                        minDist = abs(pt.x - point.x)
                    }
                }
                
                let particles = SKEmitterNode(fileNamed: emitterPresets[(obstacles[minIndex].name)!]!)!
                particles.position = contact.contactPoint
                particles.zPosition = 3
                addChild(particles)
                particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                 SKAction.removeFromParent()]))

                
                obstacles.remove(at: minIndex)
                
                player2Score += 1
                player2Label?.text = "\(player2Score)"
                
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                player2Dynamic = nil
            }
        }else{
            
            if bodyAname == "border_mid"{
                if bodyBname == "player1"{

                let area = self.childNode(withName: "area-player-1") as! TouchableAreaPlayer1
                    
                let col = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.4)
  
                    area.removeAllActions()
                    area.run(.sequence([
                        .repeat(.sequence([
                            .colorize(with: col , colorBlendFactor: 0.0, duration: 0.07),
                            .colorize(with: .clear , colorBlendFactor: 0 , duration: 0.07),
                            ]), count: 3),
                        .colorize(with: .clear , colorBlendFactor: 0 , duration: 0.0),
                        ]))
                    
                    player1Dynamic?.removeFromParent()
                    player1Dynamic = nil
                }
                if bodyBname == "player2"{

                    let area = self.childNode(withName: "area-player-2") as! TouchableAreaPlayer2
                    
                    let col = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.4)
                    area.removeAllActions()
                    area.run(.sequence([
                        .repeat(.sequence([
                            .colorize(with: col , colorBlendFactor: 0.0, duration: 0.07),
                            .colorize(with: .clear , colorBlendFactor: 0 , duration: 0.07),
                            ]), count: 3),
                        .colorize(with: .clear , colorBlendFactor: 0 , duration: 0.0),
                        ]))
                    
                    player2Dynamic?.removeFromParent()
                    player2Dynamic = nil
                }
            }else{
                if bodyAname == "player1"{
                    player1Dynamic?.removeFromParent()
                    player1Dynamic = nil
                }
                if bodyAname == "player2"{
                    player2Dynamic?.removeFromParent()
                    player2Dynamic = nil
                }
            }
        }
    }
}

protocol GameSceneProtocol {
    func gameover()
}
