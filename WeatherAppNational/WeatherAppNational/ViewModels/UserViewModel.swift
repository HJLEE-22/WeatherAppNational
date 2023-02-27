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
    
    var name: String?
    var email: String?
    var uid: String?
    
    
    // MARK: - Lifecycle
    
    init() {
        self.bind()
    }
    
    
    // MARK: - Helpers
    
    func bind() {
// userViewModel은 파이버스토어에 데이터가 등록될 때 생성됨
// 따라서 구지 데이터를 불러올 필요가 없음...
// 그러면 이 뷰모델에서 하는건, 그냥 usermodel을 만드는 것 뿐...
        // 진짜 너무 쓸모없지 않은지?...
        
// -> 수정. 아무 인자값도 받지 않고 뷰모델을 초기화하고
// 여기서 uid를 받아 유저 모델을 만들도록 함.
// 그니까 이 뷰모델은 구독하기만하면 조건없이 유저모델 준다!
        
            guard let uid = Auth.auth().currentUser?.uid else { return }

            COLLECTION_USERS.document(uid).getDocument { document, error in
                if let document = document, document.exists {
                    let documentData = document.data().map { data in
                        self.name = data["name"] as? String
                        self.email = data["email"] as? String
                        self.uid = uid
                        self.user = UserModel(name: self.name, email: self.email, uid: self.uid)
                    }
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


