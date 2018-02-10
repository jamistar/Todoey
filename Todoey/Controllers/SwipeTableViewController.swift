//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Jami on 2018/2/9.
//  Copyright © 2018年 Jami. All rights reserved.
//

import UIKit
import SwipeCellKit

//superclass for SwipeCellKit
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

            tableView.rowHeight = 80  //row hight for better UI
        
    }
    
    //MARK: - TableView Datasource Methods - cellForRowAt
    //copy paste usage on https://github.com/SwipeCellKit/SwipeCellKit
    //Set the delegate property on SwipeTableViewCell:
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        //Check the Identifier of cells on storyboard, should be "Cell" now.
        
        cell.delegate = self
        
        return cell
    }
    
    
    //Adopt the SwipeTableViewCellDelegate protocol:
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
                        
        }
        
        // customize the action appearance
        // copy icon from github and change name to fit the action in Todoey
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    //this usage is copied from github
    //Optionally, you can implement the editActionsOptionsForRowAt method to customize the behavior of the swipe actions:
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //super class
    //an empty model with will be override for updateModel
    func updateModel(at indexPath: IndexPath) {
        // Update our datamodel
        print("Item deleted from superclass")
    }



}

