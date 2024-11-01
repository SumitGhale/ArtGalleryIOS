//
//  SearchViewController.swift
//  ArtGallery
//
//  Created by Sumit on 27/7/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    var service = Repository()
    var posts = [Post]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // getting all posts
        service.getPostsFromFriends(fromCollection: "posts"){(returnedCollection) in
            self.posts = returnedCollection
        
            self.collectionView.reloadData()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    //  implementing on click search icon
    @IBAction func onClickSearchButton(_ sender: Any) {
        guard !searchTextField.text.isBlank else{
            showAlertMessage(title: "Empty textbox", message: "Search box cannot be empty...")
            return
        }
        
        //  display the results from searched data
        service.getSearchedPosts(searchTag: searchTextField.text!, fromCollection: "posts"){(returnedCollection) in
            self.posts = returnedCollection
            self.collectionView.reloadData()
        }
    }
}

//  to display the array in the collection view
extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            searchImageCell.setup(post: posts[indexPath.row])
            return searchImageCell
        }
}

// to configure sizes in different devices
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
}

// onclick cell
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: implement on click cell
        print("art selected: \(posts[indexPath.row].title)")
    }
}
