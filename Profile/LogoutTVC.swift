//
//  LogoutTVC.swift
//  ArtGallery
//
//  Created by Sumit on 14/8/2024.
//

import UIKit
import FirebaseAuth

class LogoutTVC: UITableViewController {
    var user: User!
    var service = Repository()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  filling the text fields
        firstNameTextField.text = user.firstname
        lastNameTextField.text = user.lastname
        bioTextField.text = user.bio
        
    }

    @IBAction func onPressLogOut(_ sender: Any) {
        
        //  signing out the user and returning to the login screen
        do{
            try Auth.auth().signOut()
            print("Successfully signed out")
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:  "LoginViewController") as? UINavigationController
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
            
        }catch let signOutError as NSError{
            showAlertMessage(title: "Something went wrong", message: "Error while signing out \(signOutError.localizedDescription)")
        }
    }
    
    //  Update user info on click update button
    @IBAction func onPressUpdateButton(_ sender: Any) {
        user.firstname = firstNameTextField.text!
        user.lastname = lastNameTextField.text!
        user.bio = bioTextField.text!
        
        if service.updateUserData(withData: user){
            showAlertMessage(title: "Success", message: " Update Successfull. Please restart to see changes ")
        }else{
            showAlertMessage(title: "Failed", message: " Update unsuccesfull.")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
