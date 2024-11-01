//
//  SignupVC.swift
//  ArtGallery
//
//  Created by Sumit on 13/7/2024.
//

import UIKit
import FirebaseAuth

class SignupVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    var service = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //  Implementing sign up on press
    @IBAction func signupDidPress(_ sender: Any) {
        guard !emailTextField.text.isBlank else{
            // display message to the user
            showAlertMessage(title: "Validation", message: "Email is mandotary")
            return
        }
        
        guard !passwordTextField.text.isBlank else{
            // display message to the user
            showAlertMessage(title: "Validation", message: "Password is mandotary")
            return
        }
        
        guard !confirmPasswordTextField.text.isBlank else{
            // display message to the user
            showAlertMessage(title: "Validation", message: "Re-entering password is mandotary")
            return
        }
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              let firstName = firstNameTextField.text,
              let bio = bioTextField.text,
              password == confirmPassword else{
            self.showAlertMessage(title: "Validation", message: "Password and confirm password do not match")
            return
        }
        
        // create a closure to be implemented when ok is pressed
        let registerUserClosure: () -> Void = {
            // register user in the firestore
            let userAuthId = Auth.auth().currentUser?.uid
            let user = User(id: userAuthId, firstname: firstName, lastname: "lastName", email: email, bio: bio, photo: "")
            
            // create user in the database
            if self.service.addUser(user:  user){
                print("email: \(user.email)")
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        //  User firebase auth
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            guard error == nil else{
                self.showAlertMessage(title: "Failed to create account", message: "\(error?.localizedDescription) error123")
                return
            }
            
            //send email for confirmation
            Auth.auth().currentUser?.sendEmailVerification{error in
                if let error = error{
                    self.showAlertMessage(title: "Error", message: "\(error.localizedDescription)")
                }
                //  use alert with the handle
                self.showAlertMessageWithHandle(title: "Email verification", message: "A verification email has been sent to your email", onComplete:registerUserClosure)
            }
    }
    }
}
