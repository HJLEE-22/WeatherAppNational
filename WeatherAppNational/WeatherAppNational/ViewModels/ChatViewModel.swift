//
//  ChatViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/02/17.
//

import UIKit
import FirebaseFirestore

class ChatViewModel {
    
    // MARK: - Properties
    
    var observer: (any ChatObserver)?
    
    var chat: ChatModel = ChatModel() {
        didSet {
            self.notify(updateValue: chat)
        }
    }

    var user: UserModel?
    var message: String?
    var location: String?
    var documentID: String?
    private var nowTime = TimeCalculate.nowTimeString

    // MARK: - Lifecycle
    init(user: UserModel, message: String, location: String) {
        self.user = user
        self.message = message
        self.location = location
        self.setupChat()
    }
    
    // MARK: -Helpers
    
    func setupChat() {
        guard let user,
              let location else { return }
        self.chat = ChatModel(userName: user.name,
                              userUid: user.uid,
                              message: self.message,
                              timestamp: self.nowTime)
        self.bindToFirebase(user: user, location: location)
    }
    
    func bindToFirebase(user: UserModel, location: String) {
        let document = collectionChats.document()
        self.documentID = document.documentID
        document.setData(["userName": user.name,
                          "userUid": user.uid,
                          "chat": self.message,
                          "timestamp": self.nowTime])
    }
}

extension ChatViewModel: ChatSubscriber {
    func subscribe(observer: (ChatObserver)?) {
        self.observer = observer
    }
    
    func unsubscribe(observer: (ChatObserver)?) {
        self.observer = nil
    }
    
    func notify<T>(updateValue: T) {
        self.observer?.chatUpdate(updateValue: updateValue)
    }
}
