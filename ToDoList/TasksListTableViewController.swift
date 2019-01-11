//
//  TasksListTableViewController.swift
//  ToDoList
//
//  Created by hager on 1/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class TasksListTableViewController: UITableViewController {

    @IBOutlet weak var textFieldWelcomeUser: UILabel!
    let listToUsers = "ListToTasks"
    var ref: DatabaseReference!
    var currentUser : User?
    var userCountBarButtonItem: UIBarButtonItem!
    var tasks = [Task]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "🏃🏻‍♂️",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(logOutDidTouch))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        tableView.tableFooterView = UIView()
        if let name = UserService.currentUserProfile?.name {
            self.textFieldWelcomeUser.text = "welcome \(name)"
        }
        tableView.reloadData()
        observePosts()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func observePosts()
    {
        let uid = Auth.auth().currentUser?.uid
        let TaskRef = Database.database().reference().child("tasks/\(uid!)")
        TaskRef.observe(.value) { (snapshot) in
            var tempTasks = [Task]()
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let taskId = dict["id"] as? String,
                let taskName = dict["taskName"] as? String,
                let taskDes = dict["taskDescription"] as? String ,
                let photoURL = dict["taskPhotoUrl"] as? String,
                let url = URL(string:photoURL){
                    let task = Task(id: taskId, taskName: taskName, taskDescription: taskDes, photoUrl: url)
                    tempTasks.append(task)
                }
            }
            self.tasks = tempTasks
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return tasks.count
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.taskName
        cell.detailTextLabel?.text = task.taskDescription
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            let uid = Auth.auth().currentUser?.uid
            let taskRef = Database.database().reference().child("tasks/\(uid!)/\(task.id)")
            taskRef.removeValue()
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToTaskDetails", sender: tasks[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTaskDetails"
        {
            if let selectedTask = sender as? Task , let destinationViewController = segue.destination as? TaskDetailsViewController {
                destinationViewController.selectedTask = selectedTask
            }
        }
    }
    @IBAction func addButtonDidTouch(_ sender: Any) {
        }
        
    @objc func logOutDidTouch() {
        do{
          try Auth.auth().signOut()
        }
        catch
        {
            print("can not sigh out")
        }
    }
  
}
