//
//  CitiesViewCell.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//


import UIKit
import CoreMedia

protocol CellButtonActionDelegate: AnyObject {
    func bookmarkButtonTapped(_ name: String)
}

class CitiesViewCell: UITableViewCell {

    // MARK: - Properties
    
    var cellDelegate: CellButtonActionDelegate?

//    var locationGridModel: LocationGridModel? {
//        didSet {
//            if let locationGridModel = locationGridModel {
//                self.configureUIByData(locationGridModel)
//            }
//        }
//    }
    
    lazy var locationLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
        
    }()
    
   
    
    lazy var descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.text = "어제보다 맑음"
        label.textAlignment = .center
        
        return label
        
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [locationLabel, descriptionLabel])
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    lazy var weatherImageView: UIImageView = {
        let image = UIImage()
        let iv = UIImageView(image: image)
        return iv
        
    }()
    
    lazy var currentDegreeTitle: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "°C"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
        
    }()
    
    lazy var currntStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weatherImageView, currentDegreeTitle])
        sv.axis = .horizontal
        
        return sv
    }()


    
    lazy var maxDegreeLabel: UILabel = {
       
        let label = UILabel()
        label.text = "최고 20°"
        label.textAlignment = .center
        
        return label
        
    }()
    lazy var minDegreeLabel: UILabel = {
       
        let label = UILabel()
        label.text = "최저 8°"
        label.textAlignment = .center

        
        return label
        
    }()
    
    lazy var degreeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [maxDegreeLabel, minDegreeLabel])
        sv.distribution = .fillEqually
        
        return sv
    }()
    
    lazy var rightStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [currntStackView, degreeStackView])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        sv.distribution = .fill
        sv.layer.borderWidth = 1
        sv.layer.borderColor = UIColor.black.cgColor
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 10
        return sv
        
    }()
    
    // MARK: - LifeCycle
    
    // 커스텀 셀 작성시 삽입
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()

//        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        weatherImageView.frame.size = CGSize(width: 100, height: 100)
    }

    
    // MARK: - Actions
    
    @objc func bookmarkButtonTapped() {

    }
    
    // MARK: - Helpers
    
   
    func configureUI() {
        // 테이블뷰에 코드로 ui 작성할 때 contentView 위에다가 놓기.
        
        contentView.addSubview(mainStackView)
//        contentView.addSubview(leftStackView)
//        contentView.addSubview(rightStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
//            leftStackView.topAnchor.constraint(equalTo: self.topAnchor),
//            leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            leftStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftStackView.widthAnchor.constraint(equalToConstant: self.frame.width / 2),
//
            rightStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 10),
//            rightStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -10),
            rightStackView.widthAnchor.constraint(equalToConstant: self.frame.width / 2),
//            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor),
            
            weatherImageView.widthAnchor.constraint(equalToConstant: 80),
            weatherImageView.heightAnchor.constraint(equalToConstant: 80),
            
            contentView.heightAnchor.constraint(equalToConstant: 150)
        ])
        

    }
    
    func configureUIByData(_ data: LocationGridData) {
        // UI updates 할 것
        
        
    }
    

}



