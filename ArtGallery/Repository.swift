//
//  Repository.swift
//  ArtGallery
//
//  Created by Sumit on 24/7/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class Repository{
    
    var db = Firestore.firestore()
    
    //  find posts for user
    
    func getPostsFromFriends(fromCollection name: String, completion: @escaping(([Post]) ->())){
        var posts = [Post]()
        
        db.collection(name)
            .addSnapshotListener{snapshot, error in
                if let documents = snapshot?.documents{
                    posts = documents.compactMap({doc -> Post? in
                        let data = doc.data()
                        return Post(id: doc.documentID, dictionary: data)
                    })
                    // loop is done pass on Completion
                    completion(posts)
                }else{
                    print("Error fetching documents \(error)")
                    return
                }
                
            }
    }
    
    //  get searched posts using search tags
    
    func getSearchedPosts(searchTag search: String, fromCollection name: String, completion: @escaping(([Post]) ->())){
        var posts = [Post]()
        
        //  call database run query and get the array of posts
        db.collection(name)
            .whereField("tags", arrayContains: search)
            .addSnapshotListener{snapshot, error in
                if let documents = snapshot?.documents{
                    posts = documents.compactMap({doc -> Post? in
                        let data = doc.data()
                        return Post(id: doc.documentID, dictionary: data)
                    })
                    completion(posts)
                }else{
                    print( "error fetching data \(error)")
                    return
                }
            }
        
    }
    
    //  get your posts
    
    func getYourPosts(fromCollection name: String, completion: @escaping(([Post]) ->())){
        var posts = [Post]()
        
        db.collection(name)
            .whereField("artistID", isEqualTo: Auth.auth().currentUser?.uid)
            .addSnapshotListener{snapshot, error in
                if let documents = snapshot?.documents{
                    posts = documents.compactMap({doc -> Post? in
                        let data = doc.data()
                        return Post(id: doc.documentID, dictionary: data)
                    })
                    // loop is done pass on completion
                    completion(posts)
                }else{
                    print("Error fetching documents \(error)")
                    return
                }
            }
    }
    
    //add post to the database
    
    func addPost(post: Post) -> Bool{
        var result = true
        var dictionary: [String: Any] = [
            "title": post.title ,
            "description": post.description,
            "imageURL": post.imageURL,
            "artistID": post.artistID,
            "tags": post.tags,
            "createdAt": post.createdAt ?? FieldValue.serverTimestamp(),
            "updatedAt": post.updatedAt ?? FieldValue.serverTimestamp()
        ]
        db.collection("posts").addDocument(data: dictionary){ error in
            if let err = error{
                print("post could not be added \(post.title), error \(err)")
                result = false
            }
        }
        return result
    }
    
    //  update post
    
    func updatePost(for postId: String, withData post: Post) -> Bool{
        var result = true
        
        var dictionary: [String: Any] = [
            "title": post.title ,
            "description": post.description
        ]
        
        db.collection("posts").document(postId).updateData(dictionary){error in
            if let err = error{
                print("error updating post \(err.localizedDescription)")
                result = false
            }else{
                print("post updated")
            }
        }
        return result
    }
    
    //  delete post
    
    func deletePost(withPostId postId: String) -> Bool{
        var result = true
        db.collection("posts").document(postId).delete() {error in
            if let err = error{
                print("Deletion failed \(err.localizedDescription)")
                result = false
            }else{
                print("post deleted")
            }
        }
        return result
    }
    
    // Add comment to a post
    
    func addComment(comment: Comment, postId: String) -> Bool{
        var result = true
        var dictionary: [String: Any] = [
            "commenterID": comment.commenterID,
            "content": comment.content,
            "createdAt": comment.createdAt ?? FieldValue.serverTimestamp()
        ]
        
        db.collection("posts").document(postId).collection("comments").addDocument(data: dictionary){error in
            if let err = error{
                print("Comment could not be added., error \(err)")
                result = false
            }
        }
        return result
    }
    
    //  get comment from the post
    
    func getComment(fromCollection name: String, fromPost postId: String, completion: @escaping(([Comment]) -> ())){
        //  array to store returned comments
        var comments = [Comment]()
        
        db.collection("posts").document(postId).collection(name)
            .addSnapshotListener{snapshot, error in
                if let documents = snapshot?.documents{
                    comments = documents.compactMap({doc -> Comment? in
                        let commentData = doc.data()
                        return Comment(id: doc.documentID, dictionary: commentData)})
                    // loop completed pass on completion
                    completion(comments)
                }else{
                    print("Error fetching documents \(error)")
                    return
                }
            }
    }
    
    //  Add user to the database
    
    func addUser(user: User) -> Bool{
        var result = true
        var dictionary: [String: Any] = [
            "firstname": user.firstname,
            "lastname" : user.lastname,
            "email" : user.email,
            "bio" : user.bio,
            "photo" : user.photo,
            "registered": user.registered ?? FieldValue.serverTimestamp(),
            "updatedAt": user.registered ?? FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(user.id).setData(dictionary){ error in
            if let err = error{
                print("user could not be added \(user.email), error \(err)")
                result = false
            }
        }
        return result
    }
    
    // Get user data
    
    func getUserInfo(userID artistId: String, completion: @escaping((User?) -> ())){
        // user to store user details
        var userInfo: User
        let docRef = db.collection("posts").document(artistId)
        
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument{snapshot, error in
            if let err = error{
                completion(nil)
                return
            }
            guard let snapshot = snapshot, let data = snapshot.data() else {
                completion(nil)
                return
            }
            
            let userInfo = User(id: snapshot.documentID, dictionary: data)
            completion(userInfo)
        }
    }
    
    //  update user data
    
    //  update post
    
    func updateUserData(withData user: User) -> Bool{
        var result = true
        
        var dictionary: [String: Any] = [
            "firstname": user.firstname ,
            "lastname": user.lastname,
            "bio": user.bio
        ]
        
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(dictionary){error in
            if let err = error{
                print("error updating user \(err.localizedDescription)")
                result = false
            }else{
                print("User updated")
            }
        }
        return result
    }
    
    
}
