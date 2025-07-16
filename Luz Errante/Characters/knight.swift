//
//  Knight.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 16/7/25.
//

import SpriteKit

class Knight: SKSpriteNode{
    
    private var runFrames: [SKTexture] = []
    
    //MARK: Iniciador
    init(){
        //Inicializamos el primer frame
        let texture = SKTexture(imageNamed: "knightrun1")
        super.init(texture:texture, color: .clear, size: texture.size())
        
        self.name = "knight"
        self.zPosition = 1
        self.setScale(2.0)
        
        loadRunFrames()
        startRuning()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) no se ha implementado")
    }
    
    //MARK: Animación correr
    private func loadRunFrames(){
        for i in 1...8{
            let texture = SKTexture(imageNamed: "knightrun\(i)")
            texture.filteringMode = .nearest
            runFrames.append(texture)
        }
    }
    
    private func startRuning(){
        let runAction = SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.1, resize: false, restore: true)
        )
        self.run(runAction, withKey: "run")
    }
}
