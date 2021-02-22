//
//  Game.swift
//  Connect4
//
//  Created by Royal Thomas on 24/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation

// Class used to store a single game, with tokens, who won and the number of moves taken.
class SingleGame {
    public var tokens: [Token] = []
    public var winnerMessage: String = ""
    public var numberOfMoves: Int = 0
    
    init(tokens: [Token], message: String, numMoves: Int) {
        self.tokens = tokens
        self.winnerMessage =  message
        self.numberOfMoves = numMoves
    }
}
