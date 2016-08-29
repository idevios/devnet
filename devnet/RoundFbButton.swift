//
//  RoundFbButton.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 8/29/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import UIKit

class RoundFbButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.width / 2
    }

}
