//
//  LoginViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/28.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProviderLoginButton()
    }

    // MARK: - Helpers
    
    
    func setupUI() {
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupProviderLoginButton() {
        self.loginView.appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        guard let window = self.view.window else { return }
        FirebaseAuthentication.shared.signInWithApple(window: window)
        
    }
}
