//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ToDoListVC: SwipeTableVC {

    @IBOutlet weak var searchBar: UISearchBar!
    var ToDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : CategoryItem? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
        
        }
         
    
    override func viewWillAppear(_ animated: Bool) {

            if let colorHex = selectedCategory?.color {

                title = selectedCategory!.name

                guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists stupid :(")}

                if let navBarColor = UIColor(hexString: colorHex) {
                    navBar.backgroundColor = navBarColor
                    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    searchBar.barTintColor = UIColor(hexString: colorHex)
                    searchBar.searchTextField.backgroundColor = .white

                    navigationController?.navigationBar.subviews[0].backgroundColor = navBarColor

                }
            }
        }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = ToDoItems?[indexPath.item]{
            
            let backgrd = UIColor.init(hexString: selectedCategory!.color)
            
            cell.backgroundColor = backgrd?.darken(byPercentage:CGFloat(indexPath.item) / CGFloat(ToDoItems!.count))
            
            
                
            
        
        cell.textLabel?.text = item.title
            cell.textLabel?.textColor = ContrastColorOf(backgrd!, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items yet"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        if let item = ToDoItems?[indexPath.row]{
           
            do{ try realm.write{
                item.done = !item.done
            }
            } catch {
                print ("error updating")
            }
        }
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.item)
        
//        ToDoItems[indexPath.item].done = !ToDoItems[indexPath.item].done
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//         saveItems()
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let currentItem = ToDoItems?[indexPath.item]{
            do {
                try realm.write{
                    realm.delete(currentItem)
                }
            } catch{
                print("Error saving context, \(error)")
            }
        
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.colorItem = UIColor.randomFlat().hexValue()
                        
 
                        newItem.date = Date() as NSDate
                        currentCategory.items.append(newItem)
                    }
                    
                } catch{
                    print("Error saving context, \(error)")
                }
                }
          

            
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
       
        
    }
    

    
    func loadItems(){
        ToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
     
        tableView.reloadData()

}

}
extension ToDoListVC: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ToDoItems = ToDoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if ((searchBar.text?.isEmpty) != nil){
            loadItems()
        }
        if searchBar.text?.count == 0{
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
