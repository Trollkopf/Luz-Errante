//
//  InstructionsScene.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

class InstructionsScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        
        let title = SKLabelNode(text: "¿Cómo Jugar?")
        title.fontSize = 40
        title.fontColor = .white
        title.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        addChild(title)
        
        addInstructions()
        addBackButton()
    }
    
    func addInstructions() {
        let text = SKLabelNode(text: "La luz del caballero se consume con el tiempo.")
        text.fontSize = 18
        text.fontColor = .white
        text.position = CGPoint(x: frame.midX, y: frame.maxY - 160)
        addChild(text)
        
        let orbText = SKLabelNode(text: "Recoge orbes para mantenerla encendida:")
        orbText.fontSize = 18
        orbText.fontColor = .white
        orbText.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        addChild(orbText)
        
        // Orbe animado
        let orb = Orb()
        orb.position = CGPoint(x: frame.midX, y: frame.maxY - 240)
        addChild(orb)
        
        let jumpText = SKLabelNode(text: "Desliza hacia arriba para saltar y alcanzarlos")
            jumpText.fontSize = 16
            jumpText.fontColor = .white
            jumpText.position = CGPoint(x: frame.midX, y: frame.maxY - 290)
            addChild(jumpText)
        
        let actionText = SKLabelNode(text: "Acciones para esquivar peligros:")
        actionText.fontSize = 20
        actionText.fontColor = .white
        actionText.position = CGPoint(x: frame.midX, y: frame.maxY - 330)
        addChild(actionText)
        
        let skeletonText = SKLabelNode(text: "Desliza hacia la derecha para atacar a los esqueletos")
            skeletonText.fontSize = 16
            skeletonText.fontColor = .white
            skeletonText.position = CGPoint(x: frame.midX, y: frame.maxY - 360)
            addChild(skeletonText)
        
        // Esqueleto animado
        let skeleton = Skeleton()
        skeleton.setScale(1.8)
        skeleton.position = CGPoint(x: frame.midX, y: frame.maxY - 430)
        addChild(skeleton)
        
        let trapText = SKLabelNode(text: "Desliza hacia abajo para rodar bajo trampas colgantes")
            trapText.fontSize = 16
            trapText.fontColor = .white
            trapText.position = CGPoint(x: frame.midX, y: frame.maxY - 530)
            addChild(trapText)
        
        // Trampa colgante
        let trap = HangingTrap()
        trap.setScale(0.7)
        trap.position = CGPoint(x: frame.midX, y: frame.maxY - 650)
        addChild(trap)
    }
    
    func addBackButton() {
        let backButton = SKLabelNode(text: "← Volver al menú")
        backButton.name = "back"
        backButton.fontSize = 20
        backButton.fontColor = .white
        backButton.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        // Volvemos al menú si pulsamos en el label de volver al menú (Qué redundante)
        if node.name == "back" {
            let menu = MainMenuScene(size: self.size)
            menu.scaleMode = .aspectFill
            run(SKAction.playSoundFileNamed("ui", waitForCompletion: false))
            view?.presentScene(menu, transition: .fade(withDuration: 0.5))
        }
    }
}

