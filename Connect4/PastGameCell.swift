//
//  PastGameCell.swift
//  Connect4
//
//  Created by Royal Thomas on 24/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit

class PastGameCell: UITableViewCell {

    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    var game : SingleGame? = nil {
        didSet{
            winnerLabel.text = game!.winnerMessage
            movesLabel.text = ("You played \(game!.numberOfMoves) moves!")
            self.layer.backgroundColor = Constants.coolBlue.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Setup the cell by passing in an UIImage
    func setup(image: UIImage){
        gameImage.image = image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
