//
//  AddFriendsViewController.swift
//  Lab-6
//
//  Created by user239680 on 7/7/24.
//

import UIKit
protocol AddFriendDelegate: AnyObject {
    func didAddFriend(friend: [String: String])
}
class AddFriendsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    weak var delegate: AddFriendDelegate?
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func clearTextFields(_ sender: Any) {
        nameTextfield.text = ""
        phoneTextField.text = ""
        emailTextField.text = ""
    }
    
    @IBAction func addButton(_ sender: Any) {
        guard let name = nameTextfield.text, !name.isEmpty,
                    let phone = phoneTextField.text, !phone.isEmpty,
                    let email = emailTextField.text, !email.isEmpty else {
                  showAlert(title: "Warning!", message: "Fields cannot be empty")
                  return
              }
              
              let friend = ["name": name, "phone": phone, "email": email]
              delegate?.didAddFriend(friend: friend)
              showAlert(title: "Success", message: "Friend added successfully") {
                  self.navigationController?.popViewController(animated: true)
              }
    }
        private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
          let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
              completion?()
          })
          present(alertController, animated: true, completion: nil)
      }
}

