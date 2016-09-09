//
//  User.swift
//  devnet
//
//  Created by Theerapan Khanthigul on 9/8/2559 BE.
//  Copyright © 2559 iDeviOS. All rights reserved.
//

import Foundation

class User {
    
    private var _uid: String!
    private var _userData: Dictionary<String, String>!
    
    var uid: String {
        if _uid == nil {
            _uid = ""
        }
        return _uid
    }
    
    var userData: Dictionary<String, String> {
        if _userData == nil {
            _userData = ["":""]
        }
        return _userData
    }
    
    init(uid: String, userData: Dictionary<String, String>) {
        self._uid = uid
        self._userData = userData
    }
    
}
