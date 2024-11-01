//
//  User.swift
//  ArtGallery
//
//  Created by Sumit on 23/7/2024.
//

import Foundation
import FirebaseFirestore

class User{
    var id: String!
    var firstname: String
    var lastname : String
    var email : String
    var bio: String
    var photo: String
    var followers: [User] = [User]()    // inititalizing the contacts array to be not null
    var following: [User] = [User]()     // inititalizing the contacts array to be not null
    var registered: Timestamp!
    var updatedAt: Timestamp!
    
    init(id: String!, firstname: String, lastname: String, email: String, bio: String, photo: String,  registered: Timestamp? = nil, updatedAt: Timestamp? = nil) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.bio = bio
        self.photo = photo
        self.registered = registered
        self.updatedAt = updatedAt
    }
    
    convenience init(id: String, dictionary: [String: Any]) {
        self.init(id: id,
                  firstname: dictionary["firstname"] as! String,
                  lastname: dictionary["lastname"] as! String,
                  email: dictionary["email"] as! String,
                  bio: dictionary["bio"] as! String,
                  photo: dictionary["photo"] as! String,
                  registered: dictionary["registered"] as? Timestamp,
                  updatedAt: dictionary["updatedAt"] as? Timestamp
        )
    }
}
