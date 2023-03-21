//
//  FirstWelcomeView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/03/21.
//

import UIKit


final class FirstWelcomeView: UIView {
    
    // MARK: - Properties
    
    private lazy var mainImageview: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "mainTouchImagePng.001")
        imageView.image = image
        return imageView
    }()
    
    lazy var nextPageButton: TouchableOpacityView = {
        let view = TouchableOpacityView()
        let label = UILabel()
        label.text = "NEXT"
        // second에서는 "시작" 이라고 할가
        label.font.withSize(30)
        label.textColor = .black
        view.addSubview(label)
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
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
        
        [mainImageview, nextPageButton].forEach({ self.addSubview($0) })

        mainImageview.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.center.equalToSuperview()
        }
        
        nextPageButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageview.snp.bottom).offset(20)
            make.center.equalToSuperview()
        }
    }
    
    
    
}
