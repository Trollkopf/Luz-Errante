//
//  ParallaxManager.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

extension GameScene{
    
    // MARK: Inicializamos bg en parallax
    func createParallaxBackground(){
        // Array con los sprites
        let layerNames = [
        "bg_009",
        "bg_008",
        "bg_007",
        "bg_006",
        "bg_005",
        "bg_004",
        "bg_003",
        "bg_002"
        ]
        
        // Recorremos las texturas para asignar posiciones
        for (index, layerName) in layerNames.enumerated() {
            let node = SKNode()
            
            for i in 0...8{
                let sprite = SKSpriteNode(imageNamed: layerName)
                sprite.anchorPoint = CGPoint.zero
                sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y:0)
                sprite.zPosition = -10 + CGFloat(index)
                node.addChild(sprite)
            }
            
            node.name = "parallax_\(index)"
            backgroundLayers.append(node)
            addChild(node)
        }
        
        // Última capa con zposition diferente para poner la trampa colgante detrás
          let foregroundNode = SKNode()
          for i in 0...8 {
              let sprite = SKSpriteNode(imageNamed: "bg_001")
              sprite.anchorPoint = CGPoint.zero
              sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: 0)
              sprite.zPosition = 0  // tu valor personalizado
              foregroundNode.addChild(sprite)
          }
          foregroundNode.name = "parallax_fg"
          backgroundLayers.append(foregroundNode)
          addChild(foregroundNode)
        
    }
    
     func moveParallaxBackground(){
        // Recorremos los objetos para asignar movimiento
        for(index,node) in backgroundLayers.enumerated(){
            let speed = backgroundSpeed[index]
            for sprite in node.children {
                if let sprite = sprite as? SKSpriteNode {
                    sprite.position.x -= speed
                    
                    // Reposicionamos cuando salga de la pantalla
                    if sprite.position.x <= -sprite.size.width{
                        sprite.position.x += sprite.size.width * 2
                    }
                }
            }
        }
    }
    
    //MARK: Iniciamos el suelo en parallax
    
    func createParallaxFloor() {
        let layers = [
            ("floor_back", -1),
            ("floor_front", 1)
        ]
        
        for (layerName, zPos) in layers {
            let node = SKNode()
            
            // Recorremos y añadimos la posz para dejar hueco a los sprites que iran entre ambas capas
            for i in 0..<2 {
                let sprite = SKSpriteNode(imageNamed: layerName)
                sprite.anchorPoint = CGPoint.zero
                sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: 0)
                sprite.zPosition = CGFloat(zPos)
                node.addChild(sprite)
            }
            
            node.name = "parallax_\(layerName)"
            floorLayers.append(node)
            addChild(node)
        }
    }

    
     func moveParallaxFloor(){
        // Recorremos los objetos para asignar movimiento
        for(index,node) in floorLayers.enumerated(){
            let speed = floorSpeed[index]
            for sprite in node.children {
                if let sprite = sprite as? SKSpriteNode {
                    sprite.position.x -= speed
                    
                    // Reposicionamos cuando salga de la pantalla
                    if sprite.position.x <= -sprite.size.width{
                        sprite.position.x += sprite.size.width * 2
                    }
                }
            }
        }
    }
    
    // HACEMOS SUELO SÓLIDO
    func createGround() {
        let ground = SKNode()
        ground.position = CGPoint(x: frame.midX, y: frame.minY)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 80))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 0x1 << 2 //Suelo
        ground.physicsBody?.contactTestBitMask = 0
        ground.physicsBody?.collisionBitMask = 0x1 << 0 //Colisiona con el caballero
        addChild(ground)
            
    }
}
