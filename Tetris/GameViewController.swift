//
//  GameViewController.swift
//  Tetris
//
//  Created by Bijan Agahi on 9/6/15.
//  Copyright (c) 2015 FlareStudios. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var tetris:Tetris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //Create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        tetris = Tetris()
        tetris.beginGame()
        
        //Present the Scene
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScreen(tetris.nextShape!) {
            self.tetris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.tetris.nextShape!) {
                let nextShapes = self.tetris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScreen(nextShapes.nextShape!) {}
            }
        }

    }


    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didTick() {
        tetris.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(tetris.fallingShape!, completion: {})
    }
}
