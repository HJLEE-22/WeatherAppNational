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


final class BulletinBoardViewController: UIViewController {
    
    // MARK: - Properties
    
    private var chatViewModel: ChatViewModel! {
        didSet {
            self.chatViewModel.subscribe(observer: self)
        }
    }

    
    private var weatherKitModel: WeatherKitModel?
    var backgroundGradientLayer: CAGradientLayer?
    
    private lazy var bulletinBoardView = BulletinBoardView()

    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        chatViewModel = .init()
        chatViewModel.subscribe(observer: self)
        setBulletinBoardView()
        setCells()
        addTargetToButton()
        chatViewModel.subscribeFireStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBackgroundLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroundGradientLayer?.removeFromSuperlayer()
    }


    // MARK: - Helpers
    
    private func setupBackgroundLayer() {
        DispatchQueue.main.async {
            if let backgroundGradientLayer = self.backgroundGradientLayer {
                backgroundGradientLayer.frame = CGRect(x: 0, y: -59, width: 500, height: 103)
                self.navigationController?.navigationBar.layer.addSublayer(backgroundGradientLayer)
            }
        }
    }
    
    private func setBulletinBoardView() {
        self.view.addSubview(bulletinBoardView)
        bulletinBoardView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
        }
    }
    
    private func setCells() {
        bulletinBoardView.chattingsTableView.delegate = self
        bulletinBoardView.chattingsTableView.dataSource = self
        bulletinBoardView.chattingsTableView.register(UserChatCell.self,
                                                      forCellReuseIdentifier: "UserChatCell")
        bulletinBoardView.chattingsTableView.register(OthersChatCell.self,
                                                      forCellReuseIdentifier: "OthersChatCell")
        bulletinBoardView.chattingsTableView.estimatedRowHeight = 70
        bulletinBoardView.chattingsTableView.rowHeight = UITableView.automaticDimension
        bulletinBoardView.chattingsTableView.separatorStyle = .none
    }
    
    private func addTargetToButton() {
        self.bulletinBoardView.returnButton.addTarget(self,
                                                      action: #selector(addChatToFirebase),
                                                      for: .touchUpInside)
        self.bulletinBoardView.typingTextField.text = ""
    }
    
    @objc func addChatToFirebase() {
        guard let cityName = navigationItem.title,
              let message = bulletinBoardView.typingTextField.text
        else { return }
        
        chatViewModel.sendMessage(message,
                                  location: cityName) { [weak self] in
            self?.bulletinBoardView.typingTextField.text = ""
        }
    }
}


extension BulletinBoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let chatCnt = chatViewModel.getChatsValue().count
        return chatCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chats = chatViewModel.getChatsValue()
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

extension BulletinBoardViewController: ChatObserver {
    func chatUpdate<T>(updateValue: T) {
        guard let value = updateValue as? Bool else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let chats = self.chatViewModel.getChatsValue()
            
            self.bulletinBoardView.chattingsTableView.reloadData()
            self.bulletinBoardView.chattingsTableView.scrollToRow(at: IndexPath(row: chats.count-1, section: 0),
                                                                  at: .top,
                                                                  animated: false)
        }
    }
}

extension BulletinBoardViewController: UserObserver {
    func userUpdate<T>(updateValue: T) {
        guard let value = updateValue as? Bool else { return }
        
    }
}
