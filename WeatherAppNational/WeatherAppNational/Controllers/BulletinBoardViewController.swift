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
    
    private func setInteractionForContextMenu() {
        
    }
    
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
                                                      forCellReuseIdentifier: CellID.userChatCell)
        bulletinBoardView.chattingsTableView.register(OthersChatCell.self,
                                                      forCellReuseIdentifier: CellID.othersChatCell)
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
        guard UserDefaults.standard.bool(forKey: UserDefaultsKeys.isUserDataExist) == true else {
            showAlert("로그인 필요", "로그인이 필요한 서비스입니다.", setLoginViewAnywhere)
            return
        }
        guard bulletinBoardView.typingTextField.text != "" else {
            showAlert("메세지 입력", "게시글 등록을 위해 메세지를 입력하세요.", nil)
            return
        }
        guard let cityName = navigationItem.title,
              let message = bulletinBoardView.typingTextField.text
        else { return }
        
        chatViewModel.sendMessage(message, location: cityName) { [weak self] in
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
        let userChatCell = tableView.dequeueReusableCell(withIdentifier: CellID.userChatCell, for: indexPath) as! UserChatCell
        let othersChatCell = tableView.dequeueReusableCell(withIdentifier: CellID.othersChatCell, for: indexPath) as! OthersChatCell
        
        if chat.userUid == Auth.auth().currentUser?.uid {
            userChatCell.chatLabel.text = chat.message
            userChatCell.idLabel.text = "user"
            userChatCell.timeLabel.text = chat.timestamp
            userChatCell.selectionStyle = .none
            let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
            userChatCell.addInteraction(contextMenuInteraction)
            return userChatCell
        } else {
            othersChatCell.chatLabel.text = chat.message
            othersChatCell.idLabel.text = chat.userName
            othersChatCell.timeLabel.text = chat.timestamp
            othersChatCell.selectionStyle = .none
            let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
            othersChatCell.addInteraction(contextMenuInteraction)
            return othersChatCell
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let index = indexPath.row
        let chats = chatViewModel.getChatsValue()
        let chat = chats[index]
       
        let identifier = "\(index)" as NSString
        
        if chat.userUid == Auth.auth().currentUser?.uid {
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
                let copyAction = UIAction(title: "복사", image: UIImage(systemName: SystemIconNames.copy)) { action in
                    let textToCopy = chat.message
                    UIPasteboard.general.string = textToCopy
                }
                let shareAction = UIAction(title: "삭제", image: UIImage(systemName: SystemIconNames.deleteLeft), attributes: .destructive) { action in
                    
                }
                return UIMenu(title: "", children: [copyAction, shareAction])
            }
        } else {
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
                let copyAction = UIAction(title: "게시글 신고", image: UIImage(systemName: SystemIconNames.exclamationMarkCircle)) { action in
                   
                }
                let shareAction = UIAction(title: "유저 차단", image: UIImage(systemName: SystemIconNames.personWithXmark)) { action in
                    
                }
                return UIMenu(title: "", children: [copyAction, shareAction])
            }
        }
    }
}

extension BulletinBoardViewController: ChatObserver {
    func chatUpdate<T>(updateValue: T) {
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


extension BulletinBoardViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        // Get the index path of the table view cell that was selected
        guard let tableView = interaction.view as? UITableView,
              let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        // Get the context menu configuration for the selected cell
        let configuration = self.tableView(tableView, contextMenuConfigurationForRowAt: indexPath, point: location)
        
        return configuration
    }
}
