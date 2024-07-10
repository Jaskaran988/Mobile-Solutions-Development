//
//  TasksTableViewController.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//
import QuartzCore
import UIKit

class TasksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tasksTable: UITableView!
    func addGradientBackground() {
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [
              UIColor(red: 1.00, green: 0.87, blue: 0.68, alpha: 1.00).cgColor, 
              UIColor(red: 0.80, green: 0.92, blue: 0.77, alpha: 1.00).cgColor
          ]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           view.layer.insertSublayer(gradientLayer, at: 0)
       }
    // tasks
    var tasks: [Task] = []
    var isLoadDataCall = true
    override func viewDidLoad() {
        addGradientBackground()
        super.viewDidLoad()
        self.title = "List of Tasks"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortTapped))
        tasksTable.delegate = self
        tasksTable.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(sortAndFilterPreferencesChanged), name: Notification.Name("SortAndFilterPreferencesChanged"), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadDataCall {
            loadTasks()
        }
    }

    func loadTasks() {
        tasks = TaskDataFunctions.shared.retrieveTasks()
        self.tasksTable.reloadData()
    }
    
    @objc func sortTapped() {
        let sortVC = storyboard?.instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
        navigationController?.pushViewController(sortVC, animated: true)
    }

    @objc func sortAndFilterPreferencesChanged() {
        sortAndFilterTasks()
        self.tasksTable.reloadData()
    }

    func sortAndFilterTasks() {
        // Load sort preferences
        isLoadDataCall = false
        let sortByDate = UserDefaults.standard.integer(forKey: "sortByDate")
        let filterByStatus = UserDefaults.standard.integer(forKey: "filterByStatus")
        
    
        // Filter by status
        tasks = TaskDataFunctions.shared.retrieveTasks()
        if filterByStatus == 1 {
            tasks = tasks.filter { $0.status == "Pending" }
        } else if filterByStatus == 2 {
            tasks = tasks.filter { $0.status == "Complete" }
        }
        
        // Sort by date
        if sortByDate == 0 {
            tasks.sort { $0.dueDate < $1.dueDate }
        } else if sortByDate == 1 {
            tasks.sort { $0.dueDate > $1.dueDate }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! CustomTableViewCell
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task.title
        cell.dueDateLabel.text = task.strDate
        cell.statusLabel.text = task.status
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskDataFunctions.shared.deletingTasks(at: indexPath.row)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        let descriptionVC = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        descriptionVC.task = selectedTask
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
    // setting row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
 
}

