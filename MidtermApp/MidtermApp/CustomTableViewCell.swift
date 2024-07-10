//
//  CustomTableViewCell.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func layoutSubviews() {
            super.layoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor(red: 0.98, green: 0.88, blue: 0.78, alpha: 1.00).cgColor,
            UIColor(red: 0.88, green: 0.98, blue: 0.94, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
            let backgroundView = UIView(frame: contentView.bounds)
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            contentView.backgroundColor = .clear
            contentView.addSubview(backgroundView)
            contentView.sendSubviewToBack(backgroundView)
        }
    override func awakeFromNib() {
           super.awakeFromNib()
           
       }
       
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
    
       }

}
