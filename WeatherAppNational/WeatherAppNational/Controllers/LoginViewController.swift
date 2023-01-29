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
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
}


extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
          let userIdentifier = appleIDCredential.user
          let fullName = appleIDCredential.fullName
          let email = appleIDCredential.email
          
        case let passwordCredential as ASPasswordCredential:
          let username = passwordCredential.user
          let password = passwordCredential.password
        
        default:
          break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // error 처리
    }
    
    
}
