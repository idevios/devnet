//
//  ViewController.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 8/25/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var emailTextField: FancyField!
    @IBOutlet weak var passwordTextField: FancyField!
    
    // MARK: - @Properties
    
    // MARK: - View Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - @IBActions

    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JEDI: Unable to authentication with Facebook: \(error.debugDescription)")
            } else if result?.isCancelled == true {
                print("JEDI: User cancel Facebook authentication. ")
            } else {
                // IF FACEBOOK AUTH SUCCESS WE WILL BE HERE
                print("JEDI: Success fully authentication with Facebook. ")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // MARK: - Functions

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JEDI: Unable to authentication with Firebase: \(error)")
            } else {
                print("JEDI: Successfully authentication with Firebase. ")
            }
        })
    }
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("JEDI: Successfully authenticated by email with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("JEDI: Unable to create user and auth by email with Firebase: \(error)")
                        } else {
                            print("JEDI: Successfully created user and authenticated by email with Firebase. ")
                        }
                    })
                }
            })
        }
    }
    
    
}






