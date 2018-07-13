//
//  ViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()  //loading items from CONTEXT..into itemArray
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()

        //checking file path for storage ..
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
        
        
//        let newItem = Item()       * Hardcode saving data into itemArray
//        newItem.title = "Cell 1"
//        itemArray.append(newItem)
        
//         loading items from ToDoListArray
//        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = item
//        }
    
    }

    //MARK:- Tableview datasource methods
    
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
    
    //MARK:- Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        
        saveItems()    //calling for checkmarks updation
        
        //Creating animation on click ..making white on select.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what'll happen once the user clicks the Add Item button on our UIAlert

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.status = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems() //calling for adding items..
            
 //*       //self.defaults.set(self.itemArray, forKey: "ToDoListArray") //using defaults for persistent data IMP
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

    
    //MARK:- Model manipulation methods
   
    func saveItems() {

        do {
            try context.save()
        }catch {
            
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
}


//MARK:- Search Bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //this is predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //array of sortDescriptor
        
        loadItems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



