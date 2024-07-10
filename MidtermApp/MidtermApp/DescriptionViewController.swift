//
//  DescriptionViewController.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//

import UIKit
import QuartzCore
class DescriptionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    
    var task: Task? 
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
    override func viewDidLoad() {
        taskImageView.layer.borderWidth = 2.0
        taskImageView.layer.borderColor = UIColor.blue.cgColor
        
        // Optionally, you can also round the corners
        taskImageView.layer.cornerRadius = 10.0
        taskImageView.layer.masksToBounds = true
        super.viewDidLoad()
        addGradientBackground()
        
        if let task = task {
                   titleLabel.text = task.title
                   descriptionLabel.text = task.description
                   let formatter = DateFormatter()
                   formatter.dateStyle = .medium
                   dueDateLabel.text = formatter.string(from: task.dueDate)
                   statusLabel.text = task.status
                   if let imageData = task.imageData {
                       taskImageView.image = UIImage(data: imageData)
                   } else {
                       taskImageView.image = nil 
                   }
               }
    }
}

