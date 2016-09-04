//
//  PostedCell.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/2/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit

class PostedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.captionTextView.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }

}
