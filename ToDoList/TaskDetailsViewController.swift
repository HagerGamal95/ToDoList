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
        ImageService.getImage(withURL: selectedTask.photoUrl) { image, url in
            guard let _task = self.selectedTask else { return }
            if _task.photoUrl.absoluteString == url.absoluteString {
                self.taskImage.image = image
            } else {
                print("Not the right image")
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
