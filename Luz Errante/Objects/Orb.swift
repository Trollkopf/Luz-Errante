//
//  Orb.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 18/7/25.
//

import SpriteKit

class Orb: SKSpriteNode{
        
    init(){
        let textures = Orb.loadOrbFrames() // Cargamos la función para traer los frames
        super.init(texture: textures.first, color: .clear, size: textures.first!.size()) // Iniciamos con el primer frame
        self.name = "orb" // LE asignamos un nombre para identificar el objeto
        self.setScale(0.5) // Ajustamos la escala
        self.zPosition = 52 // traemos a la posición por encima de 50 para que esté sobre la capa de oscuridad (brilla)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2) // Cuerpo físico del orbe
        self.physicsBody?.isDynamic = false // No es afectado por las fuerzas físicas
        self.physicsBody?.categoryBitMask = 0x1 << 1  // Orbe
        self.physicsBody?.contactTestBitMask = 0x1 << 0 // Detecta al personaje
        self.physicsBody?.collisionBitMask = 0 // No colisiona
        // Aquí tengo etiquetas redundantes a lo anterior para intentar solucionar un problema de colisión (Causado por el caballero)
        self.physicsBody?.usesPreciseCollisionDetection = true // Hacemos una detección precisa del objeto
        self.physicsBody?.affectedByGravity = false // No le afecta la gravedad
        self.physicsBody?.isResting = true // Marca el objeto como "en reposo"
        self.physicsBody?.fieldBitMask = 0 // No le afecta ningíun campo de fuerza
        self.physicsBody?.pinned = true // Refuerza el comportamiento estático
        self.physicsBody?.allowsRotation = false // Impide que el sprite gire
        
        // La animación del orbe en bucle infinito
        let orbAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true))
        // Se inicia la animación del orbe. Le pongo una clave para poder utilizarlo si fuese necesario
        self.run(orbAnimation, withKey: "glow")
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // Cargamos los frames para la animación del orbe
    static func loadOrbFrames() -> [SKTexture] {
        var frames: [SKTexture] = []
        for i in 1...6{
            let texture = SKTexture(imageNamed: "orb0\(i)")
            texture.filteringMode = .nearest
            frames.append(texture)
        }
        return frames
    }
}
