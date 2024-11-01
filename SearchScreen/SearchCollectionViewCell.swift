//
//  SearchCollectionViewCell.swift
//  ArtGallery
//
//  Created by Sumit on 27/7/2024.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artLabel: UILabel!
    @IBOutlet weak var artImageView: UIImageView!
    
    var fileManagerHelper = ArtGalleryFileManager()

    //  Configuring the post
    func setup(post: Post){
        guard let documentURL = fileManagerHelper.getDocumentdirectory() else{
            return
        }
        
        let fileURL = documentURL.appendingPathComponent(post.imageURL)

        let imagePath = fileURL.path
        
        if !post.imageURL.isEmpty && UIImage(contentsOfFile: imagePath) != nil{
            artImageView.image = UIImage(contentsOfFile: imagePath)
        }else{
            artImageView.image = UIImage(systemName: "person.circle.fill")
        }
        artLabel.text = post.title
    }
}
