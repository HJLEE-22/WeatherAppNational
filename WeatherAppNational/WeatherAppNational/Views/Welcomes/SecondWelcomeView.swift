//
//  SecondWelcomeView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit

final class SecondWelcomeView: UIView {
    
    // MARK: - Properties
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "contextMenuImagePng.001")
        imageView.image = image
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var explainationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.text = "채팅을 길게 눌러\n추가메뉴를 실행할 수 있습니다."
        return label
    }()
    
    lazy var nextPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 30)
        button.setTitleColor(ColorForDarkMode.getNavigationItemColor(), for: .normal)
        button.backgroundColor = ColorForDarkMode.getSystemGray5Color()
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setUI() {
        
        [mainImageView, explainationLabel, nextPageButton].forEach({ self.addSubview($0) })
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(200)
        }
        
        explainationLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        nextPageButton.snp.makeConstraints { make in
            make.top.equalTo(explainationLabel.snp.bottom).offset(30)
            make.leading.equalTo(mainImageView.snp.leading).inset(20)
            make.trailing.equalTo(mainImageView.snp.trailing).inset(20)
        }
    }
}
