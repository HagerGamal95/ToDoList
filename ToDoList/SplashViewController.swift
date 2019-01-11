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
    
    var timer: Timer?
    
    var authFinished = false
    var timeFinished = false
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: false)
        
        authenticationUser()
    }
    
    func authenticationUser() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                UserService.observeUserProfile(user!.uid, completion: { (user) in
                    UserService.currentUserProfile = user
                    self.authFinished = true
                    self.checkTasks()
                })
            } else {
                self.authFinished = true
                self.checkTasks()
            }
        }
    }
    
    @objc func timeElapsed() {
        timeFinished = true
        self.checkTasks()
    }
    
    func checkTasks(){
        if authFinished && timeFinished {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controllerIdentifier = UserService.currentUserProfile != nil ? "MainNavigationController" : "loginNavigationController"
            let controller = storyBoard.instantiateViewController(withIdentifier: controllerIdentifier)
            UIApplication.shared.delegate?.window??.rootViewController = controller
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        }
    }
    
}
