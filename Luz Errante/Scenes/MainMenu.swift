//
//  MainMenu.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {

        // Imagen Background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        background.size = self.size
        addChild(background)

        // Título
        let title = SKSpriteNode(imageNamed: "logo")
        title.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        title.zPosition = 1
        addChild(title)
        
        // Botón Jugar
        let playButton = SKLabelNode(text: "Jugar")
        playButton.fontSize = 36
        playButton.fontName = "Helvetica bold"
        playButton.fontColor = .white
        playButton.name = "play"
        playButton.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        playButton.zPosition = 1
        addChild(playButton)
        
        // Botón Instrucciones
        let instructionsButton = SKLabelNode(text: "Instrucciones")
        instructionsButton.fontSize = 32
        instructionsButton.fontName = "Helvetica bold"
        instructionsButton.fontColor = .white
        instructionsButton.name = "instructions"
        instructionsButton.position = CGPoint(x: frame.midX, y: frame.minY + 150)
        instructionsButton.zPosition = 1
        addChild(instructionsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        // Si clicamos sobre el label jugar, lanzamos el juego (GameScene)
        if node.name == "play" {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            run(SKAction.playSoundFileNamed("ui", waitForCompletion: false))
            view?.presentScene(gameScene, transition: .fade(withDuration: 1))
        }
        
        // Si pulsamos sobre instrucciones lanzamos la escena de instrucciones (InstructiosnScene)
        if node.name == "instructions" {
            let instructions = InstructionsScene(size: self.size)
            instructions.scaleMode = .aspectFill
            run(SKAction.playSoundFileNamed("ui", waitForCompletion: false))
            view?.presentScene(instructions, transition: .fade(withDuration: 1))
        }

    }
}

