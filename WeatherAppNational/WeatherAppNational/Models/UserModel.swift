//
//  User.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/31.
//

import Foundation
import FirebaseAuth

struct UserModel {
    var name: String?
    var email: String?
    var uid: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
//    init(dictionay: [String:Any]) {
//        self.name = dictionay["name"] as? String ?? ""
//        self.email = dictionay["email"] as? String ?? ""
//        self.bookmark = dictionay["bookmark"] as? [String] ?? []
//        self.uid = dictionay["uid"] as? String ?? ""
//    }
}


