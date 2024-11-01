//
//  AddPostTVC.swift
//  ArtGallery
//
//  Created by Sumit on 27/7/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddPostTVC: UITableViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    var service = Repository()  // Firebase(Database) service
    var fileManagerHelper = ArtGalleryFileManager() // Filemanager service
    
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Save the image to device storage
    func saveImageToDocumentsDirectory(image: UIImage) -> String? {
            //  get document path
            guard let documentURL = fileManagerHelper.getDocumentdirectory() else{
            return nil
        }
        
        //  generate a unique file name for the image
        let fileName = UUID().uuidString + ".jpg"
        
        //  create a unique full file url
        let fileURL = documentURL.appendingPathComponent(fileName)
        
        //  converts the UIImage to a jpeg data
        if let data = image.jpegData(compressionQuality: 1){
            do{
                //  writes the jpeg data to the specified url
                try data.write(to: fileURL)
                
                return fileName
            }catch{
                showAlertMessage(title: "Error", message: "Error saving image.")
            }
        }
        //  return nil if any step fails
        return nil
    }
    
    @IBAction func onClickUploadIcon(_ sender: Any) {
        let alert = UIAlertController(title: "Media Options", message: "Please select a media option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
            //  open camera if camera selected
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {action in
            //  open photolibrary / photos
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //  upload post to the database
    @IBAction func onUploadButtonClick(_ sender: Any) {
        guard !titleTextField.text.isBlank else {
            showAlertMessage(title: "Required", message: "Title cannot be empty")
            return
        }
        
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let tags = tagsTextField.text?.components(separatedBy: " ") else { return }
        
        guard let userAuthId = Auth.auth().currentUser?.uid else { return }
        let post = Post(title: title, description: description, imageURL: imagePath ?? "",tags: tags, artistID: userAuthId)
        if service.addPost(post:post){
            print("\(post.title) added to db")
            showAlertMessageWithHandle(title: "Upload", message: "Upload Successfull"){
                if let tabBarController = self.tabBarController{
                    tabBarController.selectedIndex = 0
                }
            }

        }else{
            showAlertMessage(title: "Upload", message: "Upload unsuccessfull !!!")
        }
    }
    
}

extension AddPostTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //  return image path to store in the database
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            //  save the image to device
            if let imagePath = saveImageToDocumentsDirectory(image: image){
                self.imagePath = imagePath
            }
                
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
