//
//  Skeleton.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

class Skeleton: SKSpriteNode{
    // Usamos las mismas físicas que en el orbe
    init(){
        let textures = Skeleton.loadSkeletonFrames()
        super.init(texture: textures.first, color: .clear, size: textures.first!.size())
        self.name = "skeleton"
        self.setScale(2)
        self.zPosition = 0
        self.physicsBody = SKPhysicsBody(rectangleOf: textures.first!.size())
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 0x1 << 2  // Skeleton
        self.physicsBody?.contactTestBitMask = 0x1 << 0 // Personaje
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isResting = true
        self.physicsBody?.fieldBitMask = 0
        self.physicsBody?.pinned = true
        self.physicsBody?.allowsRotation = false
        
        let skeletonAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true))
        self.run(skeletonAnimation, withKey: "evil")
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // Cargamos los frames del esqueleto
    static func loadSkeletonFrames() -> [SKTexture] {
        var frames: [SKTexture] = []
        for i in 1...5{
            let texture = SKTexture(imageNamed: "skeleton\(i)")
            texture.filteringMode = .nearest
            frames.append(texture)
        }
        return frames
    }
    

}
