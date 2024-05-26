//
//  ViewController.swift
//  Lab3
//
//  Created by user239680 on 5/23/24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var textfield_firstname: UITextField!
    @IBOutlet weak var textfield_lastname: UITextField!
    @IBOutlet weak var textfield_country: UITextField!
    @IBOutlet weak var textfield_age: UITextField!
    @IBOutlet weak var textview_output: UITextView!
    @IBOutlet weak var label_submitted: UILabel!
    func update_inputs() {
        // updating inputs entered by thr user
           self.textview_output.text = "NAME= \(self.textfield_firstname.text ?? "") \(self.textfield_lastname.text ?? "") \nCOUNTRY= \(self.textfield_country.text ?? "") \nAGE= \(self.textfield_age.text ?? "")"
       }
    func clearall(){
        // to clear all textfieds
        textfield_firstname.text=""
        textfield_lastname.text=""
        textfield_country.text=""
        textfield_age.text=""
        textview_output.text=""
        label_submitted.text=""
    }
    @IBAction func button_add(_ sender: Any) {
        update_inputs()
    }
    @IBAction func button_submit(_ sender: Any) {
        if (textfield_firstname.text ?? "").isEmpty ||
              (textfield_lastname.text ?? "").isEmpty ||
              (textfield_country.text ?? "").isEmpty ||
              (textfield_age.text ?? "").isEmpty {
               
               // if the any of the textfield is empty
               label_submitted.text = "Please fill in all the fields!"
           } else {
               // submission sucessfull
               label_submitted.text = "Submission successful!"
           }    }
    @IBAction func button_clear(_ sender: Any) {
        clearall()
    }
}

