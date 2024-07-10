//
//  Model.swift
//  MidtermApp
//
//  Created by user239680 on 7/9/24.
//

import Foundation
import UIKit

class Task: Codable {
    var dueDate: Date
    var strDate: String
    var status: String
    var imageData: Data?
    var title: String
    var description: String
   

    init(title: String, description: String, dueDate: Date, strDate: String, status: String, image: UIImage?) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.status = status
        self.strDate = strDate
        self.imageData = image?.jpegData(compressionQuality: 1.0)
    }
}

