//
//  CommentTVC.swift
//  ArtGallery
//
//  Created by Sumit on 2/8/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommentTVC: UITableViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    let service = Repository()
    var comments = [Comment]()
    @IBOutlet var commentTableView: UITableView!
    var recievedPost: Post!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  getting comments from that specific selected post
        service.getComment(fromCollection: "comments", fromPost: recievedPost.id){
            (returnedCollection) in
            self.comments = returnedCollection
            self.commentTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    //  Adding post
    @IBAction func onPressAddCommentButton(_ sender: Any) {
        guard !commentTextField.text.isBlank else{
            // display message to the user
            showAlertMessage(title: "empty textbox", message: "Comment cannot be empty")
            return
        }
        
        guard let commentText = commentTextField.text else { return }
        guard let userAuthId = Auth.auth().currentUser?.uid else { return }
        
        let comment = Comment(commenterID: userAuthId, content: commentText)
        if service.addComment(comment: comment, postId: recievedPost.id){
            self.commentTableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath) as! CommentUITVC
        
        // configure the cell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = comment.content
        cell.commenterImageView.image = UIImage(systemName: "person.circle.fill")
        
        return cell
    }
    
}
