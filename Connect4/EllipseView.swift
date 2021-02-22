//
//  EllipseView.swift
//  Connect4
//
//  Created by Royal Thomas on 19/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class EllipseView: UIView {
    var token: Token? = nil
    var radius: Int? = nil
    
    // MARK: - SETUP TOKEN
    init(frame: CGRect, isBot: Bool, num: Int, column: Int) {
        super.init(frame: frame)
        radius = Int(frame.width / 2)
        layer.cornerRadius = frame.size.width / 2.0
        layer.backgroundColor = (isBot == true) ? UIColor.systemRed.cgColor : UIColor.systemYellow.cgColor
        token = Token(isBot: isBot, num: num, column: column)
    }
    
    
    func setWinning() {
        token?.setWinning()
    }
    
    // Draw a label on the token to show the index or the order in which it was inserted
    func drawNumber(highlight: Bool){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: radius!, height: radius!))
        if let currentToken = token {
            let strokeTextAttributes = [
                NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor : (currentToken.isBot == true) ? UIColor.systemRed : UIColor.systemYellow,
                NSAttributedString.Key.strokeWidth : -4.0,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                as [NSAttributedString.Key : Any]
            
            label.center = CGPoint(x: radius!, y: radius!)
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 15)
            if(highlight){
                label.text = "\(currentToken.num)"
                label.textColor = UIColor.white
            }else{ 
                label.attributedText = NSMutableAttributedString(string: "\(currentToken.num)", attributes: strokeTextAttributes)
            }
            self.addSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    func isBot() -> Bool?{
        if let tkn = token {
            return tkn.isBot
        }
        return nil
    }
}
