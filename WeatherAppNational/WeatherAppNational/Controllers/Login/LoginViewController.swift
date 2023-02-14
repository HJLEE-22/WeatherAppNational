//
//  LoginViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/28.
//

import UIKit
import SnapKit
import AuthenticationServices
import SafariServices

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProviderLoginButton()
        setupPrivacyPolicyButton()
        setupSignInAnonymousButton()
    }

    // MARK: - Helpers
    
    
    func setupView() {
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupProviderLoginButton() {
        self.loginView.appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    func setupPrivacyPolicyButton(){
        self.loginView.openPrivacyButton.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)
    }
    
    func setupSignInAnonymousButton(){
        self.loginView.signInAnonymousButton.addTarget(self, action: #selector(signInAnonymousTapped), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        guard let window = self.view.window else { return }
        FirebaseAuthentication.shared.signInWithApple(window: window)
    }
    
    @objc func openPrivacyPolicy() {
        self.openSFSafariForPersonalInformation(_sender: self)
    }
    
    func openSFSafariForPersonalInformation(_sender: Any) {
        guard let url = URL(string: "https://thread-pike-aca.notion.site/4a2cacda469448ba836d9d9d572b1b02") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @objc func signInAnonymousTapped() {
        FirebaseAuthentication.shared.signInWithAnonymous()
        print("DEBUG: anonymous button tapped")
    }
}
