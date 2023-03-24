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
    
    private var listener: ListenerRegistration?
    
    private var chats: [ChatModel] = []
    
    private var user: UserModel?
    private var message: String?
    
    private var blockedUserUid: String? {
        didSet {
            guard let blockedUserUid else { return }
            var oldValue = blockedUserUids
            oldValue.append(blockedUserUid)
            blockedUserUids = oldValue
        }
    }
    
    private var blockedUserUids: Array<String> {
        get {
            UserDefaults.standard.array(forKey: UserDefaultsKeys.blockedUserUids) as? Array<String> ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.blockedUserUids)
        }
    }
    
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
        let documentLocation = collectionLocations.document("\(location)")
        let collectionChats = documentLocation.collection("chats")
        let documentChat = collectionChats.document()
        let documentID = documentChat.documentID
        documentChat.setData(["userName": name,
                              "userUid": uid,
                              "chat": message,
                              "timestamp": nowTime,
                              "documentID": documentID]) { error in
            if let error = error {
                print("SendMessage Error: ", error)
            } else {
                completion()
            }
        }
    }
    
    func sendDefaultMessage(location: String,
                            completion: @escaping () -> Void) {
        let nowTime = TimeCalculate.nowTimeWithMinString
        let documentLocation = collectionLocations.document("\(location)")
        let collectionChats = documentLocation.collection("chats")
        let documentChat = collectionChats.document()
        let documentID = documentChat.documentID
        documentChat.setData(["userName": "안내😀",
                              "userUid": "defaultUid",
                              "chat": "\(location)의 \(DateCalculate.todayDateShortString)자 게시판에 오신걸 환영합니다👋\n오늘 날씨에 관한 얘기를 나눠주세요💬",
                              "timestamp": nowTime,
                              "documentID": documentID]) { error in
            if let error = error {
                print("SendMessage Error: ", error)
            } else {
                completion()
            }
        }
    }
    
    func subscribeFireStore(location: String) {
        chats.removeAll()
        let documentLocation = collectionLocations.document("\(location)")
        let collectionChats = documentLocation.collection("chats")
        
        listener = collectionChats.order(by: "timestamp").addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let self else { return }
            guard !self.chats.isEmpty else {
                guard let snapshotDocument = snapshot?.documents else { return }
                if snapshotDocument.isEmpty {
                    self.sendDefaultMessage(location: location, completion: { })
                }
                snapshotDocument.forEach { [weak self] doc in
                    let data = doc.data()
                    self?.setChatsArrayFromFirestore(data: data, blockedUserUids: self?.blockedUserUids)
                }
                self.notify(updateValue: true)
                return
            }
            guard let changes = snapshot?.documentChanges else { return }
            changes.forEach { [weak self] change in
                switch change.type {
                case .added:
                    let data = change.document.data()
                    print("DEBUG: data added:\(data)")
                    self?.setChatsArrayFromFirestore(data: data, blockedUserUids: self?.blockedUserUids)
                    self?.notify(updateValue: true)
                case .modified:
                    print("DEBUG: data modified")
                case .removed:
                    self?.notify(updateValue: true)
                    print("DEBUG: data removed")
                }
            }
        }
    }
    
    func setChatsArrayAfterBlock(location: String) {
        chats.removeAll()
        let documentLocation = collectionLocations.document("\(location)")
        let collectionChats = documentLocation.collection("chats")
        collectionChats.order(by: "timestamp").getDocuments { [weak self] snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let self,
                  let snapshotDocuments = snapshot?.documents else { return }
            snapshotDocuments.forEach { [weak self] doc in
                let data = doc.data()
                self?.setChatsArrayFromFirestore(data: data, blockedUserUids: self?.blockedUserUids)
            }
            self.notify(updateValue: true)
            return
        }
    }
    
    private func setChatsArrayFromFirestore(data: [String:Any], blockedUserUids: Array<String>?) {
        if let userName = data["userName"] as? String,
           let userUid = data["userUid"] as? String,
           let message = data["chat"] as? String,
           let timestamp = data["timestamp"] as? String,
           let documentID = data["documentID"] as? String {
            let startIndex = timestamp.index(timestamp.startIndex, offsetBy: 0)
            let endIndex = timestamp.index(timestamp.startIndex, offsetBy: 4)
            let range = startIndex...endIndex
            let time = String(timestamp[range])
            
            if let blockedUserUids, blockedUserUids.contains(userUid) {
                return
            } else {
                let chat: ChatModel = .init(userName: userName,
                                            userUid: userUid,
                                            message: message,
                                            timestamp: time,
                                            documentID: documentID)
                self.chats.append(chat)
            }
        }
    }
    
    func deleteChat(location: String, documentID: String) {
        let documentLocation = collectionLocations.document("\(location)")
        let collectionChats = documentLocation.collection("chats")
        let documentChat = collectionChats.document(documentID)
        
        guard let index = chats.firstIndex(where: { $0.documentID == documentID }) else { return }
        chats.remove(at: index)
        documentChat.delete()
    }
    
    func setupChatsWithoutBlockedUser(blockedUserUid: String, completion: () -> Void?) {
        self.blockedUserUid = blockedUserUid
        completion()
    }
    
    func unsubscribeFireStore() {
        chats.removeAll()
        listener?.remove()
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
