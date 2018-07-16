//
//  ViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//
//
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    //let defaults = UserDefaults.standard
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
           loadItems()  //loading items from CONTEXT..into itemArray
            tableView.rowHeight = 60.0
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //checking file path for storage ..
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
//        let newItem = Item()       * Hardcode saving data into itemArray
//        newItem.title = "Cell 1"
//        itemArray.append(newItem)
        
//         loading items from ToDoListArray
//        if let item = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = item
//        }
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
            title = selectedCategory?.name

            guard let colourHex = selectedCategory?.colour else { fatalError() }
            updateNavbar(withHexCode: colourHex)
     }

    override func viewWillDisappear(_ animated: Bool) {
       
        updateNavbar(withHexCode: "1D9BF6")
    }
    
    //MARK:- Navbar setup methods
    func updateNavbar(withHexCode colourHexCode : String) {
        
        guard let navbar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist!")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navbar.barTintColor = navBarColour
        
        navbar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }

    //MARK:- Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            //Ternary operator ==>
            cell.accessoryType = item.status ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK:- Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                item.status = !item.status
                }
            }catch {
                print("Error saving status of item, \(error)")
            }
        }

        tableView.reloadData()
        
        //Creating animation on click ..making white on select.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what'll happen once the user clicks the Add Item button on our UIAlert

            //Creating new items..or saving
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                        print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()

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
   
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK:- Delete data with Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch {
                print("Error saving status of item, \(error)")
            }
        }
    }
}

//MARK:- Search Bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
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



