//
//  ProfileCollectionViewCell.swift
//  ArtGallery
//
//  Created by Sumit on 27/7/2024.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userPostImageView: UIImageView!
    var fileManagerHelper = ArtGalleryFileManager()
    
    //  setup for posts in profile collection view
    func setup(post: Post){
        //  getting document path
        guard let documentURL = fileManagerHelper.getDocumentdirectory() else{
            return
        }
        //  create a unique full file url
        let fileURL = documentURL.appendingPathComponent(post.imageURL)

        //  setting up the image path
        let imagePath = fileURL.path
        
        if !post.imageURL.isEmpty && UIImage(contentsOfFile: imagePath) != nil{
            userPostImageView.image = UIImage(contentsOfFile: imagePath)
        }else{
            userPostImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
}
