//
//  UserImageView.swift
//  Connect4
//
//  Created by Royal Thomas on 25/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class UserImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        layer.cornerRadius = self.layer.frame.height / 2
        layer.borderWidth = 3
        layer.borderColor = UIColor.clear.cgColor
    }
    
}
