//
//  GameScene.swift
//  Luz Errante
//
//  Created by Maximiliano Serratosa on 16/7/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Aquí están todas las variables que se utilizan en las clases de GameLogic. Son extensiones que hice posteriormente ya que aquí se me estaba alargando demasiado el código para poder asegurar que fuese fácilmente escalable y más legible, de modo que corté y reagrupé las funciones por similitudes
    // Variables background + floor
    var backgroundLayers: [SKNode] = []
    var floorLayers: [SKNode] = []
    let backgroundSpeed: [CGFloat] = [0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8]
    let floorSpeed: [CGFloat] = [2.0, 2.2]
    
    // Variables barra de energía
    var energyBarLabel: SKLabelNode!
    var energy: CGFloat = 100.0
    var energyBar: SKSpriteNode!
    var energyDrainTimer: Timer?
    
    // Otras variables
    var knight: Knight!
    var isGameOver = false
    var elapsedTime: TimeInterval = 0
    var startTime: TimeInterval = 0
    var timeLabel: SKLabelNode!
    var darknessOverlay: SKSpriteNode!

    //MARK: DID BEGIN
    func didBegin(_ contact: SKPhysicsContact){
        // Comprobamos los encuentros
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else {return}
        
        // Caballero -> Orbe
        if nodeA.name == "orb" || nodeB.name == "orb" {
            let orb = nodeA.name == "orb" ? nodeA : nodeB
            
            // Desactiva cuerpo del orbe antes de eliminar
            orb.physicsBody = nil
            orb.removeAllActions()
            
            // Desaparece visualmente con un fade
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            let remove = SKAction.removeFromParent()
            orb.run(SKAction.sequence([fadeOut, remove]))
            run(SKAction.playSoundFileNamed("pick_object", waitForCompletion: false)) // Sonido de coger orbe
            
            // Añade la energía al contador de energía (barra)
            energy = min(100, energy + 20)
            energyBar.size.width = energy * 2
        }
        
        // Caballero -> Enemigo
        if nodeA.name == "skeleton" || nodeB.name == "skeleton" {
            let skeleton = nodeA.name == "skeleton" ? nodeA : nodeB
            let other = skeleton == nodeA ? nodeB : nodeA
            
            // Comprobamos que el caballero está atacando al contactar
            if let knight = other as? Knight, knight.isAttacking {
                // Destruye al esqueleto sin penalizar
                skeleton.physicsBody = nil
                skeleton.removeAllActions()
                // Damos un pequeño movimiento para que resulte más visual la desaparición del enemigo
                let bounceUp = SKAction.moveBy(x: 0, y: 20, duration: 0.1)
                let bounceDown = SKAction.moveBy(x: 0, y: -10, duration: 0.1)
                let scale = SKAction.scale(to: 0.8, duration: 0.1)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let remove = SKAction.removeFromParent()
                run(SKAction.playSoundFileNamed("kill_enemy", waitForCompletion: false)) //  Sonido de muerte del enemigo
                let group = SKAction.group([scale, fadeOut])
                // Hacemos una secuencia con los movimientos de desaparición
                let sequence = SKAction.sequence([bounceUp, bounceDown, group, remove])
                skeleton.run(sequence) // Ejecutamos todos los movimientos
                
            } else { // Si el personaje no entra en el contacto atacando
                // Caballero recibe daño
                skeleton.physicsBody = nil
                skeleton.removeAllActions()
                let fadeOut = SKAction.fadeOut(withDuration: 0.1)
                let remove = SKAction.removeFromParent()
                skeleton.run(SKAction.sequence([fadeOut, remove])) // Enemigo desaparece sin más
                run(SKAction.playSoundFileNamed("hurt", waitForCompletion: false)) // Sonido de personaje herido
                
                // Quitamos energía al contador
                energy = max(0, energy - 20)
                energyBar.size.width = energy * 2
                if energy <= 0 { // Comprobamos si ha caido por debajo de 0
                    energyDrainTimer?.invalidate()
                    gameOver()
                }
            }
        }
         
        // Caballero -> Trampa
        if nodeA.name == "trap" || nodeB.name == "trap" {
            let trap = nodeA.name == "trap" ? nodeA : nodeB
            let other = trap == nodeA ? nodeB : nodeA
            
            // Comprobamos si pasa rodando bajo la trampa
            if let knight = other as? Knight, knight.isRolling {
                // Pasa la trampa sin penalizar
                trap.physicsBody = nil
                trap.removeAllActions()
                let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 0.3)
                moveUp.timingMode = .easeOut
                run(SKAction.playSoundFileNamed("chains", waitForCompletion: false)) // Sonido de cadenas

                // En este caso el movimiento de la trampa es como si se recogiese tras las ramas
                let keepMoving = SKAction.moveBy(x: -frame.width - 200, y: 0, duration: 3.7)
                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                let remove = SKAction.removeFromParent()
                let group = SKAction.group([keepMoving, moveUp, fadeOut])
                let sequence = SKAction.sequence([group, remove])
                trap.run(sequence)
            
            // Si no pasa rodando...
            } else {
                // Caballero recibe daño
                trap.physicsBody = nil
                trap.removeAllActions()
                let fadeOut = SKAction.fadeOut(withDuration: 0.1)
                let remove = SKAction.removeFromParent()
                trap.run(SKAction.sequence([fadeOut, remove]))
                run(SKAction.playSoundFileNamed("hurt", waitForCompletion: false))
                
                // Al igual que en el enemigo, quitamos energía y comprobamos si cae bajo 0
                energy = max(0, energy - 20)
                energyBar.size.width = energy * 2
                if energy <= 0 {
                    energyDrainTimer?.invalidate()
                    gameOver()
                }
            }
        }
        
    }
    
    //MARK: UPDATE
    override func update(_ currentTime: TimeInterval) {
        // Comprobamos que no estemos en game over
        guard !isGameOver else { return }
        // Iniciamos el parallax del background y el suelo
        moveParallaxBackground()
        moveParallaxFloor()
        
        // Actualizar contador
        elapsedTime = CACurrentMediaTime() - startTime
        let seconds = Int(elapsedTime)
        timeLabel.text = "Tiempo: \(seconds)s"
        
        // Actualizar oscuridad
        let darkness = 1 - (energy / 100)
        darknessOverlay.alpha = min(max(darkness * 0.9, 0), 0.9)
    }
    
    //MARK: DID MOVE
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        playBackgroundMusic() // Añadimos la musica
        createParallaxBackground() // Creamos el background
        createParallaxFloor() // Creamos el suelo
        addKnight() // Añadimos al personaje
        createGround() // Añadimos suelo sólido
        setupTimer() // Activamos el contador
        setupDarkness() // Activamos la oscuridad
        
        //BARRA DE ENERGIA
        energyBarLabel = SKLabelNode(text: "Conserva tu luz")
        energyBarLabel.fontSize = 32
        energyBarLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        energyBarLabel.zPosition = 100
        addChild(energyBarLabel)
        setupEnergyBar()
        startDrainingEnergy()
        
        // Iniciamos el timer
        startTime = CACurrentMediaTime()

        
        //CODIGOS PARA VARIAS ACCIONES DEL PERSONAJE
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(swipeRight)
        
        // Inserción de orbes cada 3 segundos
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true){_ in
            guard !self.isGameOver else { return }
            self.spawnOrb()
        }
        
        // Inserción de esqueletos cada 3.973 segundos
        Timer.scheduledTimer(withTimeInterval: 3.973, repeats: true){_ in
            guard !self.isGameOver else { return }
            self.spawnSkeleton()
        }
        
        // Inserción de trampas colgantes cada 5.739 segundos
        Timer.scheduledTimer(withTimeInterval: 5.739, repeats: true){_ in
            guard !self.isGameOver else { return }
            self.spawnTrap()
        }
    }
    
    // MARK: TOUCHES BEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Accion es del menú game over
        if isGameOver {
            if let touch = touches.first {
                let location = touch.location(in: self)
                let node = atPoint(location)
                if node.name == "restart" {
                    restartGame() // Reiniciamos la partida
                }
                
                if node.name == "back" {
                    let menu = MainMenuScene(size: self.size) // Volvemos al menú principal
                    menu.scaleMode = .aspectFill
                    run(SKAction.playSoundFileNamed("ui", waitForCompletion: false))
                    view?.presentScene(menu, transition: .fade(withDuration: 0.5))
                }
            }
            return
        }
    }
    
    // deslizar el dedo
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer){
        guard !isGameOver else { return } // Si estamos en game over bloquea los movimientos
        if gesture.direction == .up{ // Desliza hacia arriba
            knight.jump() // Ejecuta salto
        }else if gesture.direction == .down{ // Desliza hacia abajo
            knight.roll() // Ejecuta rodar
        }else if gesture.direction == .right{ // Desliza hacia la derecha
            knight.attack() // Ejecuta ataque
        }
    }
    
    
    //MARK: Función de añadir al personaje
    func addKnight(){
        knight = Knight() // Llamamos a la clase
        knight.position = CGPoint(x: frame.midX / 2, y: frame.minY + 85) // Lo posicionamos en la pantalla
        addChild(knight)
    }
    
    //MARK: Configuración visual del timer
    func setupTimer() {
        timeLabel = SKLabelNode(fontNamed: "Helvetica")
        timeLabel.fontSize = 18
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 155)
        timeLabel.zPosition = 100
        timeLabel.text = "Tiempo: 0s"
        addChild(timeLabel)
    }
    
    //MARK: Configuración de la capa de oscuridad
    func setupDarkness(){
        darknessOverlay = SKSpriteNode(color: .black, size: self.size)
        darknessOverlay.alpha = 0
        darknessOverlay.zPosition = 50
        darknessOverlay.position = CGPoint(x: frame.midX, y: frame.midY)
        darknessOverlay.blendMode = .alpha
        addChild(darknessOverlay)
    }
        
    //MARK: Game Over
    func gameOver(){
        isGameOver = true
        // Paralizamos al caballero
        knight.removeAllActions()
        
        // Label del game over
        let gameOverLabel = SKLabelNode(text: "Tu luz se extinguió...")
        gameOverLabel.fontSize = 32
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 100
        addChild(gameOverLabel)
        
        run(SKAction.playSoundFileNamed("end_game", waitForCompletion: false)) // Damos al sonido de game over
        energyBarLabel.removeFromParent() // Eliminamos el label de la barra de energía
        darknessOverlay.alpha = min(max(1, 0), 1) // Oscurecemos totalmente la pantalla

        // Label del contador (Mostramos la puntuación final / tiempo alcanzado)
        let finalTime = Int(elapsedTime)
        let timeSurvivedLabel = SKLabelNode(text: "La mantuviste \(finalTime) segundos")
        timeSurvivedLabel.fontSize = 26
        timeSurvivedLabel.fontColor = .white
        timeSurvivedLabel.position = CGPoint(x: frame.midX, y: frame.midY - 55)
        timeSurvivedLabel.zPosition = 100
        addChild(timeSurvivedLabel)
        
        // Botón reiniciar
        let restartLabel = SKLabelNode(text: "Toca para reiniciar")
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 120)
        restartLabel.zPosition = 100
        restartLabel.name = "restart"
        addChild(restartLabel)
        
        // Botón volver al menú
        let backToMenu = SKLabelNode(text: "Volver al Menú")
        backToMenu.fontSize = 24
        backToMenu.fontColor = .white
        backToMenu.position = CGPoint(x: frame.midX, y: frame.midY - 150)
        backToMenu.zPosition = 100
        backToMenu.name = "back"
        addChild(backToMenu)
    }
    
    //MARK: Función reinicio
    func restartGame() {
        let newScene = GameScene(size: self.size)
        run(SKAction.playSoundFileNamed("ui", waitForCompletion: false))
        newScene.scaleMode = self.scaleMode
        self.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    //MARK: Iniciar música
    func playBackgroundMusic(){
        let backgroundMusic = SKAudioNode(fileNamed: "background_music")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }

}
