//
//  PostedCell.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/2/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeTap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(likeTap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                //UIImage(named: "empty-heart")
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
                self.post.adjustLike(addLike: true)
                self.likesRef.setValue(true)
            } else {
                //UIImage(named: "filled-heart")
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
                self.post.adjustLike(addLike: false)
                self.likesRef.removeValue()
            }
            
        })
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.captionTextView.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        
        if image != nil {
            self.postedImage.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JEDI: Unable to download image from Firebase storage - \(error)")
                } else {
                    print("JEDI: Image downloaded from Firebase storage.")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.postedImage.image = image
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                //UIImage(named: "empty-heart")
                self.likeImage.image = #imageLiteral(resourceName: "empty-heart")
            } else {
                //UIImage(named: "filled-heart")
                self.likeImage.image = #imageLiteral(resourceName: "filled-heart")
            }
        })
    }

}










