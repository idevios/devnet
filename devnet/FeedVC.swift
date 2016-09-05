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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageImageView: UIImageView!

    //MARK: - @Properties
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    //MARK: - View Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // DataService
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
    
    @IBAction func addImageButtonPressed(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - UIImagePickerViewDelegate Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageImageView.image = image
        } else {
            print("JEDI: A valid image wasn't selected. ")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDelegate Conform
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostedCell") as? PostedCell {
            
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        }else {
            return PostedCell()
        }
        //return PostedCell()
    }

}
