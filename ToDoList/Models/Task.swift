//
//  Task.swift
//  ToDoList
//
//  Created by hager on 1/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
class Task{
    var id : String
    var taskName : String
    var taskDescription : String
    var photoUrl : URL
//    var createdAt : Double
    
    init(id: String , taskName : String , taskDescription : String , photoUrl : URL )
    {
        self.id = id
        self.taskName = taskName
        self.taskDescription = taskDescription
//        self.createdAt = Date(timeIntervalSince1970: timeStamp/1000)
        self.photoUrl = photoUrl
    }
}
