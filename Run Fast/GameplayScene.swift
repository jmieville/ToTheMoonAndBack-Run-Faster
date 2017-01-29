//
//  GameplayScene.swift
//  Run Fast
//
//  Created by Jean-Marc Kampol Mieville on 11/19/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate  {
    
    var player = Player()
    var canJump = false
    var obstacles = [SKSpriteNode]()
    var movePlayer = false
    var playerOnObstacle = false
    var isAlive = false
    
    var spawner = Timer()
    
    var scoreLabel = SKLabelNode()
    var score = 0
    
    var counter = Timer()
    
    var pausePanel = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        initialize();
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if isAlive {
            moveBackgroundsAndGrounds()

        }
        
        
        if movePlayer {
            player.position.x -= 4
        }
        
        checkPlayerBounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Restart" {
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay!.scaleMode = .aspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.doorway(withDuration: TimeInterval(1)))
            }
            
            if atPoint(location).name == "Quit" {
                let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
                mainMenu!.scaleMode = .aspectFill
                self.view?.presentScene(mainMenu!, transition: SKTransition.doorway(withDuration: 1))
            }
            
            if atPoint(location).name == "Pause" {
                createPausePanel()
                //canJump = false
            }
            
            if atPoint(location).name == "Resume" {
                self.scene?.isPaused = false
                pausePanel.removeFromParent()
                spawner = Timer.scheduledTimer(timeInterval: TimeInterval(randomBetweenNumbers(firstNumber: 2.5, secondNumber: 6)), target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)
                counter = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameplayScene.incrementScore), userInfo: nil, repeats: true)
            }
        }
        
        if canJump {
            canJump = false
            player.jump()

        }
        
        if playerOnObstacle {
            player.jump()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Ground" {
            canJump = true
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Obstacle" {
            if !canJump {
                movePlayer = true
                playerOnObstacle = true
            }
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Cactus" {
            // kill the player and prompt restarting game button
            playerDied()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "Obstacle" {
            movePlayer = false
            playerOnObstacle = false
            
        }

    }
    
    func initialize() {
        
        isAlive = true
        physicsWorld.contactDelegate = self
        createPlayer()
        createBG();
        createGrounds()
        createObstacles()
        getLabel()
        
        spawner = Timer.scheduledTimer(timeInterval: TimeInterval(randomBetweenNumbers(firstNumber: 2.5, secondNumber: 6)), target: self, selector: #selector(GameplayScene.spawnObstacles), userInfo: nil, repeats: true)
        counter = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameplayScene.incrementScore), userInfo: nil, repeats: true)
    }
    
    func createPlayer() {
        player = Player(imageNamed: "Player 1")
        player.position = CGPoint(x: -10, y: 20)
        player.initialize()
        self.addChild(player)
    }
    
    func createBG() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG");
            bg.name = "BG";
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0);
            bg.zPosition = 0;

            self.addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "Ground");
            bg.name = "Ground";
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: -(self.frame.size.height/2 + 20));
            bg.zPosition = 3;
            bg.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: CGFloat(bg.size.width), height: CGFloat(bg.size.height)))
            bg.physicsBody?.affectedByGravity = false
            bg.physicsBody?.categoryBitMask = ColliderType.Ground
            bg.physicsBody?.isDynamic = false
            
            self.addChild(bg)
        }
    }
    
    func moveBackgroundsAndGrounds() {
        
        enumerateChildNodes(withName: "BG", using: {(node, error) in
            
            // any oce put here will be exectued everytime we run every BG name
            let bgNode = node as! SKSpriteNode
            
        bgNode.position.x -= 4
            
            if bgNode.position.x < -(bgNode.size.width) {
                bgNode.position.x += bgNode.size.width * 3
            }
            
        })
        
        enumerateChildNodes(withName: "Ground", using: {(node, error) in
            
            // any oce put here will be exectued everytime we run every BG name
            let bgNode = node as! SKSpriteNode
            
            bgNode.position.x -= 12
            
            if bgNode.position.x < -(bgNode.size.width) {
                bgNode.position.x += bgNode.size.width * 3
            }
            
        })
    }
    
    func createObstacles() {
        for i in 0...5 {
            
            let obstacle = SKSpriteNode(imageNamed: "Obstacle \(i)")
            
            if i == 0 {
                obstacle.name = "Cactus"
                obstacle.setScale(0.25)
            } else {
                obstacle.name = "Obstacle"
                obstacle.setScale(0.3)
            }
            
            
            obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            obstacle.zPosition = 1
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.affectedByGravity = true
            obstacle.physicsBody?.categoryBitMask = ColliderType.Obstacle
            
            obstacles.append(obstacle)
        }
    }
    
    func spawnObstacles() {
        
        let index = Int(arc4random_uniform(UInt32(obstacles.count)))
        let obstacle = obstacles[index].copy() as! SKSpriteNode
        obstacle.position = CGPoint(x: self.frame.size.width + obstacle.size.width, y: 50)
        let move = SKAction.moveTo(x: -(self.frame.size.width * 2), duration: TimeInterval(15))
        let remove = SKAction.removeFromParent();
        
        let sequence = SKAction.sequence([move, remove])
        
        obstacle.run(sequence)
        self.addChild(obstacle)
    }
    
    func randomBetweenNumbers(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
    
    func checkPlayerBounds() {
        
        if isAlive {
            if player.position.x < -(self.frame.size.width / 2) - 35 {
                playerDied()
            }
        }

    }
    
    func getLabel() {
        scoreLabel = self.childNode(withName: "Score Label") as! SKLabelNode
        scoreLabel.text = "0"
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func createPausePanel() {
        
        spawner.invalidate()
        counter.invalidate()
        self.isPaused = true
        
        pausePanel = SKSpriteNode(imageNamed: "Pause Panel")
        pausePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pausePanel.position = CGPoint(x: 0, y: 0)
        pausePanel.zPosition = 9
        
        let resume = SKSpriteNode(imageNamed: "Play")
        let quit = SKSpriteNode(imageNamed: "Quit")
        
        
        resume.name = "Resume"
        resume.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        resume.position = CGPoint(x: -155, y: 0)
        resume.zPosition = 10
        resume.setScale(0.7)
        
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 155, y: 0)
        quit.zPosition = 10
        quit.setScale(0.7)
        
        pausePanel.addChild(resume)
        pausePanel.addChild(quit)
        
        self.addChild(pausePanel)
        
    }
    
    func playerDied() {
        
        let highscore = UserDefaults.standard.integer(forKey: "HighScore")
        
        if highscore < score {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        player.removeFromParent()
        
        for child in children {
            if child.name == "Obstacle" || child.name == "Cactus" {
                child.removeFromParent()
            }
        }
        
        isAlive = false
        
        let restart = SKSpriteNode(imageNamed: "Restart")
        let quit = SKSpriteNode(imageNamed: "Quit")
        
        restart.name = "Restart"
        restart.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        restart.position = CGPoint(x: -200, y: 0)
        restart.zPosition = 10
        restart.setScale(0)
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 200, y: 0)
        quit.zPosition = 10
        quit.setScale(0)
        
        let scaleUp = SKAction.scale(to: 0.6, duration: TimeInterval(0.5))
        
        restart.run(scaleUp)
        quit.run(scaleUp)
        
        self.addChild(restart)
        self.addChild(quit)
        
        spawner.invalidate()
        counter.invalidate()
    }
}
