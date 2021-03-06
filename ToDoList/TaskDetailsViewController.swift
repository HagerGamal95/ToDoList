//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by hager on 1/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var selectedTask : Task!
    @IBOutlet weak var textFieldTaskDescription: UILabel!
    @IBOutlet weak var textFieldTaskName: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldTaskName.text = selectedTask.taskName
        textFieldTaskDescription.text = selectedTask.taskDescription
        taskImage.layer.cornerRadius = taskImage.frame.size.width/2
        taskImage.clipsToBounds = true
        ImageService.getImage(withURL: selectedTask.photoUrl) { image, url in
            guard let _task = self.selectedTask else { return }
            if _task.photoUrl.absoluteString == url.absoluteString {
                self.taskImage.image = image
            } else {
                print("Not the right image")
            }
            
        }
    }
    
}
