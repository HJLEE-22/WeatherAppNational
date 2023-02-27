//
//  BulletinBoardViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/17.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore


class BulletinBoardViewController: UIViewController {
    
    // MARK: - Properties
    
        // MARK:  Models
    
    // models for navigation background gradient
    var weatherKitModel: WeatherKitModel?
    var backgroundGradientLayer: CAGradientLayer?
    
    // model for chat
    var chats: [ChatModel] = []
    var chatViewModel: ChatViewModel! {
        didSet {
            self.chatViewModel.subscribe(observer: self)
        }
    }
    
    var userViewModel: UserViewModel! {
        didSet {
            self.userViewModel.subscribe(observer: self)
        }
    }
    
        // MARK:  Other Properties
    
    let bulletinBoardView = BulletinBoardView()

    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBulletinBoardView()
        self.setCells()
        self.userViewModel = .init()
        self.addTargetToButton()
        self.getChatsFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBackgroundLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroundGradientLayer?.removeFromSuperlayer()
    }


    // MARK: - Helpers
    
    func setupBackgroundLayer() {
        DispatchQueue.main.async {
            if let backgroundGradientLayer = self.backgroundGradientLayer {
                backgroundGradientLayer.frame = CGRect(x: 0, y: -59, width: 500, height: 103)
                self.navigationController?.navigationBar.layer.addSublayer(backgroundGradientLayer)
            }
        }
    }

    
    func setBulletinBoardView() {
        self.view.addSubview(bulletinBoardView)
        bulletinBoardView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
        }
    }
    
    func setCells() {
        bulletinBoardView.chattingsTableView.delegate = self
        bulletinBoardView.chattingsTableView.dataSource = self
        bulletinBoardView.chattingsTableView.register(UserChatCell.self, forCellReuseIdentifier: "UserChatCell")
        bulletinBoardView.chattingsTableView.register(OthersChatCell.self, forCellReuseIdentifier: "OthersChatCell")
        bulletinBoardView.chattingsTableView.estimatedRowHeight = 70
        bulletinBoardView.chattingsTableView.rowHeight = UITableView.automaticDimension
        bulletinBoardView.chattingsTableView.separatorStyle = .none
    }
    
    func addTargetToButton() {
        self.bulletinBoardView.returnButton.addTarget(self, action: #selector(addChatToFirebase), for: .touchUpInside)
        self.bulletinBoardView.typingTextField.text = ""
    }
    
    @objc func addChatToFirebase() {
        guard let cityName = navigationItem.title,
              let message = bulletinBoardView.typingTextField.text else { return }
        // userModel을 이런식으로 가져와도 되는지...
        self.chatViewModel = .init(user: userViewModel.user, location: cityName, message: message)
        self.bulletinBoardView.typingTextField.text = ""
    }
    
    func getChatsFromFirestore() {
        collectionChats.order(by: "timestamp").addSnapshotListener { snapshot, error in
            self.chats = []
            if error != nil {
                print(error?.localizedDescription)
            }
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
                        self.chats.append(ChatModel(userName: userName, userUid: userUid, message: message, timestamp: time))
                        
                        DispatchQueue.main.async {
                            self.bulletinBoardView.chattingsTableView.reloadData()
                            self.bulletinBoardView.chattingsTableView.scrollToRow(at: IndexPath(row: self.chats.count-1, section: 0), at: .top, animated: false)
                        }
                    }
                }
            }
        }
    }
}


extension BulletinBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = chats[indexPath.row]
        let userChatCell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
        let othersChatCell = tableView.dequeueReusableCell(withIdentifier: "OthersChatCell", for: indexPath) as! OthersChatCell
        
        if chat.userUid == Auth.auth().currentUser?.uid {
            userChatCell.chatLabel.text = chat.message
            userChatCell.idLabel.text = "user"
            userChatCell.timeLabel.text = chat.timestamp
            return userChatCell
        } else {
            othersChatCell.chatLabel.text = chat.message
            othersChatCell.idLabel.text = chat.userName
            othersChatCell.timeLabel.text = chat.timestamp
            return othersChatCell
        }
    }
}

extension BulletinBoardViewController: UITextFieldDelegate {
    
    
    
    
}

extension BulletinBoardViewController: ChatObserver {
    func chatUpdate<T>(updateValue: T) {
        guard let value = updateValue as? ChatModel else { return }
        // usermodel이 생기는 곳에서 초기화를 해야 하나?
        // 게시판 이름은? navigationtitle?
        
    }
}

extension BulletinBoardViewController: UserObserver {
    func userUpdate<T>(updateValue: T) {
        guard let value = updateValue as? UserModel else { return }
        // message 내용을 받아야 해서 우선 애드타겟 함수에 챗뷰모델 초기화문 넣어놓음.
        // 그래서 유저모델 받는 타이밍이 에매해짐...
//        self.chatViewModel = .init(user: value, location: self.navigationItem.title, message: self.bulletinBoardView.typingTextField.text)
    }
    
    
}
