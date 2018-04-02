//
//  ViewController.swift
//  Todoey
//
//  Created by Jason Lewis on 2018-03-20.
//  Copyright © 2018 Controlsequipment. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var todoItems = [Item]()
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")            }
        }
        
        tableView.reloadData()
        
        //todoItems![indexPath.row].done = cell?.accessoryType == .checkmark ? true : false
        
        //saveItems(item: todoItems![indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //    return true
    //}
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         print("editing")
        if (editingStyle == .delete) {
            //context.delete(todoItems[indexPath.row])
            //todoItems.remove(at: indexPath.row)
            //saveItems()
            print("delete pressed")
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                   
                } catch {
                    print("Error saving done status, \(error)")            }
            }
            tableView.reloadData()
        } else {
            print(editingStyle)
        }
        
    }
    
    // MARK - Save and load data from storage
    
//    func saveItems(item : Item) {
//       // let encoder = PropertyListEncoder()
//
//        //do {
//            //let data = try encoder.encode(self.todoItems)
//            //try data.write(to: self.dataFilePath!)
//            //try context.save()
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            //print("Error encoding Item array: \(error)")
//            print("Error saving context: \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    /*
    
    func loadItems() {
        
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                todoItems = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
 */
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES  %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        do {
//            todoItems = try context.fetch(request)
//
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory  {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
            }
            
            //let newItem = Item()
//            let newItem = Item(context: self.context)
            //newItem.title = textField.text!
            //newItem.done = false
            //self.selectedCategory?.items.append(newItem)
            //newItem.parentCategory = LinkingObjects(fromType : self.selectedCategory, property : "item")
            //self.todoItems.append(newItem)
            
            
//            let encoder = PropertyListEncoder()
//
//            do {
//                let data = try encoder.encode(self.todoItems)
//                try data.write(to: self.dataFilePath!)
//            } catch {
//                print("Error encoding Item array: \(error)")
//            }
            
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        if searchBar.text!.count > 0 {
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ AND parentCategory.name MATCHES %@", searchBar.text!, selectedCategory!.name!)
//        }
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
        
        //self.loadItems()
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }
}


