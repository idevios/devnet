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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: - @Properties
    
    var posts = [Post]()
    
    //MARK: - View Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    //MARK: - @IBActions

    @IBAction func signOutButtonPressed(_ sender: AnyObject) {
        let _ = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostedCell") as? PostedCell {
                cell.configureCell(post: self.posts[indexPath.row])
            return cell
        }else {
            return PostedCell()
        }
    }

}
