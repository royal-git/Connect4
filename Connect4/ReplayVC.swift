//
//  ReplayVC.swift
//  Connect4
//
//  Created by Royal Thomas on 24/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class ReplayVC: UIViewController, UIDynamicAnimatorDelegate {
    private var timer = Timer()
    private var tokenViews: [EllipseView] = []
    private var tokenBehavior = TokenBehavior()
    public var game: SingleGame? = nil
    @IBOutlet weak var winningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator?.delegate = self
        self.view.backgroundColor = Constants.coolBlue
        setupBoard()
        
        // Start making the tokens fall since we know what the game was.
        if game != nil{
            beginWaterfall()
        }
    }
    
    // Makes the tokens fall and replay the game, 
    private func beginWaterfall() {
        var tempTokenHolder = game?.tokens
        
        // Uses a timer to drop a token every x seconds as set in Constants
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.delayForWaterfall), repeats: true) {
            (_:Timer)->Void in
            if let token = tempTokenHolder?[0]{
                self.releaseToken(x: CGFloat(token.column) * self.cellWidth(), isBot: token.isBot, action: 2, number: token.num)
                tempTokenHolder?.remove(at: 0)
            }
            // Ensure that we stop trying to drop tokens once we have run out
            if(tempTokenHolder!.count == 0){
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer(){
        timer.invalidate()
    }
    
    lazy var radius = { () -> CGFloat in
        return self.view.frame.width / 7 / 2  * Constants.widthToDiameterRatio
    }
    
    lazy var cellWidth = { () -> CGFloat in
        return self.view.frame.width / CGFloat(Constants.columns)
    }
    
    private lazy var animator: UIDynamicAnimator? = {
        let animator = UIDynamicAnimator(referenceView: self.view)
        animator.addBehavior(self.tokenBehavior)
        return animator
    }()
    
    // Creates a token and drops it into the board
    private func releaseToken(x: CGFloat, isBot: Bool, action: Int, number: Int) {
        var frame = CGRect()
        frame.origin = CGPoint.zero
        frame.size = CGSize(width: radius() * 2 , height: radius() * 2)
        frame.origin.x = x
        let  column = action % Constants.columns
        let tokenView = EllipseView(frame: frame, isBot: isBot, num: number, column: column)
        let isWinningToken = game!.tokens[number].winningToken
        tokenView.drawNumber(highlight: isWinningToken)
        self.tokenBehavior.addToken(tokenView)
        tokenViews.append(tokenView)
    }
    
    // Adds a physical barrier for tokens to hit
    private func addBarrier(_ path: UIBezierPath, _ name: String){
        tokenBehavior.addBarrier(path, named: name)
    }
    
    private func setupBoard() {
        let boardView = BoardView(self.view, tokenRadius: radius())
        setupBorders(board: boardView)
        self.view.layer.addSublayer(boardView)
    }
    
    // Sets up the walls and base barriers
    private func setupBorders(board: BoardView) {
        for wall in board.getWalls(){
            addBarrier(wall, "wall")
        }
        addBarrier(board.getBase(), "base")
    }
    
    // Responsible for handling situation where the view has paused
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        if(!timer.isValid){
            winningLabel.text = game?.winnerMessage
            winningLabel.textColor = UIColor.white
        }
    }
    
    
}
