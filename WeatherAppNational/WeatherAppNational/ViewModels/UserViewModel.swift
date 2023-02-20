//
//  UserViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/02/01.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserViewModel {
    
    // MARK: - Properties
    var observer: UserObserver?
    
    var user: UserModel = UserModel() {
        didSet {
            notify(updateValue: user)
            print("DEBUG: userData by UserModel:\(user)")
            
        }
    }
    
    var name: String = ""
    var email: String = ""
    var uid: String = ""
    
    
    // MARK: - Lifecycle
    
    init(name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
        self.bind()
    }
    
    
    // MARK: - Helpers
    
    func bind() {
        COLLECTION_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
//                self.name = document.value(forKey: "name")
//                self.email = document.value(forKey: "email")
//                self.uid = document.value(forKey: "uid")
            }
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                self.user = UserModel(name: self.name,
                                      email: self.email,
                                      uid: self.uid
                )
            }
        }
    }
}

extension UserViewModel: UserSubcriber {
    func subscribe(observer: (UserObserver)?) {
        self.observer = observer
    }

    func unsubscribe(observer: (UserObserver)?) {
        self.observer = nil
    }

    func notify<T>(updateValue: T) {
        self.observer?.userUpdate(updateValue: updateValue)
    }
}


