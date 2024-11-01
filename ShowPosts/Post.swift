//
//  Post.swift
//  ArtGallery
//
//  Created by Sumit on 25/7/2024.
//

import Foundation
import FirebaseFirestore

class Post{
    var id: String!
    var title: String
    var description: String
    var imageURL: String
    var tags: [String]
    var artistID: String
    var likes: [User] = [User]()
    var createdAt: Timestamp!
    var updatedAt: Timestamp!
    
    init(title: String, description: String, imageURL: String, tags: [String], artistID: String, createdAt: Timestamp? = nil, updatedAt: Timestamp? = nil) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.artistID = artistID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
    }
    
    convenience init(id: String, dictionary: [String: Any]){
        self.init(
                   title: dictionary["title"] as! String,
                   description: dictionary["description"] as! String,
                   imageURL: dictionary["imageURL"] as! String,
                   tags: dictionary["tags"] as? [String] ?? [],
                   artistID: dictionary["artistID"] as! String,
                   createdAt: dictionary["createdAt"] as? Timestamp,
                   updatedAt: dictionary["updatedAt"] as? Timestamp)
        self.id = id
    }
}
