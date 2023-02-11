//
//  UserViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/02/01.
//

import UIKit
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
        
        bind()
    }
    
    
    // MARK: - Helpers
    
    func bind() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.user = UserModel(name: self.name,
                                  email: self.email,
                                  uid: self.uid
            )
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


