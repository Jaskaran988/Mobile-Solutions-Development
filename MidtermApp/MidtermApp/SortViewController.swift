//
//  SortViewController.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//
import QuartzCore
import UIKit

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func addGradientBackground() {
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
           gradientLayer.colors = [
            UIColor(red: 0.98, green: 0.88, blue: 0.78, alpha: 1.00).cgColor,
                   UIColor(red: 0.88, green: 0.98, blue: 0.94, alpha: 1.00).cgColor,
                   UIColor(red: 0.92, green: 0.79, blue: 0.95, alpha: 1.00).cgColor
        ]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           view.layer.insertSublayer(gradientLayer, at: 0)
       }
    @IBOutlet weak var sortingTable: UITableView!

    let sections = ["Due Date Sorting", "Filter by Status"]
    let sortingByDateOptions = ["Ascending", "Descending"]
    let filterByStatusOptions = ["All Task","Pending Tasks", "Completed Tasks"]

    var selectedSortingByDate: Int? = UserDefaults.standard.object(forKey: "sortByDate") as? Int
    var selectedFilterByStatus: Int? = UserDefaults.standard.object(forKey: "filterByStatus") as? Int

    override func viewDidLoad() {
        super.viewDidLoad()
        sortingTable.delegate = self
        sortingTable.dataSource = self
        addGradientBackground()
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        // Clear the sort and filter preferences
        UserDefaults.standard.removeObject(forKey: "sortByDate")
        UserDefaults.standard.removeObject(forKey: "filterByStatus")
        selectedSortingByDate = nil
        selectedFilterByStatus = nil
        sortingTable.reloadData()
        // Notify the tasks table view controller to reload data
        NotificationCenter.default.post(name: Notification.Name("SortAndFilterPreferencesChanged"), object: nil)
        // Show alert
        showAlert(title: "Success", message: "All sorting and filtering options cleared.")
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        // Save the sort and filter preferences
        if let selectedSortingByDate = selectedSortingByDate {
            UserDefaults.standard.set(selectedSortingByDate, forKey: "sortByDate")
        }
        
        if let selectedFilterByStatus = selectedFilterByStatus {
            UserDefaults.standard.set(selectedFilterByStatus, forKey: "filterByStatus")
        }
        // Notify the tasks table view controller to reload data
        NotificationCenter.default.post(name: Notification.Name("SortAndFilterPreferencesChanged"), object: nil)
        // Show alert
        showAlert(title: "Success", message: "Sorting and filtering options added.")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sortingByDateOptions.count
        case 1:
            return filterByStatusOptions.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = sortingByDateOptions[indexPath.row]
            cell.accessoryType = selectedSortingByDate == indexPath.row ? .checkmark : .none
        case 1:
            cell.textLabel?.text = filterByStatusOptions[indexPath.row]
            cell.accessoryType = selectedFilterByStatus == indexPath.row ? .checkmark : .none
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedSortingByDate = indexPath.row
        case 1:
            selectedFilterByStatus = indexPath.row
        default:
            break
        }
        tableView.reloadData()
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

