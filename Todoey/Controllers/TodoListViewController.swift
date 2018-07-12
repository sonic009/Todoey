//
//  ViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    //creating file path for storage ..
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(datafilePath!)
        
        loadItems()  //loading items from .plist file after decoding...
        
//        let newItem = Item()       * Hardcode saving data into itemArray
//        newItem.title = "Cell 1"
//        itemArray.append(newItem)
        
//         loading items from ToDoListArray
//        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = item
//        }
    
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
        
        saveItems()    //calling for checkmarks updation
        
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
            
            self.saveItems() //calling for adding items..
            
 //*        //self.defaults.set(self.itemArray, forKey: "ToDoListArray") //using defaults for persistent data IMP
            //self.tableView.reloadData()  //we just need to reload data after processing itemArray
                                        //no longer need bcz it already exists in saveItems method.
        }
        
        //Adding textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        //presenting on alert
        present(alert, animated: true, completion: nil)

    }
    
    //MARK :- Model manipulation methods
    
    func saveItems() {
    
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: datafilePath!)
        }catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
  
    func loadItems() {
        if let data = try? Data(contentsOf: datafilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

