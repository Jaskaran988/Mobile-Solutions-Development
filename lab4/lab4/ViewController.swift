//
//  ViewController.swift
//  lab4
//
//  Created by user239680 on 5/30/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var textfield_firstname: UITextField!
  
    
    @IBOutlet weak var textfield_surname: UITextField!
    
    
    @IBOutlet weak var textfield_address: UITextField!
    
    
    
    @IBOutlet weak var textfield_city: UITextField!
    
    
    
    @IBOutlet weak var textfield_dob: UITextField!
    
    
    
    @IBOutlet weak var textview_output: UITextView!
    
    
    
    @IBAction func button_accept(_ sender: Any) {
        updateOutput()
    }
    
    
    @IBAction func button_decline(_ sender: Any) {
        clearAllFields()
        textview_output.text = "User has Declined"
    }
    
    @IBAction func button_reset(_ sender: Any) {
        clearAllFields()

    }

    @IBOutlet weak var label_message: UILabel!
    
      func isValidDOB(_ dob: String?) -> Bool {
          guard let dobText = dob else { return false }
          
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          
          guard let date = formatter.date(from: dobText) else { return false }
          
          let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
          
          return age > 18
      }
      
      func updateOutput() {
          guard let firstName = textfield_firstname.text, !firstName.isEmpty,
                let surname = textfield_surname.text, !surname.isEmpty,
                let address = textfield_address.text, !address.isEmpty,
                let city = textfield_city.text, !city.isEmpty,
                let dob = textfield_dob.text, !dob.isEmpty, isValidDOB(dob) else {
              textview_output.text = "Please fill in all fields and ensure the age is over 18."
              label_message.text = "Please fill in all fields and ensure the age is over 18."
              return
          }
          
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          let date = formatter.date(from: dob)!
          let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
          
          textview_output.text = """
          I, \(firstName) \(surname), currently living at \(address) in the city of \(city) do hereby accept the terms and conditions assignment.
          I am \(age) and therefore am able to accept the conditions of this assignment.
          """
          label_message.text = "Accepted successfully!"

      }
      
      func clearAllFields() {
          textfield_firstname.text = ""
          textfield_surname.text = ""
          textfield_address.text = ""
          textfield_city.text = ""
          textfield_dob.text = ""
          textview_output.text = ""
          label_message.text = ""

          
      }
    
    
    
    
}

