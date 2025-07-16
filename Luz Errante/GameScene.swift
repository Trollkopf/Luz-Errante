//
//  GameScene.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 16/7/25.
//

import SpriteKit
import GameplayKit

import Foundation

class GameScene: SKScene {
    
    var backgroundLayers: [SKNode] = []
    var floorLayers: [SKNode] = []
    let backgroundSpeed: [CGFloat] = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8]
    let floorSpeed: [CGFloat] = [2.0, 2.2]
    
    var knight: Knight!
    
    override func didMove(to view: SKView) {
        createParallaxBackground()
        createParallaxFloor()
        addKnight()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveParallaxBackground()
        moveParallaxFloor()
    }
    
    //MARK: Inicializamos bg en parallax
    private func createParallaxBackground(){
        let layerNames = [
        "bg_009",
        "bg_008",
        "bg_007",
        "bg_006",
        "bg_005",
        "bg_004",
        "bg_003",
        "bg_002",
        "bg_001",
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
        
    }
    
    private func moveParallaxBackground(){
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
    
    private func createParallaxFloor(){
        let layerNames = [
        "floor_back",
        "floor_front"
        ]
        
        // Recorremos las texturas para asignar posiciones
        for (index, layerName) in layerNames.enumerated() {
            let node = SKNode()
            
            for i in 0...1{
                let sprite = SKSpriteNode(imageNamed: layerName)
                sprite.anchorPoint = CGPoint.zero
                sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y:0)
                sprite.zPosition = -1 + CGFloat(index)
                node.addChild(sprite)
            }
            
            node.name = "parallax_\(index)"
            floorLayers.append(node)
            addChild(node)
        }
        
    }
    
    private func moveParallaxFloor(){
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
    
    //MARK: Funciones del caballero
    func addKnight(){
        knight = Knight()
        knight.position = CGPoint(x: frame.midX / 2, y: frame.minY + 85)
        addChild(knight)
    }
}
