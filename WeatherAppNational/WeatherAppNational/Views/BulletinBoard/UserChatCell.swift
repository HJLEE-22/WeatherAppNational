//
//  UserChatCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2023/01/22.
//

import UIKit
import SnapKit

class UserChatCell: UITableViewCell {

    // MARK: - Properties
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        label.snp.contentHuggingVerticalPriority = 1000
        return label
    }()
    
    lazy var emptyViewForIdLabelSize: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var idLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [idLabel, emptyViewForIdLabelSize])
        return stackView
    }()
    
    lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var emptyViewForSizeLeft: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var emptyViewForSizeRight: UIView = {
        let view = UIView()
        return view
    }()

    lazy var emptyViewForSize: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var chatLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyViewForSizeLeft, chatLabel, emptyViewForSizeRight])
//        stackView.snp.contentHuggingVerticalPriority = 250
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        stackView.backgroundColor = .systemGray2
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.clear.cgColor
        return stackView
    }()
    
    lazy var stackViewForMessageSize: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyViewForSize, chatLabelStackView])
        stackView.snp.contentHuggingVerticalPriority = 250
        return stackView
    }()
    
    lazy var emptyViewForMainStackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var idAndChatStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyViewForMainStackView ,idLabelStackView, stackViewForMessageSize])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCellLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setCellLayouts() {
        [timeLabel, idAndChatStackView].forEach({ self.contentView.addSubview($0) })
        
        self.idAndChatStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.timeLabel.snp.right).offset(10)
        }
        
        self.timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel)
            make.left.equalToSuperview()
            make.width.equalTo(60)
        }
        
        self.emptyViewForSizeLeft.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        self.emptyViewForSizeRight.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        self.emptyViewForIdLabelSize.snp.makeConstraints { make in
            make.width.equalTo(16)
        }
        
        self.emptyViewForMainStackView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        
        self.chatLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
}
