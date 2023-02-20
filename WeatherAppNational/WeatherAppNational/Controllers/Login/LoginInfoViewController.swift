//
//  LoginInfoViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/31.
//

import UIKit
import FirebaseFirestore

class LoginInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginInputView = LoginInfoView()
    var userViewModel: UserViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addActionToButton()
    }
    
    // MARK: - Helpers
    
    func setupView() {
        self.view.addSubview(loginInputView)
        
        loginInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addActionToButton() {
        loginInputView.moveToMainButton.addTarget(self, action: #selector(moveToMainVC), for: .touchUpInside)
    }
    
    @objc func moveToMainVC() {

        guard loginInputView.nicknameTextField.hasText == true else {
            print("DEBUG: nicknameTextField:\(loginInputView.nicknameTextField.hasText)")
            self.setupAlert()
            return
        }
        
        setupUserInfo()
        let mainVC = MainPageViewController()
        show(mainVC, sender: self)
    }
    
    func setupUserInfo() {
        guard let nickname = loginInputView.nicknameTextField.text,
              let email = FirebaseAuthentication.shared.email,
              let uid = FirebaseAuthentication.shared.uid else { return }
        let data: [String:Any] = ["name": nickname,
                                  "email": email,
                                  "uid" : uid]
        COLLECTION_USERS.document(uid).setData(data)
        self.userViewModel = .init(name: nickname, email: email, uid: uid)
        let settingViewContoller = SettingViewController()
        UserDefaults.standard.set(true, forKey: "isUserDataExist")
    }
    
    func setupAlert() {
        let requestAlert = UIAlertController(title: "빈 칸이 있습니다.", message: "모든 항목을 입력해 주세요." , preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        requestAlert.addAction(cancel)
        present(requestAlert, animated: true)
    }
}

