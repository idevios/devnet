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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("JEDI: Unable to authentication with Firebase: \(error)")
            } else {
                print("JEDI: Successfully authentication with Firebase. ")
            }
            
        })
        
    }
    
}






