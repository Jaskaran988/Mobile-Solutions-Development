//
//  ToDoViewController.swift
//  Lab-6
//
//  Created by user239680 on 7/7/24.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    hardcoded items
    var toDoList: [String: [String]] =  [
        "Work": ["Finish report", "Email client", "Prepare presentation", "Attend meeting"],
        "Personal": ["Buy groceries", "Call mom", "Exercise", "Read a book"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoTable.delegate = self
        toDoTable.dataSource = self
        self.title = "To-Do List"
        
        // Load data from UserDefaults
        if let savedToDoList = UserDefaults.standard.dictionary(forKey: "toDoList") as? [String: [String]] {
            toDoList = savedToDoList
        }

    }

    @IBOutlet weak var toDoTable: UITableView!
    
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBAction func clearTextFields(_ sender: Any) {
        sectionTextField.text = ""
        itemTextField.text = ""
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let sectionText = sectionTextField.text, !sectionText.isEmpty,
                let itemText = itemTextField.text, !itemText.isEmpty else {
              showAlert(title: "Error", message: "Fields cannot be empty")
              return
          }

          if toDoList[sectionText] != nil {
              toDoList[sectionText]?.append(itemText)
          } else {
              toDoList[sectionText] = [itemText]
          }

          UserDefaults.standard.set(toDoList, forKey: "toDoList")
          toDoTable.reloadData()
          clearTextFields(sender)
          showAlert(title: "Success", message: "Item added successfully")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return toDoList.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(toDoList.keys)[section]
        return toDoList[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(toDoList.keys)[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let key = Array(toDoList.keys)[indexPath.section]
        cell.textLabel?.text = toDoList[key]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = Array(toDoList.keys)[indexPath.section]
            toDoList[key]?.remove(at: indexPath.row)
            
            if toDoList[key]?.isEmpty ?? false {
                toDoList[key] = []
            }
            
            UserDefaults.standard.set(toDoList, forKey: "toDoList")
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromKey = Array(toDoList.keys)[fromIndexPath.section]
        let toKey = Array(toDoList.keys)[to.section]
        
        if var fromItems = toDoList[fromKey], var toItems = toDoList[toKey] {
            let movedItem = fromItems.remove(at: fromIndexPath.row)
            toItems.insert(movedItem, at: to.row)
            
            toDoList[fromKey] = fromItems
            toDoList[toKey] = toItems
            UserDefaults.standard.set(toDoList, forKey: "toDoList")
        }
    }
}

