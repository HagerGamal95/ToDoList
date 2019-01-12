//
//  RegisterViewController.swift
//  ToDoList
//
//  Created by hager on 1/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var textFieldRegisterEmail: UITextField!
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldRegisterPassword: UITextField!
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        if !(textFieldRegisterEmail.text!.isEmpty)  && !(textFieldRegisterPassword.text!.isEmpty)
        {
        Auth.auth().createUser(withEmail: textFieldRegisterEmail.text!, password: textFieldRegisterPassword.text!) { (user, error) in
            if error == nil && user != nil {
                print("user created")
                let changeReqiest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeReqiest?.displayName = self.textFieldUserName.text
                changeReqiest?.commitChanges(completion: { (rror) in
                    if error == nil {
                        print("user display name changed")
                        guard let uid = Auth.auth().currentUser?.uid else{return}
                        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
                        let userObject = [
                            "userName" : self.textFieldUserName.text!,
                            "Email" : self.textFieldRegisterEmail.text!
                            ]as [String : Any]
                        databaseRef.setValue(userObject, withCompletionBlock: { (error, Ref) in
                            if error == nil {
//                    self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                })
                 }
            else
            {
                print(error!._code)
                self.handleError(error!)
            }
        }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "please write both email && password", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}
