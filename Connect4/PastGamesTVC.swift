//
//  PastGamesTVC.swift
//  Connect4
//
//  Created by Royal Thomas on 24/03/2020.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit
import CoreData
class PastGamesTVC: UITableViewController {
    // Arrays used to store images and isntances of games.
    var images: [UIImage] = []
    var games: [SingleGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    // MARK: - Load DATA
    // Load data from coredata and fill the arrays
    private func loadData() {
        var loadedImages = [Connect4]()
        var imageHolder = [UIImage]()
        var gameHolder = [SingleGame]()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            let imageRequest:NSFetchRequest<Connect4> = Connect4.fetchRequest()
            do {
                try loadedImages = context.fetch(imageRequest)
                for image in loadedImages{
                    imageHolder.append(UIImage(data: image.image!)!)
                    if let moves = image.moves{
                        gameHolder.append(SingleGame(tokens: moves, message: image.winner!, numMoves: Int(image.numMoves)))
                    }
                }
                images = imageHolder
                games = gameHolder
            } catch {
                print("Unable to load data, something went wrong!")
            }
        }
        tableView.reloadData()
    }
    
    // If a column is clocked, setup the replayvc with the game so it can start playing when loaded.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "performReplaySegue"){
            let destination = segue.destination as! ReplayVC
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.game = games[indexPath.row]
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastGameCell", for: indexPath) as! PastGameCell
        cell.setup(image: images[indexPath.row])
        cell.game = games[indexPath.row]
        return cell
    }
    
    
}
