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
    @IBOutlet weak var captionTextField: FancyField!

    //MARK: - @Properties
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var isImageSelected: Bool = false
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
            self.posts.removeAll()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - @IBActions

    @IBAction func signOutButtonPressed(_ sender: AnyObject) {
        let _ = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        let _ = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_USERNAME)
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonPressed(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: AnyObject) {
        guard let caption = captionTextField.text, caption != "" else {
            print("JEDI: Caption must be entered. ")
            return
        }
        guard let image = addImageImageView.image, isImageSelected == true else {
            print("JEDI: Image must be selected. ")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().uuidString
            let imageMetadata = FIRStorageMetadata()
            imageMetadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: imageMetadata, completion: { (metadata, error) in
                if error != nil {
                    print("JEDI: Unable to upload image to Firebase storage. - \(error)")
                } else {
                    print("JEDI: Image has been upload to Firebase storage. ")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            })
        }
    }
    
    //MARK: - Functions
    
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionTextField.text! as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        //self.posts.removeAll()
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTextField.text = ""
        isImageSelected = false
        addImageImageView.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    //MARK: - UIImagePickerViewDelegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageImageView.image = image
            isImageSelected = true
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
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }

}
