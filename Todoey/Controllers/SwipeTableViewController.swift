//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 16/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Tableview datasource method..
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
            
            cell.delegate = self
            
            return cell
        }

    //MARK:- SwipeTableViewCell delegate methods..
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    //Swipe behavoiur..
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()    //SwipeTableOption here to automatically delete + refresh
        options.expansionStyle = .destructive(automaticallyDelete: true)
        //options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        //update our data model by overriding it in subClass
    }
}
