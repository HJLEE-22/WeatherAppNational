//
//  ProfileForSettingVCCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/31.
//

import UIKit
import SnapKit

class ProfileCell: UITableViewCell {
    
    // MARK: - Properties

    var user: UserModel? {
        didSet {
            guard let user else { return }
            DispatchQueue.main.async {
                self.setupByUser(user: user)
            }
            print("DEBUG: user info success :\(user)")
        }
    }
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
//        label.text = "닉네임"
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
//        label.text = "email@icloud.com"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - Lifecylces
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        
        [nicknameLabel, emailLabel].forEach({ self.addSubview($0) })

        self.nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        self.emailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func setupByUser(user: UserModel){
        self.nicknameLabel.text = user.name
        self.emailLabel.text = user.email
    }
}
