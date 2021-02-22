//
//  BoardView.swift
//  Connect4
//
//  Created by Royal Thomas on 21/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class BoardView: CALayer {
    
    var boardWidth: CGFloat? = nil
    var tokenRadius: CGFloat? = nil
    var boardHeight: CGFloat? = nil
    var parentView: UIView? = nil
    
    lazy var cellWidth: CGFloat = {
        return boardWidth! / CGFloat(Constants.columns)
    }()
    
    lazy var cellHeight: CGFloat = {
        return self.tokenRadius! * 2
    }()
    
    // MARK: - SETUP BOARD VIEW
    init(_ view: UIView, tokenRadius: CGFloat) {
        super.init()
        self.parentView = view
        self.boardHeight = view.frame.height
        self.boardWidth = view.frame.width
        self.tokenRadius = tokenRadius
        
        frame = view.bounds
        backgroundColor =  Constants.coolBlue.cgColor
        backgroundColor = UIColor.white.cgColor
        bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: cellHeight * 6)
        cornerRadius = 30
        drawHolesUsingMask()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Returns arrays of paths for walls
    func getWalls() -> [UIBezierPath]{
        var walls: [UIBezierPath] = []
        let top = boardHeight! / 2 - cellHeight * CGFloat(Constants.rows / 2)
        for i in 0...Constants.columns{
            let barrier = drawWallBarrier(xValue: CGFloat(i) * cellWidth, yBegin: top, yEnd: boardHeight!)
            walls.append(barrier)
        }
        return walls
    }
    
    // Returns the path for the base
    func getBase() -> UIBezierPath {
        let bottomLine = UIBezierPath()
        bottomLine.move(to: CGPoint(x: 0, y: position.y  + frame.height / 2  ))
        bottomLine.addLine(to: CGPoint(x: parentView!.bounds.width, y: position.y  + frame.height / 2))
        return bottomLine
    }
    
    // Draws a wall given the x coordinate and the distance
    private func drawWallBarrier( xValue: CGFloat, yBegin: CGFloat, yEnd: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 0
        path.move(to: CGPoint(x: xValue, y: yBegin))
        path.addLine(to: CGPoint(x: xValue, y: yEnd))
        return path
    }
    
    // Used to draw a mask so that we can draw circular holes onto a layer
    private func drawHolesUsingMask() {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(bounds)
        
        // Make hole smaller than the radius of the tokens
        let holeDiameter =  cellWidth - 15
        let paddingWidth = cellWidth / 2 - holeDiameter / 2
        let paddingHeight = cellHeight / 2 - holeDiameter / 2
        for i in 0...Constants.columns-1{
            for j in 0...Constants.rows-1{
                let maskRect = CGRect(x:  (CGFloat(i) * cellWidth) + paddingWidth, y: (CGFloat(j) * cellHeight) + paddingHeight, width: holeDiameter, height:  holeDiameter)
                path.addEllipse(in: maskRect)
            }
        }
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // Set the mask of the view.
        mask = maskLayer;
    }
}
