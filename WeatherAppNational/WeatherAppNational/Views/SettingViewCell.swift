//
//  SettingViewCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit
import CoreLocation

protocol SwitchButtonDelegate: AnyObject {
    func gpsSwitchTapped()
}

class SettingViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var locationManager = CLLocationManager()
    
    var cellDelegate: SwitchButtonDelegate?
    
    lazy var mainLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var switchBtn: UISwitch = {
       let switchBtn = UISwitch()
    
        
        return switchBtn
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
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
    
    func setupUI() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(switchBtn)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            mainLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainLabel.trailingAnchor.constraint(equalTo: switchBtn.leadingAnchor, constant: 10),
            
//            switchBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            switchBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            switchBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
        ])
       
    }
    
}
