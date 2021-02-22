//
//  TokenBehavior.swift
//  Connect4
//
//  Created by Royal Thomas on 19/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class TokenBehavior: UIDynamicBehavior {
    var gravity = UIGravityBehavior()
    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.collisionMode = UICollisionBehavior.Mode.everything
        return collider
    }()
    
    // elasticity set low and resistance set high to prevent any exaggerated jumping around of the tokens
    private lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 0
        behavior.resistance = 1
        return behavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
        gravity.magnitude = 1
        
        // remove the token as an item if it goes off bounds, or more so below the screen
        gravity.action = {
            for item in self.gravity.items{
                if(item.center.y > UIScreen.main.bounds.height + item.bounds.height){
                    self.removeToken(item as! UIView)
                }
            }
        }
    }
    
    // remove the walls and base as to allow tokens to fall as they please
    func freeFall(){
        removeChildBehavior(collider)
    }
    
    // add back base and walls
    func stopFreeFall(){
        addChildBehavior(collider)
    }
    
    // add an item to the animator
    func addToken(_ token: UIView) {
        dynamicAnimator?.referenceView?.addSubview(token)
        dynamicAnimator?.referenceView?.sendSubviewToBack(token)
        gravity.addItem(token)
        collider.addItem(token)
        itemBehavior.addItem(token)
    }
    
    // remove a token from the behavior and view
    func removeToken(_ token: UIView) {
        gravity.removeItem(token)
        collider.removeItem(token)
        itemBehavior.removeItem(token)
        token.removeFromSuperview()
    }
    
    func addBarrier(_ path: UIBezierPath, named name: String) {
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    
}
