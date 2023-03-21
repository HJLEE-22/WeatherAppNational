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
import MessageUI


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
        
    let currentUser = Auth.auth().currentUser

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        chatViewModel = .init()
        chatViewModel.subscribe(observer: self)
        setBulletinBoardView()
        setCells()
        addTargetToButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupBackgroundLayer()
        subscribeFireStoreFromViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroundGradientLayer?.removeFromSuperlayer()
        unsubscribeFireStoreFromViewModel()
//        chatViewModel.unsubscribe(observer: self)
    }
    
    override func viewWillLayoutSubviews() {
        
    }

    // MARK: - Helpers
    
    private func subscribeFireStoreFromViewModel() {
        guard let location = navigationItem.title else {
            print("DEBUG: location error: 도시명 파악 실패")
            return
        }
        chatViewModel.subscribeFireStore(location: location)
    }
    
    private func unsubscribeFireStoreFromViewModel() {
        chatViewModel.unsubscribeFireStore()
    }
    
    private func setupBackgroundLayer() {
        DispatchQueue.main.async { [weak self] in
            if let backgroundGradientLayer = self?.backgroundGradientLayer {
                backgroundGradientLayer.frame = CGRect(x: 0, y: -59, width: 500, height: 103)
                self?.navigationController?.navigationBar.layer.addSublayer(backgroundGradientLayer)
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
            self?.bulletinBoardView.typingTextField.resignFirstResponder()
        }
    }
    
    func setReportAlert(completion: @escaping (ReportType) -> Void) {
        let alert = UIAlertController(title: "게시글 신고", message: nil, preferredStyle: .actionSheet)
        let notProperContent = UIAlertAction(title: "부적절한 내용", style: .default) {_ in
            completion(.notProperContent)
        }
        let cheatContent = UIAlertAction(title: "사기유도", style: .default) {_ in
            completion(.cheatContent)
        }
        let blamingContent = UIAlertAction(title: "모욕 및 욕설", style: .default) {_ in
            completion(.blamingContent)
        }
        let elseContent = UIAlertAction(title: "기타 이유", style: .default) {_ in
            completion(.elseContent)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [notProperContent, cheatContent, blamingContent, elseContent, cancel].forEach { alert.addAction($0) }
        present(alert, animated: true)
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
        
        if chat.userUid == currentUser?.uid {
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
                let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: SystemIconNames.deleteLeft), attributes: .destructive) { [weak self] action in
                    guard let location = self?.navigationItem.title,
                          let documentID = chat.documentID else { return }
                    self?.chatViewModel.deleteChat(location: location, documentID: documentID)
                }
                return UIMenu(title: "", children: [copyAction, deleteAction])
            }
        } else {
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
                let userBlockAction = UIAction(title: "유저 차단", image: UIImage(systemName: SystemIconNames.personWithXmark)) { [weak self] action in
                    guard let blockedUser = chat.userUid else { return }
                    self?.showAlert("유저를 차단하시겠습니까?", "해당 유저의 메세지는 보여지지 않고\n차단은 복구할 수 없습니다.") {
                        self?.chatViewModel.setupChatsWithoutBlockedUser(blockedUserUid: blockedUser) {
                            self?.subscribeFireStoreFromViewModel()
                        }
                    }
                }
                let reportAction = UIAction(title: "게시글 신고", image: UIImage(systemName: SystemIconNames.alarm), attributes: .destructive) {[weak self] action in
                    guard let location = self?.navigationItem.title,
                          let documentID = chat.documentID else { return }
                    self?.setReportAlert() { [weak self] type in
                        guard let self else { return }
                        guard let email = self.currentUser?.email else {
                            self.showAlert("로그인 필요", "로그인이 필요한 서비스입니다.", {})
                            return
                        }
                        self.sendEmail(self: self, userEmail: email, type, chat) { 
                            self.chatViewModel.deleteChat(location: location, documentID: documentID)
                        }
                    }
                }
                return UIMenu(title: "", children: [userBlockAction, reportAction])
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
            if !chats.isEmpty {
                self.bulletinBoardView.chattingsTableView.scrollToRow(at: IndexPath(row: chats.count-1, section: 0),
                                                                      at: .top,
                                                                      animated: false)
            }
        }
    }
}


extension BulletinBoardViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let tableView = interaction.view as? UITableView,
              let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        let configuration = self.tableView(tableView, contextMenuConfigurationForRowAt: indexPath, point: location)
        
        return configuration
    }
}



extension BulletinBoardViewController: MFMailComposeViewControllerDelegate {
       
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true, completion: nil)
       }
}
