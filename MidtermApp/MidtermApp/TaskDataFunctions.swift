//
//  TaskDataFunctions.swift
//  MidtermApp
//
//  Created by user239680 on 7/9/24.
//
// This is a singelton class where all globally accesible functions are there
import Foundation

class TaskDataFunctions {
    static let shared = TaskDataFunctions()
    
    private var tasks: [Task] = [] {
        didSet {
            setTasks()
        }
    }
    
    private init() {
        showingTasks()
    }
    
    func creatingTask(_ task: Task) {
        tasks.append(task)
    }
    
    func retrieveTasks() -> [Task] {
        return tasks
    }
    
    func deletingTasks(at index: Int) {
        tasks.remove(at: index)
        setTasks()
    }
    
    func setTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func showingTasks() {
        if let savedTasks = UserDefaults.standard.object(forKey: "tasks") as? Data {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }
    }
}

