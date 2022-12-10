//
//  CitiesListViewCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/06.
//

import UIKit


class CitiesListViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var cellDelegate: CellButtonActionDelegate?
    
//    var locationGridModel: LocationGridModel? {
//        didSet {
//            if let locationGridModel = locationGridModel {
//                self.configureUIByData(locationGridModel)
//            }
//        }
//    }
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        let bookmarkImage = UIImage(systemName: "star")
        button.setImage(bookmarkImage, for: .normal)
        return button
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var districtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookmarkButton, cityLabel, districtLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
        
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureUI
    
    func configureUI() {
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        districtLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                        
        ])
    }
    
    func configureUIByData(_ data: LocationGridData) {
        // UI updates 할 것
        self.cityLabel.text = data.city
        self.districtLabel.text = data.district

    }
    
    
    
}
