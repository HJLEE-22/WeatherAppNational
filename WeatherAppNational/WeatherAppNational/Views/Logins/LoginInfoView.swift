//
//  LoginNameInputView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/02/01.
//

import UIKit

class LoginInfoView: UIView {
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 닉네임과\n 이메일을 입력해주세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "닉네임을 입력하세요"
        return tf
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력하세요"
//        if let uid = FirebaseAuthentication.shared.uid,
//           let email = COLLECTION_USERS.document(uid).value(forKey: "email") as? String {
//            tf.text = email
//        }
        return tf
    }()
    
    lazy var moveToMainButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupEmailTextfield()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setupUI(){
        [welcomeLabel, nicknameTextField, emailTextField, moveToMainButton].forEach({ self.addSubview($0) })
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.right.equalToSuperview().inset(20)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(70)
            make.left.right.equalToSuperview().inset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        moveToMainButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func setupEmailTextfield() {
        guard let email = FirebaseAuthentication.shared.email else { return }
             // let email = COLLECTION_USERS.document(uid).value(forKey: "email") as? String else { return }
        DispatchQueue.main.async {
            self.emailTextField.text = email
        }
    }
}

