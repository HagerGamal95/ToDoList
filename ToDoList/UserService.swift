//
//  UserService.swift
//  ToDoList
//
//  Created by hager on 1/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static var currentUserProfile : User?
    static func observeUserProfile(_ uid:String , completion: @escaping ((_ userProfile:User?)->())){
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        userRef.observe(.value, with: { snapshot in
            print(snapshot)
            var user : User?
            if let dict = snapshot.value as? [String : Any],
                let userName = dict["userName"] as? String ,
                let email = dict["Email"] as? String
            {
                user = User(uid: snapshot.key, name: userName, email: email)
                
            }
            completion(user)
        })
    }
}
