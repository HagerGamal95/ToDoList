//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by hager on 1/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewTaskViewController: UIViewController , UITextViewDelegate{
    var imageBicker : UIImagePickerController!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textFieldTaskDescription: UITextView!
    @IBOutlet weak var textFieldTaskName: UITextField!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var saveTaskButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldTaskDescription.delegate = self
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        
        taskImage.isUserInteractionEnabled = true
        taskImage.addGestureRecognizer(imageTap)
        taskImage.layer.cornerRadius = taskImage.bounds.height / 2
        taskImage.clipsToBounds = true
        
        imageBicker = UIImagePickerController()
        imageBicker.allowsEditing = true
        imageBicker.sourceType = .photoLibrary
        imageBicker.delegate = self
    }
    
    @IBAction func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleSaveAction(_ sender: Any) {
        // 1. Upload the profile image to Firebase Storage
        
        if (!(textFieldTaskName.text!.isEmpty)  && (textFieldTaskDescription.text != "" )){
            saveTaskButton.isEnabled = false
            self.uploadProfileImage(taskImage.image!) { url in
                if url != nil {
                    self.saveTask(taskName: self.textFieldTaskName.text!, taskDes: self.textFieldTaskDescription.text, TaskImageURL: url!, completion: { (success) in
                        if success {
                            self.saveTaskButton.isEnabled = true
                            self.dismiss(animated: true, completion: nil)
                        }else
                        {
                            self.saveTaskButton.isEnabled = true
                            self.errorOccured(title: "Error", message: "you are offline")
                        }
                    })
                }
                else {
                    self.saveTaskButton.isEnabled = true
                }
            }
        }
        else
        {
            errorOccured(title: "Error", message: "somthing is missing please fill all inputs")
        }
        
    }
    func errorOccured(title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imageBicker, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textFieldTaskDescription.text.isEmpty
    }
    
}
extension NewTaskViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.taskImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveTask(taskName:String,taskDes: String ,TaskImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let postRef = Database.database().reference().child("tasks/\(uid)").childByAutoId()
        let postObject = [
            "id" : postRef.key! ,
            "taskName" : taskName ,
            "taskDescription" : taskDes ,
            "taskPhotoUrl" : TaskImageURL.absoluteString
            ] as [String:Any]
        postRef.setValue(postObject) { (error, ref) in
            completion(error == nil)
        }
        
    }
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)/\(textFieldTaskName.text!)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
                
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
}
