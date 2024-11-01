//
//  ShowPostsTVC.swift
//  ArtGallery
//
//  Created by Sumit on 22/7/2024.
//

import UIKit
import FirebaseAuth

class ShowPostsTVC: UITableViewController {
    
    var selectedPost: Post!
    var service = Repository()
    var posts = [Post]()
    @IBOutlet var ShowPostsTableView: UITableView!
    var fileManagerHelper = ArtGalleryFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userAuthId = Auth.auth().currentUser?.uid
        
        //  getting posts from database (all posts for now)
        service.getPostsFromFriends(fromCollection: "posts"){(returnedCollection) in
            self.posts = returnedCollection
            
            // reoad the table view
            self.ShowPostsTableView.reloadData()
        }
        
    }
    
    //  moving to comment page on press comment button
    @objc func onTapComment(_ sender: UIButton) {
        let selectedIndex = IndexPath(row: sender.tag, section: 0)
        selectedPost = posts[selectedIndex.row]
        if let CommentTVC = storyboard?.instantiateViewController(withIdentifier: "CommentTVC") as? CommentTVC{
            CommentTVC.recievedPost = selectedPost
            self.navigationController?.pushViewController(CommentTVC, animated: true)
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PostUITVC
        
        // Configure the cell...
        let post = posts[indexPath.row]
        
        service.getUserInfo(userID: post.artistID){returnedUser in
            cell.userNameLabel.text = returnedUser?.firstname
        }
        
        cell.shortDescriptionLabel.text = post.description
        
        cell.commentButton.tag = indexPath.row  // adding tag to the button in order to pass the position of the post
        cell.commentButton.addTarget(self, action: #selector(onTapComment(_:)), for: .touchUpInside)
        
        guard let documentURL = fileManagerHelper.getDocumentdirectory() else{
            return cell
        }
        
        let fileURL = documentURL.appendingPathComponent(post.imageURL)

        let imagePath = fileURL.path
        
        
        if !post.imageURL.isEmpty && UIImage(contentsOfFile: imagePath) != nil{
            cell.postImageView.image = UIImage(contentsOfFile: imagePath)
        }else{
            cell.postImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedPost = posts[indexPath.row]
        return indexPath
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let commentTvc = segue.destination as? CommentTVC{
            commentTvc.recievedPost = selectedPost
        }
    }

}
