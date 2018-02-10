//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jami on 2018/2/8.
//  Copyright © 2018年 Jami. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategories()
        
        tableView.separatorStyle = .none
        

        
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
        
        cell.backgroundColor = UIColor(hexString:(categories?[indexPath.row].color ?? "25A4FE"))

        
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categories?[indexPath.row] {
        
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    }
            } catch {
                print("Error deleting category, \(error)")
            }
        }

    }
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)

        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Swipe Cell Delegate Methods




