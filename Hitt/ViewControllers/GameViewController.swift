//
//  GameViewController.swift
//  Hitt
//
//  Created by Mohsin Khan on 26/02/18.
//  Copyright © 2018 Mohsin Khan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()

class GameViewController: UIViewController {
    var sceneNode: GameScene!

    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var hittLogo: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hittLogo.font = UIFont(name: "Gameshow", size: (110/667)*(UIScreen.main.bounds.height))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let bgMusicURL = Bundle.main.url(forResource: "bgMusic.mp3", withExtension: nil)
        do{
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: bgMusicURL!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.volume = 0.5

        }catch{ }
        
        if let isMute = UserDefaults.standard.object(forKey: "isMute") as? Bool{
            
            if isMute{
                let ui = UIImage(named: "unmuteBtn")
                muteBtn.setImage(ui! , for: .normal)
            }else{
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
            }
            
        }else{
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            UserDefaults.standard.set(false, forKey: "isMute")
        }
        
    }

    
    @IBAction func playBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func muteBtnPressed(_ sender: Any) {
        let isMute = UserDefaults.standard.object(forKey: "isMute") as! Bool
            if isMute{
                let ui = UIImage(named: "muteBtn")
                muteBtn.setImage(ui! , for: .normal)
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
                UserDefaults.standard.set(false, forKey: "isMute")

            }else{
                let ui = UIImage(named: "unmuteBtn")
                muteBtn.setImage(ui! , for: .normal)
                backgroundMusicPlayer.pause()
                UserDefaults.standard.set(true, forKey: "isMute")
            }

    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    @IBAction func infoBtnPressed(_ sender: Any) {
        
        if self.infoTextView.alpha == 0{
            UIView.animate(withDuration: 0.4){
                self.infoTextView.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.4){
                self.infoTextView.alpha = 0
            }
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
