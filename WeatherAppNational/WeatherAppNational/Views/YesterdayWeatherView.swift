//
//  YesterdayWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

class YesterdayWeatherView: UIView {
    
    // MARK: - Properties
    
    private lazy var yesterdayTitle: UILabel = {
       let label = UILabel()
        label.text = "어제"
        return label
    }()
    
    private lazy var yesterdayLabel: UILabel = {
       let label = UILabel()
        label.text = "(17일)"
        return label
    }()
    
    private lazy var dayLabelStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [yesterdayTitle, yesterdayLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 10
        return sv
        
    }()
    
    private lazy var mainTemperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "10°"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "7°"
        return label
    }()
    
    private lazy var spaceForTemperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "/"
        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "19°"
        return label
    }()
    
    private lazy var tempLabelStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minTemperatureLabel, spaceForTemperatureLabel, maxTemperatureLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 10
        return sv

    }()
    
    private lazy var weatherImageView : UIImageView = {
        let image = UIImage(systemName: "cloud")
        let imageView = UIImageView(image: image)
        return imageView
        
    }()
    
    private lazy var emptyView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var mainStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dayLabelStackView, mainTemperatureLabel, tempLabelStackView, weatherImageView, emptyView])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 10
        return sv
        
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    
    func setupUI() {
        
        self.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        
            weatherImageView.widthAnchor.constraint(equalToConstant: 130)
            
        ])
        
        
    }
    
    
}
