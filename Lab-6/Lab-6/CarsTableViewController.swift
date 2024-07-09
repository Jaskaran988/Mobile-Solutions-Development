//
//  CarsTableViewController.swift
//  Lab-6
//
//  Created by user239680 on 7/7/24.
//
import UIKit

class Car: Codable {
    var make: String
    var model: String
    
    init(make: String, model: String) {
        self.make = make
        self.model = model
    }
}

class CarsTableViewController: UITableViewController {
    //    hardcoded items
    var cars = [
        Car(make: "Toyota", model: "Camry"),
        Car(make: "Honda", model: "Civic"),
        Car(make: "Ford", model: "Mustang"),
        Car(make: "Chevrolet", model: "Impala"),
        Car(make: "Nissan", model: "Altima"),
        Car(make: "BMW", model: "3 Series"),
        Car(make: "Audi", model: "A4"),
        Car(make: "Mercedes-Benz", model: "C-Class")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load cars from UserDefaults
        if let savedCarsData = UserDefaults.standard.data(forKey: "cars"),
           let savedCars = try? JSONDecoder().decode([Car].self, from: savedCarsData) {
            cars = savedCars
        }

        // Add Edit button to the top left
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "Cars"
        // Add Add button to the top right
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCar))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addCar() {
        let alert = UIAlertController(title: "Add Car", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Car Make"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Car Model"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let make = alert.textFields?[0].text, !make.isEmpty,
                  let model = alert.textFields?[1].text, !model.isEmpty else {
                return
            }
            
            let car = Car(make: make, model: model)
            self.cars.append(car)
            self.saveCars()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCars() {
        if let savedCarsData = try? JSONEncoder().encode(cars) {
            UserDefaults.standard.set(savedCarsData, forKey: "cars")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.make
        cell.detailTextLabel?.text = car.model
        cell.imageView?.image = UIImage(named: "defaultImage")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cars.remove(at: indexPath.row)
            saveCars()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCar = cars.remove(at: fromIndexPath.row)
        cars.insert(movedCar, at: to.row)
        saveCars()
    }
}

