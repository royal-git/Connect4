//
//  GameVC.swift
//  Connect4
//
//  Created by Royal Thomas on 19/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit
import CoreData
import Alpha0Connect4

// Extends UIView to enable the ability to take screenshtos of specific sections of the view.
extension UIView {
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}

class GameVC: UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet var gameView: UIView!
    
    var board : [[String]]? = nil
    var boardView : BoardView? = nil
    private var tokenBehavior = TokenBehavior()
    var path = UIBezierPath()
    let layer: CALayer = CALayer()
    var reset: Bool = false
    var numberOfMoves = 0
    var playable: Bool = false
    let gameSession = GameSession()
    var tokenViewsDictionary: [Int: EllipseView] = [:]
    var tokenByTime: [Token] = []
    @IBOutlet weak var botUserImage: UserImageView!
    @IBOutlet weak var playerUserImage: UserImageView!
    
    var botsTurn: Bool = false {
        didSet{
            if(botsTurn) {
                playerUserImage.layer.borderColor = UIColor.white.cgColor
                botUserImage.layer.borderColor = UIColor.clear.cgColor
            }else{
                botUserImage.layer.borderColor = UIColor.white.cgColor
                playerUserImage.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    private lazy var animator: UIDynamicAnimator? = {
        guard gameView != nil else { return nil }
        let animator = UIDynamicAnimator(referenceView: gameView)
        animator.addBehavior(self.tokenBehavior)
        return animator
    }()
    
    private lazy var tokenSize = { () -> CGSize in
        return CGSize.init(width: self.radius() * 2, height: self.radius() * 2)
    }
    
    private lazy var cellWidth = { () -> CGFloat in
        return self.gameView.frame.width / 7
    }
    
    private lazy var cellHeight = { () -> CGFloat in
        return self.tokenSize().height
    }
    
    private lazy var radius = { () -> CGFloat in
        return self.cellWidth() / 2 * Constants.widthToDiameterRatio
    }
    
    private func showGameStartDialog() {
        let alert = UIAlertController(title: "First Turn?", message: "Select who plays first, you or the bot.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Me", style: UIAlertAction.Style.default, handler: { _ in
            self.botsTurn = false
            self.initGame()
        }))
        alert.addAction(UIAlertAction(title: "Bot", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            self.botsTurn = true
            self.initGame()
            self.playBot()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - VC Lifecyle
    override func viewDidLayoutSubviews() {
        boardView!.frame = boardView!.bounds
        boardView!.position = gameView.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show the alert dialog
        if(!playable){
            showGameStartDialog()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator?.delegate = self
        self.title = Constants.gameName
        setupBoard()
        
        // Add Swipe Gesture Recogniser to handle right swipes
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.swipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        // Add Swipe Gesture Recogniser to handle left swipes
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.swipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        self.view.backgroundColor = Constants.coolBlue
        
    }
    
    // add collission barriers
    private func addBarrier(_ path: UIBezierPath, _ name: String){
        tokenBehavior.addBarrier(path, named: name)
    }
    
    // MARK: - dropping token
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let x = sender.location(in: self.gameView).x
        if(!botsTurn && !gameSession.done && playable){
            let boundsWithinCell = x.truncatingRemainder(dividingBy: self.cellWidth())
            if(boundsWithinCell < self.cellWidth() / 10 || self.cellWidth() - boundsWithinCell < self.cellWidth() / 10){
                
                let alertController = UIAlertController(title: "", message: "Please insert tokens into the columns and not onto the middle of two columns!", preferredStyle: .alert)
                let submitAction = UIAlertAction(title:"Okay",
                                                 style: .default)
                alertController.addAction(submitAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                dropToken(x)
            }
        }
    }
    
    // save the game into core data
    private func saveGame(data: Data) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let game = Connect4(context: context)
            game.image = data
            game.winner = gameSession.outcome?.message
            game.moves = tokenByTime
            game.numMoves = Int64(numberOfMoves)
            appDelegate.saveContext()
        }
    }
    
    // Make the tokens fall down
    private func freefallTokens() {
        if(tokenViewsDictionary.count > 0 ){
            tokenBehavior.freeFall()
        }
    }
    
    // handle swipes in order to reset the game
    @objc private func swipe(_ sender: Any) {
        if(tokenByTime.count > 0){
            // Make tokens go away
            freefallTokens()
            
            // RESET VARIABLES
            playable = false
            reset = true
            tokenViewsDictionary = [:]
            tokenByTime = []
            
            // clear session
            try! gameSession.clear()
        }else{
            showGameStartDialog()
        }
    }
    
    // setup the visual board and draw borders
    private func setupBoard() {
        boardView = BoardView(gameView, tokenRadius: radius())
        setupBorders(board: boardView!)
        gameView.layer.addSublayer(boardView!)
    }
    
    // setup the physical barriers.
    private func setupBorders(board: BoardView) {
        for wall in board.getWalls(){
            addBarrier(wall, "wall")
        }
        addBarrier(board.getBase(), "base")
    }
    
    // handles a single token at a given location when the user presses a location
    private func dropToken(_ drop: CGFloat) {
        let column = Int(drop / self.cellWidth())
        DispatchQueue.global(qos: .utility).async {
            if(self.gameSession.userPlay(at: column)){
                self.numberOfMoves += 1
                if let move = self.gameSession.move{
                    DispatchQueue.main.async {
                        let xPos = drop - self.cellWidth() / 2
                        self.releaseToken(x: xPos, isBot: false, action: move.action)
                    }
                }
            }
        }
    }
    
    // handles the bots action and calls releaseToken to drop the token
    private func playBot(){
        if(playable && !self.gameSession.done){
            DispatchQueue.global(qos: .utility).async {
                if let move = self.gameSession.move{
                    let column = move.action % self.gameSession.boardLayout.columns
                    DispatchQueue.main.async {
                        let xPos = self.cellWidth() * CGFloat(column)
                        self.releaseToken(x: xPos, isBot: true, action: move.action)
                    }
                }
            }
        }
    }
    
    // makes tokens and drops them onto the board
    private func releaseToken(x: CGFloat, isBot: Bool, action: Int) {
        var frame = CGRect()
        frame.origin = CGPoint.zero
        frame.size = self.tokenSize()
        frame.origin.x = x
        
        let  column = action % Constants.columns
        let tokenView = EllipseView(frame: frame, isBot: isBot, num: self.tokenViewsDictionary.count, column: column)
        
        self.tokenBehavior.addToken(tokenView)
        self.tokenViewsDictionary[action] = tokenView
        self.tokenByTime.append(tokenView.token!)
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        // toggles whose turn it is
        botsTurn = !botsTurn
        
        // handles if it's time to reset the game
        if(reset){
            tokenBehavior.stopFreeFall()
            reset = false
            botsTurn = false
            playable  = true
            showGameStartDialog()
        }
        
        // make the bot play if it's the bot's turn now
        if(botsTurn){
            playBot()
        }
        
        // handle if the game is finished and we have a result
        if(self.gameSession.done){
            self.gameLabel.text = self.gameSession.outcome?.message
            for token in tokenViewsDictionary {
                if(gameSession.outcome!.winningPieces.contains(token.key)){
                    token.value.drawNumber(highlight: true)
                    token.value.setWinning()
                }else{
                    token.value.drawNumber(highlight: false)
                }
            }
            // calculates the size of the view to take a screenshot of.
            let yOffset = gameView.bounds.height / 2 - tokenSize().height * CGFloat(Constants.columns / 2)
            
            // takes a screenshots and saves the game with the screenshot
            let image = gameView.snapshot(of: boardView?.bounds.offsetBy(dx: 0, dy: yOffset))
            saveGame(data: image.pngData()!)
        }
    }
    
    // setup game.
    private func initGame() {
        gameLabel.text = ""
        playable = true
        gameSession.botStarts = botsTurn
        board = Array(repeating: Array(repeating: " ", count: gameSession.boardLayout.columns), count: gameSession.boardLayout.rows)
    }
}
