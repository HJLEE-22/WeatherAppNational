//
//  LoginView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/28.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginView: UIView {
    
    // MARK: - Properties
    
    private lazy var welcomeMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        let image = UIImage(named: "AppIcon")
        iv.image = image
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)
        return button
    }()
    
    lazy var signInAnonymousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하지 않고 둘러보기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var openPrivacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 취급방침", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        self.backgroundColor = .white
        
        [logoImageView, welcomeMessageLabel, appleLoginButton, signInAnonymousButton, openPrivacyButton].forEach({ self.addSubview($0) })
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        welcomeMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(100)
        }
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self.welcomeMessageLabel).offset(100)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)

        }
        signInAnonymousButton.snp.makeConstraints { make in
            make.top.equalTo(self.appleLoginButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)

        }
        openPrivacyButton.snp.makeConstraints { make in
            make.top.equalTo(signInAnonymousButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(100)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
}
