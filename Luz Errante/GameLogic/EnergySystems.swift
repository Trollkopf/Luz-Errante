//
//  EnergySystems.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 19/7/25.
//

import SpriteKit

extension GameScene{
    
    //MARK: Configuración de la barra de energía
    func setupEnergyBar() {
        energyBar = SKSpriteNode(color: .yellow, size: CGSize(width: 200, height: 20)) // Forma, color y tamaño de la barra de energía
        energyBar.position = CGPoint(x: frame.midX, y: frame.maxY - 120) // Posición de la barra
        energyBar.zPosition = 100// Posición z (delante de todo)
        addChild(energyBar)
        
    }
    
    //MARK: Drenaje de enertgía
    // En este juego jugamos con un sistema de vidas (energía) que se va drenando automáticamente
    func startDrainingEnergy() {
        energyDrainTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ _ in
            self.energy -= 1
            self.energyBar.size.width = max(0, self.energy * 2)
            
            // Si la energía se acaba, lanzamos el gameover y dejamos de drenar
            if self.energy <= 0 {
                self.energyDrainTimer?.invalidate()
                self.gameOver()
            }
        }
    }
}
