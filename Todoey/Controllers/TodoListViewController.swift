//
//  ViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Cell 1"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Cell 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Cell 3"
        itemArray.append(newItem3)
      
        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = item
        }
    }

    //MARK :- Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        cell.accessoryType = item.status ? .checkmark : .none
        
        return cell
    }
    
    //MARK :- Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        
        tableView.reloadData()
        
        //Creating animation on click ..making white on select.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what'll happen once the user clicks the Add Item button on our UIAlert

            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray") //using defaults for persistent data IMP
            
            self.tableView.reloadData()  //we just need to reload data after processing itemArray
        }
        //Adding textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        //presenting on alert
        present(alert, animated: true, completion: nil)
    
    }
    
}

