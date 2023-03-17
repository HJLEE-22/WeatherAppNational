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
    private var blockedUserUids = Set<String>()
    
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
    
    func subscribeFireStore(location: String) {
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
    
    func setChatsArrayFromFirestore(data: [String:Any], blockedUserUids: Set<String>?) {
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
    
    func setupChatsWithoutBlockedUser(blockedUserUid: String) {
        // 이거 난감하네. 나는 collection에서 document 단위로 들어가야하는데, 도큐먼트 단위로 들어가는 유일한 방법은 아이디를 아는 것 뿐... 매핑으로 해당 도큐먼트의 아이디를 모른채 도큐먼트 안의 유저 아이디를 검색할 순 없군.
        // 쉬운 방법이 생각났다... 스냅샷 리스너에서 조건을 걸면 되지 않나?? 그니까, 파이어베이스의 데이터는 무조건 들어가는게 맞는데 엑스코드 상에서 유저를 걸러내야하니까!
        // 그러면 여기서 블럭유저 변수를 설정하고, 해당 변수값을 한번 필터링해줘야겠다.
        // 생각할 건, 뷰모델에서 변수값을 받는다? 그러면 스냅샷을 다시 작동시켜야하나? 스냅샷은 항상 듣고있으니 그럴필요가없나?
        // 그러면구지 함수에서 받을필요도 없음. 근데 스냅샷은 맨 처음 메세지가 쓰이거나, 메세지가 더해지거나 수정할때만 작동하는것 같은데
        // 하지만 이거는 파이어베이스의 메세지가 변동하지 않기 때문에 작동하지 않는다! 스냅샷을 재작동하게 만들어줘야함.
        // 일단 리스너 초기화로 시도해보겠음...
        self.blockedUserUids.insert(blockedUserUid)
        print("DEBUG: blockedUserSet:\(self.blockedUserUids)")

        listener?.`self`()
    }
    
    
    func unsubscribeFireStore() {
        chats = []
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
