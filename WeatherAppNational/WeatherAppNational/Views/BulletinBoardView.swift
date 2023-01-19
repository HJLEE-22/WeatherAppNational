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
    
    private lazy var typingTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private lazy var typingStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [typingTextField])
        return sv
    }()
    
    var chattingsTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemPink
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
        [typingStackView, chattingsTableView].forEach({ self.addSubview($0)})
        
        self.chattingsTableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(self.typingStackView)
        }
        
        self.typingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.chattingsTableView)
            make.width.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    
    
    
}
