//
//  FeedVC.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/2/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutButtonPressed(_ sender: AnyObject) {
        let _ = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }

}
