//
//  SettingViewCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit
import SnapKit

protocol SwitchButtonDelegate: AnyObject {
    func gpsSwitchTapped()
}

class SettingViewCell: UITableViewCell {
    
    // MARK: - Properties
        
    var cellDelegate: SwitchButtonDelegate?
    
    lazy var mainLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    lazy var switchBtn: UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.isHidden = true
        return switchBtn
    }()
    
    lazy var logoutView: TouchableOpacityView = {
        let view = TouchableOpacityView(frame: .zero)
        let label = UILabel()
        label.text = "Log out"
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        view.addSubview(label)
        view.isHidden = true
        return view
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIbySnapChat()
        // 스위치 작동 액션을 VC 파일이 아닌 cell 파일에 주는게 맞을까?
        switchBtn.addTarget(self, action: #selector(gpsSwitchTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    @objc func gpsSwitchTapped() {
        cellDelegate?.gpsSwitchTapped()
    }
    
    func setupUIbySnapChat() {
        
        [mainLabel, switchBtn, logoutView].forEach({ self.contentView.addSubview($0) })

        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        switchBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        logoutView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
