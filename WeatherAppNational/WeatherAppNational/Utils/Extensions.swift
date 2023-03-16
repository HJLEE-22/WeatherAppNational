//
//  Extensions.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/15.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String, _ okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "취소", style: .cancel))
        if let okAction {
            let ok = UIAlertAction(title: "확인", style: .default){ _ in
                okAction()
            }
            alertVC.addAction(ok)
        }
        present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    func setLoginViewAnywhere() {
        let loginVC = LoginViewController()
        loginVC.loginView.signInAnonymousButton.isHidden = true
        show(loginVC, sender: nil)
    }
}
