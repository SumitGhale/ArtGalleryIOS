//
//  LoginVC.swift
//  ArtGallery
//
//  Created by Sumit on 13/7/2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LoginVC: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var service = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create Google Sign In configuration object.
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            fatalError("No client id found in the fire base configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    
    }
    
    
    @IBAction func forgottenPasswordDidPress(_ sender: Any) {
    }
    
    //  On press login button
    
    @IBAction func loginDidPress(_ sender: Any) {
        
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
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password){[weak self] authResult, error in
            guard error == nil else{
                self?.showAlertMessage(title: "Failed to login", message: "\(error!.localizedDescription)")
                return
            }
            guard let authUser = Auth.auth().currentUser, authUser.isEmailVerified else{
                self?.showAlertMessage(title: "Pending email verification", message: "We have sent you verification email. Please follow the instructions.")
                return
            }
            // Login successfull move to home screen
            let homeViewController = self?.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController
            self?.view.window?.rootViewController = homeViewController
            self?.view.window?.makeKeyAndVisible()
        }
        
    }
    
    //  Implementing sign in with google
    
    @IBAction func loginWithGoogleDidPress(_ sender: Any) {
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self){ [unowned self] result, error in
            guard error == nil else {
                self.showAlertMessage(title: "Failed to login", message: "\(error?.localizedDescription)")
                return
            }

            guard let googleUser = result?.user,
              let idToken = googleUser.idToken?.tokenString
            else {
                self.showAlertMessage(title: "Failed to login", message: "Failed to get user or Id token.")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: googleUser.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    self.showAlertMessage(title: "Failed To Login", message: "\(error.localizedDescription)")
                    
                }
                
              // At this point, our user is signed in so move to home screen
                let googleLoginUser = User(id: Auth.auth().currentUser?.uid, firstname: (googleUser.profile?.givenName)!, lastname: (googleUser.profile?.familyName)!, email: googleUser.profile!.email, bio: "", photo: "")
                
                if self.service.addUser(user: googleLoginUser){
                    print("email: \(googleLoginUser.email)")
                }
                
                //  Move to feed / Home
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
            }
            
          }
    }
    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToLoginVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }*/

}
