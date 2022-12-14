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

    var name: String?
    
    var city: LocationGridData? {
        didSet {
            guard let city = city else { return }
            DispatchQueue.main.async {
                self.configureUIByData(city)
            }
            if city.district != "" {
                self.name = city.district
            } else {
                self.name = city.city
            }
        }
    }
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let bookmarkImage = UIImage(systemName: "star")
//        print("DEBUG: button size", bookmarkImage?.size)
        button.setImage(bookmarkImage, for: .normal)
        return button
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
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
        stackView.alignment = .leading
        stackView.spacing = 40
        return stackView
        
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        addActionToButton()
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
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 22),
//            cityLabel.widthAnchor.constraint(equalToConstant: 100),
                        
            cityLabel.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 50)
        ])
    }
    
    func configureUIByData(_ data: LocationGridData) {
        // UI updates 할 것
        self.cityLabel.text = data.city
        self.districtLabel.text = data.district

    }
    
    func addActionToButton() {
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func bookmarkButtonTapped() {
        guard let name = name else { return }
        print("DEBUG: name touched \(name) ")
        cellDelegate?.bookmarkButtonTapped(name)
        if bookmarkButton.image(for: .normal) == UIImage(systemName: ImageSystemNames.star) {
            bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.starFill), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: ImageSystemNames.star), for: .normal)
        }
    }
}
