//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jason Lewis on 2018-03-27.
//  Copyright © 2018 Controlsequipment. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    //var categoryArray = [Category]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //context.delete(categoryArray[indexPath.row])
            //categoryArray.remove(at: indexPath.row)
            //saveCategory()
            if let category = categoryArray?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                    }
                    
                } catch {
                    print("Error saving done status, \(error)")            }
            }
            tableView.reloadData()
        } else {
            print(editingStyle)
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    
    // CoreData Method
/*
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
 */
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
//        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//        
//        tableView.reloadData()
//
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert    )
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // CoreData Method
            //let newCategory = Category(context: self.context)
            
            // Realm Method
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //self.categoryArray.append(newCategory)
            //self.saveCategory()
            
            self.save(category : newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated:true, completion: nil)
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !self.isEditing {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray?[indexPath.row]
        }
    }
    
    
    
}
