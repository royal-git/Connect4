//
//  Token.swift
//  Connect4
//
//  Created by Royal Thomas on 24/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import Foundation

enum Keys: String{
    case isBot = "isBot"
    case num = "num"
    case column = "column"
    case winningToken = "winningToken"
}

public class Token: NSObject, NSCoding{
    // MARK: - encode and decode into CoreData
    public func encode(with coder: NSCoder) {
        coder.encode(isBot, forKey: Keys.isBot.rawValue)
        coder.encode(num, forKey: Keys.num.rawValue)
        coder.encode(column, forKey: Keys.column.rawValue)
        coder.encode(winningToken, forKey: Keys.winningToken.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let bot = coder.decodeBool(forKey: Keys.isBot.rawValue)
        let winningToken = coder.decodeBool(forKey: Keys.winningToken.rawValue)
        let num = coder.decodeInt64(forKey: Keys.num.rawValue)
        let column = coder.decodeInt64(forKey: Keys.column.rawValue)
        self.init(isBot: bot, num: Int(num), column: Int(column))
        
        if(winningToken){
            setWinning()
        }
    }
    
    var num: Int = -1
    var column: Int = -1
    var isBot: Bool = false
    var winningToken: Bool = false
    
    // convenience init doesn't work since this is not known during token creation.
    func setWinning() {
        winningToken = true
    }
    
    init(isBot: Bool, num: Int, column: Int){
        super.init()
        self.isBot = isBot
        self.num = num
        self.column = column
    }
    
}
