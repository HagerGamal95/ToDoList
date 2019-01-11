//
//  User.swift
//  ToDoList
//
//  Created by hager on 1/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
class User
{
    var uid : String
    var name : String
    var email : String
    
    init(uid : String , name : String , email : String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
}
