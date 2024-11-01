//
//  Comment.swift
//  ArtGallery
//
//  Created by Sumit on 2/8/2024.
//

import Foundation
import FirebaseFirestore

class Comment{
    var id: String!
    var commenterID: String
    var content: String
    var createdAt: Timestamp!
    
    init(commenterID: String, content: String, createdAt: Timestamp? = nil) {
        self.commenterID = commenterID
        self.content = content
        self.createdAt = createdAt
    }
    
    convenience init(id: String, dictionary: [String: Any]) {
        self.init(
            commenterID: dictionary["commenterID"] as! String,
            content: dictionary["content"] as! String
        )
        self.id = id
    }
}
