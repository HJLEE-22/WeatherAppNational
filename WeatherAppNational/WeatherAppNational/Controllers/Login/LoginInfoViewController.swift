//
//  LoginInfoViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/31.
//

import UIKit
import FirebaseFirestore

final class LoginInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginInputView = LoginInfoView()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addActionToButton()
    }
    
    // MARK: - Helpers
    
    private func setupView() {
        self.view.addSubview(loginInputView)
        
        loginInputView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addActionToButton() {
        loginInputView.moveToMainButton.addTarget(self, action: #selector(moveToMainVC), for: .touchUpInside)
        print("DEBUG: touched:")

    }
    
    @objc private func moveToMainVC() {
        guard loginInputView.nicknameTextField.hasText == true else {
            print("DEBUG: nicknameTextField:\(loginInputView.nicknameTextField.hasText)")
            showAlert("빈 칸이 있습니다.", "모든 항목을 입력해 주세요.", nil)
            return
        }
        
        setupUserInfo()
        let mainVC = MainPageViewController()
        show(mainVC, sender: self)
    }
    
    private func setupUserInfo() {
        guard let nickname = loginInputView.nicknameTextField.text,
              let email = FirebaseAuthentication.shared.email,
              let uid = FirebaseAuthentication.shared.uid
        else { return }
        let data: [String:Any] = ["name": nickname,
                                  "email": email,
                                  "uid" : uid]
        collectionUsers.document(uid).setData(data)
        UserDefaults.standard.set(["userName" : nickname,
                                   "userEmail": email,
                                   "userUid" : uid], forKey: UserDefaultsKeys.userModel)
        let settingViewContoller = SettingViewController()
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isUserDataExist)
    }
}


