//
//  UsernameVC.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/8/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit

class UsernameVC: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
    }

}
