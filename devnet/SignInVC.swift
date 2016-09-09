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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var emailTextField: FancyField!
    @IBOutlet weak var passwordTextField: FancyField!
    
    // MARK: - @Properties
    
    var userInfo: User!
    
    // MARK: - View Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_USERNAME) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.userInfo = User(uid: user.uid, userData: userData)
                    self.chooseUsername(user: self.userInfo)
                }
            }
        })
    }
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("JEDI: Successfully authenticated by email with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.userInfo = User(uid: user.uid, userData: userData)
                        self.chooseUsername(user: self.userInfo)
                    }
                } else {
                    // CREATE
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("JEDI: Unable to create user and auth by email with Firebase: \(error)")
                        } else {
                            print("JEDI: Successfully created user and authenticated by email with Firebase. ")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.userInfo = User(uid: user.uid, userData: userData)
                                self.chooseUsername(user: self.userInfo)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func chooseUsername(user: User) {
        
        let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(user.uid, forKey: KEY_UID)
        if keychainResult {
            print("JEDI: Data saved to keychain - \(keychainResult)")
            
            let userRef = DataService.ds.REF_USERS.child(user.uid).child("username")
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("JEDI: BEFORE SEGUE - \(user.uid)")
                    self.performSegue(withIdentifier: "goToUsername", sender: user)
                } else {
                    if let usernameDict = snapshot.value as? Dictionary<String, String> {
                        if let username = usernameDict["username"] {
                            print("JEDI: - \(username)")
                            let _ = KeychainWrapper.defaultKeychainWrapper().setString(username, forKey: KEY_USERNAME)
                            self.performSegue(withIdentifier: "goToFeed", sender: nil)
                        }
                    }
                }
            })
        } else {
            print("JEDI: Cannot save data to keychain - \(keychainResult)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUsername" {
            print("JEDI: Here for segue to username preparation")
            if let destination = segue.destination as? UsernameVC {
                if let user = sender as? User {
                    print("JEDI: BEFORE SET DESTINATION - \(user.uid)")
                    destination.user = user
                }
            }
        }
    }

}

