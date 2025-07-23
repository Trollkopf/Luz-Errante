//
//  SpawnManager.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

extension GameScene{
    //MARK: Añadimos los orbes
    func spawnOrb() {
        let orb = Orb() // Llamamos a la clase
        // Añadimos el orbe un un rango aleatorio entre 120 y 220 sobre la base de la pantalla (donde alcanza el caballero saltando)
        orb.position = CGPoint(x: frame.maxX + 100, y: frame.minY + 180 + CGFloat.random(in: 0...40))
        addChild(orb)
        
        let move = SKAction.moveBy(x: -frame.width - 200, y: 0, duration: 4) // Movimiento a la velocidad del parallax
        let remove = SKAction.removeFromParent() // Eliminar el objeto
        orb.run(SKAction.sequence([move, remove])) // Funciones del objeto
    }
    
    //MARK: Añadimos enemigos/trampas
    func spawnSkeleton() {
        let skeleton = Skeleton() // Llamamos a la clase
        // Añadimos al enemigo a la altura que camina el caballero
        skeleton.position = CGPoint(x: frame.maxX + 100, y: frame.minY + 100)
        addChild(skeleton)
        
        let move = SKAction.moveBy(x: -frame.width - 200, y: 0, duration: 4) // Movimiento a la velocidad del parallax
        let remove = SKAction.removeFromParent() // Eliminar el objeto
        skeleton.run(SKAction.sequence([move, remove])) // Funciones del objeto
    }
    
    func spawnTrap(){
        let trap = HangingTrap()// Llamamos a la clase
        // Añadimos a la altura parea que parezca que bajo el objeto cabe el caballero
        trap.position = CGPoint(x: size.width + 100, y: frame.minY + 228)
        addChild(trap)
        
        let move = SKAction.moveBy(x: -frame.width - 200, y: 0, duration: 4) // Movimiento a la velocidad del parallax
        let remove = SKAction.removeFromParent() // Eliminar el objeto
        trap.run(SKAction.sequence([move,remove])) // Funciones del objeto
        
    }

}
