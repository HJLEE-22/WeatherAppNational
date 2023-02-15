//
//  AppController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/30.
//

// login/logout 화면 전환을 위한 컨트롤러

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

extension Notification.Name {
    static let authStateDidChange = NSNotification.Name("authStateDidChange")
}

final class ViewByLoginManager {
    
    static let shared = ViewByLoginManager()
    
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        checkLoginIn()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        
        if let user = Auth.auth().currentUser { // <- Firebase Auth
            if user.isAnonymous == true {
                self.setHome()
            } else {
                let uid = user.uid
                COLLECTION_USERS.document(uid).getDocument { document, error in
                    guard let document else { return }
                    if document.exists {
                        self.setHome()
                    } else {
                        self.setLoginInfoView()
                    }
                }
            }
        } else {
            setLoginView()
        }
    }
    
    private func setHome() {
        let homeVC = MainPageViewController()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    private func setLoginView() {
        let loginVC = LoginViewController()
        rootViewController = UINavigationController(rootViewController: loginVC)
    }
    
    private func setLoginInfoView() {
        let loginInfoVC = LoginInfoViewController()
        rootViewController = UINavigationController(rootViewController: loginInfoVC)
    }
    
}
