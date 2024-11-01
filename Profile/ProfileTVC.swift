//
//  ProfileTVC.swift
//  ArtGallery
//
//  Created by Sumit on 27/7/2024.
//

import UIKit
import FirebaseAuth

class ProfileTVC: UITableViewController {

    var userForLogOut: User!
    var service = Repository()
    var posts = [Post]()

    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //  getting user information from database
        service.getUserInfo(userID: Auth.auth().currentUser!.uid){returnedUser in
            self.userForLogOut = returnedUser
            self.usernameLabel.text = returnedUser!.firstname + " " + returnedUser!.lastname
            self.bioLabel.text = returnedUser?.bio
        }
        // Do any additional setup after loading the view.
        service.getYourPosts(fromCollection: "posts"){(returnedCollection) in
            self.posts = returnedCollection
            print("total: \(self.posts.count)")
        
            self.profileCollectionView.reloadData()
        }
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    @IBAction func unwindToProfileTvc(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let logoutTvc = segue.destination as? LogoutTVC{
            logoutTvc.user = userForLogOut
        }
    }
}

//  to display the array in the collection view
extension ProfileTVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profilePostsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        profilePostsCell.setup(post: posts[indexPath.row])
        return profilePostsCell
    }
}

//  configuring the size of cell
extension ProfileTVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

//  On click cell
extension ProfileTVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let updateViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePostTVC") as! UpdatePostTVC
        
        updateViewController.post = posts[indexPath.row]
        
        self.navigationController?.pushViewController(updateViewController, animated: true)
    }
}

