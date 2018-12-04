//
//  File.swift
//  EventMe
//
//  Created by Radiance Okuzor on 10/20/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import Foundation
import UIKit

class User {
    var firstName: String!
    var lastName: String!
    var email: String!
    var phoneNumber: Int!
    var uid: String!
    var password: String!
    var profilePic: String!
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}
