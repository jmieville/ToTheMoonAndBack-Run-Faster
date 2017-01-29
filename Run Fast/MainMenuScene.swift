//
//  MainMenuScene.swift
//  Run Fast
//
//  Created by Jean-Marc Kampol Mieville on 11/20/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var playBtn = SKSpriteNode()
    var scoreBtn = SKSpriteNode()
    
    var title = SKLabelNode()
    
    var scoreLabel = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        initialize()
        
        getButtons()
        getLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgroundsAndGrounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location) == playBtn {
                let gameplay = GameplayScene(fileNamed: "GameplayScene")
                gameplay!.scaleMode = .aspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.doorway(withDuration: TimeInterval(1.3)))
            }
            
            if atPoint(location) == scoreBtn {
                showScore()
            }
            
        }
    }
    
    func initialize() {
        createBG()
        createGrounds()
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
            
            bgNode.position.x -= 2
            
            if bgNode.position.x < -(bgNode.size.width) {
                bgNode.position.x += bgNode.size.width * 3
            }
            
        })
    }
    
    func getButtons() {
        playBtn = self.childNode(withName: "Play") as! SKSpriteNode
        scoreBtn = self.childNode(withName: "Score") as! SKSpriteNode
    }
    
    func getLabel() {
        title = self.childNode(withName: "Title") as! SKLabelNode
        
        title.fontName = "RosewoodStd-Regular"
        title.fontSize = 120
        
        let moveUp = SKAction.moveTo(y: title.position.y + 40, duration: TimeInterval(1.3))
        let moveDown = SKAction.moveTo(y: title.position.y - 40, duration: TimeInterval(1.3))
        
        let sequence = SKAction.sequence([moveUp, moveDown])
        
        title.run(SKAction.repeatForever(sequence))
    }
    
    func showScore() {
        scoreLabel.removeFromParent()
        
        scoreLabel = SKLabelNode(fontNamed: "RosewoodStd-Regular")
        scoreLabel.fontSize = 180
        scoreLabel.text = "\(UserDefaults.standard.integer(forKey: "HighScore"))"
        scoreLabel.position = CGPoint(x: 0, y: -200)
        scoreLabel.zPosition = 9
        self.addChild(scoreLabel)
    }
}



























