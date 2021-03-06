//
//  Tetris.swift
//  Tetris
//
//  Created by Bijan Agahi on 9/6/15.
//  Copyright (c) 2015 FlareStudios. All rights reserved.
//

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

class Tetris {
    var blockArray: Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    
    init() {
        nextShape = nil
        fallingShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        if nextShape == nil {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
    }
    
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        return (fallingShape, nextShape)
    }
}