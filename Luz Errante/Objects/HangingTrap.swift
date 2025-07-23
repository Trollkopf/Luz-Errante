//
//  HangingTrap.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

class HangingTrap: SKSpriteNode{
    
    init() {
       let texture = SKTexture(imageNamed: "trap") // Asignamos directamente una imagen fija
       super.init(texture: texture, color: .clear, size: texture.size())
       self.name = "trap" // Asignamos un nombre
       self.zPosition = -1 // Posición -1 para situarla detrás de las ramas
       self.physicsBody = SKPhysicsBody(rectangleOf: texture.size()) // Cuerpo físico
       self.physicsBody?.isDynamic = false
       self.physicsBody?.categoryBitMask = 0x1 << 3 // Trampa colgante
       self.physicsBody?.contactTestBitMask = 0x1 << 0 // Colisiona con el caballero
       self.physicsBody?.collisionBitMask = 0
   }
       
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
