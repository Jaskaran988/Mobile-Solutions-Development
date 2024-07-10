//
//  MainViewController.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//
import QuartzCore
import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func addGradientBackground() {
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.98, green: 0.88, blue: 0.78, alpha: 1.00).cgColor, UIColor(red: 0.88, green: 0.98, blue: 0.94, alpha: 1.00).cgColor, UIColor(red: 0.92, green: 0.79, blue: 0.95, alpha: 1.00).cgColor
        ]
           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
           gradientLayer.endPoint = CGPoint(x: 1, y: 1)
           view.layer.insertSublayer(gradientLayer, at: 0)
       }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var displayImage: UIImageView!
    
    var datePicker: UIDatePicker!
    var selectedStatus: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create a Task"
        // title field border
        titleTextField.layer.borderColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        titleTextField.layer.borderWidth = 1.0
              
        // description field border
        descTextField.layer.borderColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        descTextField.layer.borderWidth = 1.0
             
        //datefield border
        dateTextField.layer.borderColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0).cgColor
        dateTextField.layer.borderWidth = 1.0
        
        // display image border
        displayImage.layer.borderWidth = 2.0
        displayImage.layer.borderColor = UIColor.blue.cgColor
        displayImage.layer.borderWidth = 2.0
        displayImage.layer.cornerRadius = 10.0
        displayImage.layer.masksToBounds = true
        //adding gradient function
        addGradientBackground()
        // Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        // setting datepicker toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        
    }
    
    @objc func doneDatePicker() {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    
    
    @IBAction func addImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addStatusButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select Status", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Complete", style: .default, handler: { _ in
            self.selectedStatus = "Complete"
        }))
        
        alert.addAction(UIAlertAction(title: "Pending", style: .default, handler: { _ in
            self.selectedStatus = "Pending"
        }))
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            displayImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTaskTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Title is required")
            return
        }
        
        guard let description = descTextField.text, !description.isEmpty else {
            showAlert(message: "Description is required")
            return
        }
        
        guard let dateText = dateTextField.text, !dateText.isEmpty else {
            showAlert(message: "Date is required")
            return
        }
        
        guard let status = selectedStatus, !status.isEmpty else {
            showAlert(message: "Status is required")
            return
        }
        
        guard let image = displayImage.image else {
            showAlert(message: "Image is required")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        let strDate = formatter.string(from: datePicker.date)
        
        let newTask = Task(title: title, description: description, dueDate: datePicker.date, strDate: strDate, status: status, image: image)
        TaskDataFunctions.shared.creatingTask(newTask)
        showAlert(message: "Task saved successfully!")
        titleTextField.text = ""
        descTextField.text = ""
        dateTextField.text = ""
        displayImage.image = nil

        if let navController = self.tabBarController?.viewControllers?.last as? UINavigationController {
            for obj in navController.viewControllers {
                if let nav = obj as? TasksTableViewController {
                    nav.isLoadDataCall = true
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

