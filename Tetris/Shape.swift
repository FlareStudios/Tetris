//
//  Shape.swift
//  Tetris
//
//  Created by Bijan Agahi on 9/6/15.
//  Copyright (c) 2015 FlareStudios. All rights reserved.
//

//REMEMBER: Shapes are composed of BLOCKS. There are 6 Block colors, comprising 7 shapes

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self{
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1:-1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

let NumShapeTypes: UInt32 = 7

let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
    let color: BlockColor //The Color of the shape (does not change)
    
    var blocks = Array<Block>() //Will hold all the blocks comprising the shape
    var orientation: Orientation //Current Orientaiton of the shape
    var column, row: Int //Anchor point of the shape
    
    //The following two functions will be overrided by their respective subclasses:
    
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    var bottomBlocksForOrientations: [Orientation: Array<Block>]{
        return [:]
    }
    
    var bottomBlocks: Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }
    
    //Hashable Protocol
    var hashValue: Int {
        return reduce(blocks, 0) {$0.hashValue ^ $1.hashValue}
    }
    
    //Printable Protocol
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation) {
        self.column = column
        self.row = row
        self.color = color
        self.orientation = orientation
        initializeBlocks()
    }
    
    convenience init(column: Int, row: Int){
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    final func initializeBlocks() {
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    
    final func rotateBlocks(orientaiton: Orientation){
        if let blockRowColumnTranslation: Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {
            for (idx, diff) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + diff.columnDiff
                blocks[idx].row = row + diff.rowDiff
            }
        }
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows:1)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    final class func random(startingColumn: Int, startingRow: Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LShape(column: startingColumn, row: startingRow)
        case 2:
            return TShape(column:startingColumn, row:startingRow)
        case 3:
            return LShape(column:startingColumn, row:startingRow)
        case 4:
            return JShape(column:startingColumn, row:startingRow)
        case 5:
            return SShape(column:startingColumn, row:startingRow)
        default:
            return ZShape(column:startingColumn, row:startingRow)
        }
    
    }
}

func ==(lhs:Shape, rhs:Shape) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}




































