//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Jami on 2018/2/5.
//  Copyright © 2018年 Jami. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()

    var todoItems: Results<Item>?
  
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.color else {fatalError()}
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: colorHex)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
            updateNavBar(withHexCode: "25A4FE")
    
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String){
     
        guard let navBar = navigationController?.navigationBar  else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor

    }
    
    
    
    //MARK: - Tableview Datasource Methods
    //Define rows if nil set to 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //Define cells, if not nil then implement, if nil then add text "No Items Added"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                    cell.backgroundColor = color
                
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                    }
            
            
            
            
//            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//
//            print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            // = number of this row/total rows = (indexPath.row / todoItems!.count)
            
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        //if item.done == true { cell.accessoryType = .checkmark } else { cell.accessoryType = .none }
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    //MARK - TableView Delegate Method - didSelectRowAt
    // if let item =(unwrap optional) => realm.write {} => item.done = !
    //=> try => do {} catch {} => print(\(error)) =>tableView.reloadData() => deselectRow animated
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //whta will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        }
                } catch {
                    print("Error saving new items, \(error)")
                }
            self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

//MARK: - Data Manipulation Methods
//not very understand of this realm expression
    
    func loadItems() {

        todoItems = realm.objects(Item.self)
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
    
}
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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

