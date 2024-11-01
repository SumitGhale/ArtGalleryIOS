//
//  UpdatePostTVC.swift
//  ArtGallery
//
//  Created by Sumit on 4/8/2024.
//

import UIKit

class UpdatePostTVC: UITableViewController {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var post: Post!
    var postImage: UIImage?
    var service = Repository()
    var fileManagerHelper = ArtGalleryFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getting the document url
        guard let documentURL = fileManagerHelper.getDocumentdirectory() else{
            return
        }
        
        //  create a unique full file url
        let fileURL = documentURL.appendingPathComponent(post.imageURL)

        //  setting up the image path
        let imagePath = fileURL.path
        
        postImageView.image = UIImage(contentsOfFile: imagePath) ?? UIImage(systemName: "person.circle.fill")!
        titleTextField.text = post.title
        descriptionTextField.text = post.description
    }

    @IBAction func onClickUpdateButton(_ sender: Any) {
    }
    
    //  Delete post on click delete button
    @IBAction func onClickDeleteButton(_ sender: Any) {
        deleteComfirmationMessage(title: "Delete!!!",
                                     message: "Do you want to permanantly delete \(post.title)",
                                  delete:{
            if self.service.deletePost(withPostId: self.post.id){
                                        print("Post deleted")
                self.navigationController?.popViewController(animated: true)
                                    }
        },
                                     cancel: {
            
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //  update post on click update button
        if let profileTVC = segue.destination as? ProfileTVC{
            post.title = titleTextField.text!
            post.description = descriptionTextField.text!
            
            if service.updatePost(for: post.id, withData: post){
                print("post updated")
            }
        }
    }
    

}
