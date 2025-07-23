//
//  Knight.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 16/7/25.
//

import SpriteKit

class Knight: SKSpriteNode{
    
    private var runFrames: [SKTexture] = []
    private var jumpFrames: [SKTexture] = []
    private var attackFrames: [SKTexture] = []
    private var rollFrames: [SKTexture] = []
    
    // MARK: Iniciador
    init(){
        //Inicializamos el primer frame
        let texture = SKTexture(imageNamed: "knightrun1")
        super.init(texture:texture, color: .clear, size: texture.size())
        
        self.name = "knight" // Identificador del personaje
        self.zPosition = 0 // Posición del personaje (0): Delante del parallax, detrás de la maleza, detrás de la capa oscuridad
        self.setScale(2.0) // Ajustamos la escala
        
        // Traemos las funciones del personaje
        setupPhysics()
        loadRunFrames()
        startRuning()
        loadJumpFrames()
        loadAttackFrames()
        loadRollFrames()
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) no se ha implementado")
    }
    
    // MARK: Añadimos las físicas del personaje
    // En el personaje, al tener más funciones, he separado las físicas en una función para que sea más sencillo de manejar
    private func setupPhysics(){
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 45, height: 64)) // Cuerpo físico del personaje
        self.physicsBody?.allowsRotation = false // No pertmite la rotación del sprite
        self.physicsBody?.affectedByGravity = true // Le afecta la gravedad
        self.physicsBody?.restitution = 0.0 // 0 rebote
        self.physicsBody?.friction = 1.0
        self.physicsBody?.categoryBitMask = 0x1 << 0 // Personaje
        self.physicsBody?.contactTestBitMask = 0xFFFFFFFF // Detecta todo
        self.physicsBody?.collisionBitMask = 0x1 << 2 // Colisiona con el suelo
        // Esta etiqueta la puse en un principio para combatir el golpe con el orbe (Quew tenía de masa 0.000001)
        self.physicsBody?.mass = 1 // Ajustamos la masa del personaje
    }
    
    // MARK: Animación correr
    // Cargamos los frames del caballero corriendo (8, y los asignamos al array de texturas con i en el bucle for)
    private func loadRunFrames(){
        for i in 1...8{
            let texture = SKTexture(imageNamed: "knightrun\(i)")
            texture.filteringMode = .nearest
            runFrames.append(texture)
        }
    }
    
    private func startRuning(){
        // Cargamos los frames a la animación
        let runAction = SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.1, resize: false, restore: true)
        )
        // Iniciamos la animación de correr, la clave "run" la utilizamos para parar o reactivar la carrera
        run(runAction, withKey: "run")
    }
    
    // MARK: Animación saltar
    // Cartgamos los frames de saltar, igual que en la animación de correr
    private func loadJumpFrames(){
        for i in 1...10{
            let texture = SKTexture(imageNamed: String(format: "knightjump%02d", i))
            texture.filteringMode = .nearest
            jumpFrames.append(texture)
        }
    }
    
     func jump(){
         if action(forKey: "jump") == nil{ // Detectamos si se lanza la acción de saltar
            removeAction(forKey: "run") // Paramos la animación de correr mientras salta
             run(SKAction.playSoundFileNamed("jump", waitForCompletion: false)) // Lanzamos el sonido de saltar

            // Añadimos un impulso a las físicas para subir el objeto con un efecto de salto
            if let body = self.physicsBody, body.velocity.dy == 0{
                body.applyImpulse(CGVector(dx: 0, dy: 600))
            }
            
            let jumpAction = SKAction.sequence([
                SKAction.animate(with: jumpFrames, timePerFrame: 0.08, resize: false, restore: true), // Animación de saltar
                SKAction.run {self.startRuning()} // Iniciamos la carrera al acabar la animación
            ])
            
             // Ejecutamos la acción de saltar
            run(jumpAction, withKey: "jump")
        }
    }
    
    // MARK: Animación  atacar
    // Añadimos los frames como en las funciones anteriores
    private func loadAttackFrames(){
        for i in 1...7{
            let texture = SKTexture(imageNamed: "knightattack\(i)")
            texture.filteringMode = .nearest
            attackFrames.append(texture)
        }
    }
    
     func attack(){
         if action(forKey: "attack") == nil{ // Detectamos si se lanza la función de ataque
             removeAction(forKey: "run") // Desactivamos la carrera mientras se ejecuta
             run(SKAction.playSoundFileNamed("sword", waitForCompletion: false)) // Lanzamos el sonido de la espada
             
            let attackAction = SKAction.sequence([
                SKAction.animate(with: attackFrames, timePerFrame: 0.08, resize: false, restore: true), // Animación de atacar
                SKAction.run {self.startRuning()} // Iniciamos la carrera después de atacar
            ])
            
            // Ejecutamos la acción de atacar
            run(attackAction, withKey: "attack")
        }
    }
    
    // Añadimos una variable con una clave para saber si se encuentra atacando y poder utilizarlo en los enemigos
    var isAttacking: Bool {
        return action(forKey: "attack") != nil
    }
    
    // MARK: Animación rodar
    // Añadimos los frames
    private func loadRollFrames(){
        for i in 1...10{
            let texture = SKTexture(imageNamed: String(format: "knightroll%02d", i))
            texture.filteringMode = .nearest
            rollFrames.append(texture)
        }
    }
    
     func roll(){
         if action(forKey: "roll") == nil{ // Detectamos si se ha lanzado la acción de rodar
             removeAction(forKey: "run") // Paramos la carrera mientras se ejecuta
            
            let rollAction = SKAction.sequence([
                SKAction.animate(with: rollFrames, timePerFrame: 0.08, resize: false, restore: true), // Cargamos los frames a la animación
                SKAction.run {self.startRuning()} // Iniciamos la carrera después de ejecutar el rodamiento
            ])
            
             run(rollAction, withKey: "roll") // ejecutamos la acción de rodar
        }
    }
    
    // Variable con la clave de rodar para usarla con las trampas
    var isRolling: Bool {
        return action(forKey: "roll") != nil
    }
}
