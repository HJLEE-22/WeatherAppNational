//
//  SettingViewCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

class SettingViewCell: UITableViewCell {
    
    // MARK: - Properties
    
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    func setupUI() {
        addSubview(mainLabel)
        addSubview(switchBtn)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            mainLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainLabel.trailingAnchor.constraint(equalTo: switchBtn.leadingAnchor, constant: 10),
            
//            switchBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            switchBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            switchBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
        ])
       
    }
    
}
