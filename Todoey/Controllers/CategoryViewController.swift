//
//  CategoryViewController.swift
//  Todoey
//
//  Created by AshwaniKumar on 13/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()

    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()

    //checking file path for storage in core Data..
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategories()
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none


    }
    
    //MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
    
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }

        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }


    //MARK:- Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving categories, \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {

        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK:- Delete data with Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error saving status of item, \(error)")
            }
        }
    }


    //MARK:- Add new Category items..
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what'll happen once the user clicks the Add Category button on our UIAlert

            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
    
            self.save(category: newCategory)
        }
        //Adding textField to Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
    
        alert.addAction(action)
        //Presenting an alert
        present(alert, animated: true, completion: nil)
    }
    
}








