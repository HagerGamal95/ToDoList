//
//  SplashViewController.swift
//  ToDoList
//
//  Created by hager on 1/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SplashViewController: UIViewController {
    
    var dispatchGroup: DispatchGroup?
    
    var timer: Timer?
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchGroup = DispatchGroup()
        
        dispatchGroup?.enter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: false)
        
        dispatchGroup?.enter()
        authenticationUser { (user) in
            UserService.currentUserProfile = user
            if let dispatchGroup = self.dispatchGroup {
                dispatchGroup.leave()
            } else {
                self.navigateToApp()
            }
        }
        
        dispatchGroup?.notify(queue: .main) {
            self.navigateToApp()
            self.dispatchGroup = nil
        }
    }
    
    func authenticationUser(authCompletion: @escaping (User?) -> ()) {
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                UserService.observeUserProfile(user!.uid, completion: { (user) in
                    authCompletion(user)
                })
            } else {
                authCompletion(nil)
            }
            
            // Auth.auth().removeStateDidChangeListener(self.authListener!)
        }
    }
    
    @objc func timeElapsed() {
        dispatchGroup?.leave()
    }
    
    func navigateToApp(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controllerIdentifier = UserService.currentUserProfile != nil ? "MainNavigationController" : "loginNavigationController"
        let controller = storyBoard.instantiateViewController(withIdentifier: controllerIdentifier)
        UIApplication.shared.delegate?.window??.rootViewController = controller
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        
        self.dispatchGroup = nil
    }
    
}
