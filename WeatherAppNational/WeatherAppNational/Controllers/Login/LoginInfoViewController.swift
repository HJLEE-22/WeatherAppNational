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
    

    var user: UserModel?
    
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
//        guard loginInputView.nicknameTextField.state.isEmpty == false,
//              loginInputView.emailTextField.state.isEmpty == false else {
//            print("DEBUG: nicknameTextField:\(loginInputView.nicknameTextField.state.isEmpty)")
//            print("DEBUG: emailTextField:\(loginInputView.emailTextField.state.isEmpty)")
//            self.setupAlert()
//            return
//        }
        guard loginInputView.nicknameTextField.hasText == true,
              loginInputView.emailTextField.hasText == true else {
            print("DEBUG: nicknameTextField:\(loginInputView.nicknameTextField.hasText)")
            print("DEBUG: emailTextField:\(loginInputView.emailTextField.hasText)")
            self.setupAlert()
            return
        }
        
        print("DEBUG: nicknameTextField:\(loginInputView.nicknameTextField.text)")
        print("DEBUG: emailTextField:\(loginInputView.emailTextField.text)")
        setupUserInfo()
        let mainVC = MainPageViewController()
        show(mainVC, sender: self)

    }
    
    func setupUserInfo() {
        guard let nickname = loginInputView.nicknameTextField.text,
              let email = loginInputView.emailTextField.text,
              let uid = FirebaseAuthentication.shared.uid else { return }
        let data: [String:Any] = ["name": nickname,
                                  "email": email,
                                  "uid" : uid]
        COLLECTION_USERS.document(uid).updateData(data)
        let settingViewContoller = SettingViewController()
        settingViewContoller.userViewModel = .init(name: nickname, email: email, uid: uid)
        UserDefaults.standard.set(true, forKey: "isUserDataExist")
        // 파이어베이스에 넣는 것과, 내가 코드에서 쓸 유저모델을 만드는 것 둘 다를 매번 같이 입력하는게 어이가 없어서 뷰모델을 만든건데...
        // viewModel이 아무것도 안해서 그래. viewModel로 이동할게. 근데 일단은 구현부터 하고?
    }
    
    func setupAlert() {
        let requestAlert = UIAlertController(title: "빈 칸이 있습니다.", message: "모든 항목을 입력해 주세요." , preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        requestAlert.addAction(cancel)
        present(requestAlert, animated: true)
    }
    
}

