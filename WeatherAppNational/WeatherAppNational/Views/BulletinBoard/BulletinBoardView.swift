//
//  BulletionBoardView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/17.
//

import UIKit
import SnapKit

class BulletinBoardView: UIView {
    
    // MARK: - Properties
    
        // MARK:  UIs
    private lazy var typingTextField: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("입력", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var typingView: UIView = {
        let view = UIView()
        view.addSubview(typingTextField)
        view.addSubview(returnButton)
        view.backgroundColor = .systemGray5
        return view
    }()
    
    var chattingsTableView: UITableView = {
        let tv = UITableView()
        tv.isUserInteractionEnabled = false
        return tv
    }()
    

    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // MARK: - Helpers
    
    func setupView() {
        [typingView, chattingsTableView].forEach({ self.addSubview($0)})
        
        self.chattingsTableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.typingView.snp.top)
        }
        
        self.typingView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self)
            make.top.equalTo(self.chattingsTableView.snp.bottom)
            make.height.equalTo(90)
        }
        
        self.typingTextField.snp.makeConstraints { make in
            make.top.equalTo(self.typingView).inset(5)
            make.left.equalTo(self.typingView).inset(10)
            make.right.equalTo(self.returnButton.snp_leftMargin).offset(-15)
            make.height.equalTo(40)
        }
        self.returnButton.snp.makeConstraints { make in
            make.top.equalTo(self.typingView).inset(5)
            make.right.equalTo(self.typingView).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
    }
}

