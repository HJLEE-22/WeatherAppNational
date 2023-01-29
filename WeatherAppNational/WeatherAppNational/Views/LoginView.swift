//
//  LoginView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/28.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginView: UIView {
    
    // MARK: - Properties
    
    lazy var welcomeMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)
        return button
    }()
    
    lazy var openPrivacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보취급방침", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
    
    func setupUI() {
        
        self.backgroundColor = .white
        
        [welcomeMessageLabel, appleLoginButton, openPrivacyButton].forEach({ self.addSubview($0) })
        
        welcomeMessageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(300)
            make.left.right.equalToSuperview().inset(100)
        }
 
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(self.welcomeMessageLabel).offset(100)
            make.left.right.equalToSuperview().inset(100)

//            make.width.equalTo(100)
//            make.height.equalTo(20)
        }
        
        openPrivacyButton.snp.makeConstraints { make in
            make.top.equalTo(self.appleLoginButton).offset(50)
            make.left.right.equalToSuperview().inset(100)
            
            make.width.equalTo(100)
            make.height.equalTo(20)
            
        }
        
    }
    

    
}
