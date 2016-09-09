//
//  UsernameVC.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/8/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseDatabase

class UsernameVC: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: FancyField!
    
    var usernameRef: FIRDatabaseReference!
    
    private var _user: User!
    var user: User {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        
        if usernameTextField.text != "" {
            
            usernameRef = DataService.ds.REF_USERS
            usernameRef.queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.value is NSNull {
                    print("JEDI: Username is available")
                    if let username = self.usernameTextField.text {
                        let usernameDict = ["username":username]
                        self.completeSignIn(uid: self.user.uid, userData: self.user.userData, username: usernameDict)
                    }
                } else {
                    print("JEDI: Username is already taken")
                    self.errorLabel.text = "This username is already taken"
                }
            })
        } else {
            errorLabel.text = "Please enter username!"
        }
    }
    
    // MARK: - Functions
    
    func completeSignIn(uid: String, userData: Dictionary<String, String>, username: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: uid, userData: userData, username: username)
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_USERNAME) {
            print("JEDI: Username key already set.")
        } else {
            let _ = KeychainWrapper.defaultKeychainWrapper().setString(usernameTextField.text!, forKey: KEY_USERNAME)
        }
        self.dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: "goToFeed", sender: nil)
        })
        //performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}
