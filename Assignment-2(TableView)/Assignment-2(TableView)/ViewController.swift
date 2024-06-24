//
//  ViewController.swift
//  Assignment-2(TableView)
//
//  Created by user239680 on 6/23/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func monitorButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Error", message: "No Monitors Yet.Check back Later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

