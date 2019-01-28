//
//  ViewController.swift
//  ToDoList
//
//  Created by hager on 1/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var btnChangeLanguage: UIButton!
    @IBOutlet weak var lblCurrentLanguage: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        lblHeader.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "header_text", comment: "")
        lblCurrentLanguage.text = LocalizationSystem.sharedInstance.getLanguage()
        btnChangeLanguage.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "change_language", comment: ""), for: .normal)

        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func changeLanguage(_ sender: Any) {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"
        {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else
        {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
        let appdlg = UIApplication.shared.delegate as? AppDelegate
        appdlg?.window?.rootViewController = vc
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

