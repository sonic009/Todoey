//
//  ViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["hello cell 1","hello cell 2","hello cell 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK :- Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK :- Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //Creating animation on click ..making white on select.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK :- Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what'll happen once the user clicks the Add Item button on our UIAlert
            // print(textField.text!) //printing text inside text field
            
            self.itemArray.append(textField.text!)
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

