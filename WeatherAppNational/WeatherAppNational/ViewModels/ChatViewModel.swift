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
    
    private var chats: [ChatModel] = []

    private var user: UserModel?
    private var message: String?
    private var documentID: String?
    
    // MARK: - Lifecycle
    init() {
        guard let userModel = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.userModel) else { return }
        let uid = userModel["userUid"] as? String
        let email = userModel["userEmail"] as? String
        let name = userModel["userName"] as? String
        user = .init(name: name, email: email, uid: uid)
    }
    
    func sendMessage(_ message: String,
                     location: String,
                     completion: @escaping () -> Void) {
        guard let user = user,
              let name = user.name,
              let uid = user.uid else { return }
        let nowTime = TimeCalculate.nowTimeWithMinString
        let document = collectionChats.document()
        let documentID = document.documentID
        
        document.setData(["userName": name,
                          "userUid": uid,
                          "chat": message,
                          "timestamp": nowTime]) { error in
            if let error = error {
                print("SendMessage Error: ", error)
            } else {
                completion()
            }
        }
    }
    
    func subscribeFireStore() {
        collectionChats.order(by: "timestamp").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let self else { return }
                if self.chats.isEmpty {
                    if let snapshotDocument = snapshot?.documents {
                        snapshotDocument.forEach { doc in
                            let data = doc.data()
                            if let userName = data["userName"] as? String,
                               let userUid = data["userUid"] as? String,
                               let message = data["chat"] as? String,
                               let timestamp = data["timestamp"] as? String {
                                let startIndex = timestamp.index(timestamp.startIndex, offsetBy: 0)
                                let endIndex = timestamp.index(timestamp.startIndex, offsetBy: 4)
                                let range = startIndex...endIndex
                                let time = String(timestamp[range])
                                
                                let chat: ChatModel = .init(userName: userName,
                                                   userUid: userUid,
                                                   message: message,
                                                   timestamp: time)
                                
                                self.chats.append(chat)
                            }
                        }
                        self.notify(updateValue: true)
                    }
                } else {
                    if let changes = snapshot?.documentChanges {
                        changes.forEach { change in
                            switch change.type {
                            case .added:
                                let chat = change.document.data()
                                print("DEBUG: data added:\(chat)")
                                if let userName = chat["userName"] as? String,
                                   let userUid = chat["userUid"] as? String,
                                   let message = chat["chat"] as? String,
                                   let timestamp = chat["timestamp"] as? String {
                                    let startIndex = timestamp.index(timestamp.startIndex, offsetBy: 0)
                                    let endIndex = timestamp.index(timestamp.startIndex, offsetBy: 4)
                                    let range = startIndex...endIndex
                                    let time = String(timestamp[range])
                                    
                                    let chat: ChatModel = .init(userName: userName,
                                                                userUid: userUid,
                                                                message: message,
                                                                timestamp: time)
                                    self.chats.append(chat)
                                    self.notify(updateValue: true)
                                    return
                                }
                            case .modified:
                                print("DEBUG: data modified")
                            case .removed:
                                print("DEBUG: data removed")

                            }
                        }
                    }
                }
            }
        }
    }
    
    func getChatsValue() -> [ChatModel] {
        chats
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
