//
//  FriendsTableViewCell.swift
//  Lab-6
//
//  Created by user239680 on 7/8/24.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var friendNameLabel: UILabel!
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var cityImage: UIImageView!
    
    
    @IBOutlet weak var sportImage: UIImageView!
    
    
    @IBOutlet weak var foodImage: UIImageView!
    


      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
      }

}
