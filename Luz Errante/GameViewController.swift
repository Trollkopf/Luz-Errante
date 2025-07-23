//
//  GameViewController.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 16/7/25.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Forzamos la carga de sonidos
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error al activar AVAudioSession: \(error)")
        }
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
        
        if let view = self.view as? SKView {
            // Cargar el menú principal al iniciar
            let scene = MainMenuScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
