//
//  LoginNameInputView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/02/01.
//

import UIKit

final class LoginInfoView: UIView {
    
    private lazy var welcomeLabel: UILabel = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupUI(){
        [welcomeLabel, nicknameTextField, moveToMainButton].forEach({ self.addSubview($0) })
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.left.right.equalToSuperview().inset(20)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        moveToMainButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
}

