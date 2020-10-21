//
//  CategoryVC.swift
//  Todoey
//
//  Created by Vasyl Senyshyn on 16.10.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryVC: SwipeTableVC{

   
    var realm = try! Realm()

    var categoryItemsArray : Results<CategoryItem>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
        title = "DO IT"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItemsArray?.count ?? 1
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryItemsArray?[indexPath.row].name ?? "NoCategoriesAdded"
        cell.backgroundColor = UIColor.init(hexString: categoryItemsArray![indexPath.item].color)
       
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItemsArray?[indexPath.row]}
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem ) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New To Do Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = CategoryItem()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveCategory(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategory(category: CategoryItem){
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func deleteCategory(category: CategoryItem){
        do {
            try realm.write{
                realm.delete(category)
            }
        } catch{
            print("Error deleting category, \(error)")
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let currentCategory = categoryItemsArray?[indexPath.item]{
            deleteCategory(category: currentCategory)
        }
    }
    
    
    
    func loadCategories(){
        
        categoryItemsArray = realm.objects(CategoryItem.self)
        
        tableView.reloadData()
    
}


    
    
}

