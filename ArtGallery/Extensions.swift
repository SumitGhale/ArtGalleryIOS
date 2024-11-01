//
//  Extensions.swift
//  ArtGallery
//
//  Created by Sumit on 13/7/2024.
//

import Foundation
import UIKit

extension Optional where Wrapped == String{
    var isBlank: Bool{
        guard let notNilBool = self else{
            return true
        }
        return notNilBool.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension UIViewController{
    //  alert message with title and message
    func showAlertMessage(title: String, message: String){
        // creating instance of UI alert controller with given title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    //  alert message with title, message and handle
    func showAlertMessageWithHandle(title: String, message: String, onComplete:(()-> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let onCompleteAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default){action in
            onComplete?()
        }
        alert.addAction(onCompleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    //  Alert with delete and message
    func deleteComfirmationMessage(title: String, message: String, delete: (()-> Void)?, cancel: (()-> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let onDeleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive){ action in
            delete?()
        }
        let onCancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel){ action in
            cancel?()
        }
        
        alert.addAction(onDeleteAction)
        alert.addAction(onCancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
