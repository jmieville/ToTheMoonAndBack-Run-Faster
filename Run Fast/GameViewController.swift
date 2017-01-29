//
//  GameViewController.swift
//  Run Fast
//
//  Created by Jean-Marc Kampol Mieville on 11/19/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
            
            
            
            
            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                view.showsPhysics = true
                view.showsFPS = true
                view.showsNodeCount = true
                
                
            }
        }
        
        var shouldAutorotate: Bool {
            return true
        }
        
        var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .allButUpsideDown
            } else {
                return .all
            }
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
        
        var prefersStatusBarHidden: Bool {
            return true
        }
    }
}
