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
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var spaceForTemperatureLabel: UILabel = {
       let label = UILabel()
        label.text = "/"
        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
       let label = UILabel()
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
        let imageView = UIImageView()
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
    
    var weatherModel: WeatherModel? {
        didSet {
            if let weatherModel = weatherModel {
                self.configureUI(weatherModel)
            }
        }
    }
    
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
    
    func configureUI(_ data: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherImageView.image = self?.setWeatherImage(data.rainingStatus ?? "", data.skyStatus ?? "")
            self?.mainTemperatureLabel.text = "\(data.temperaturePerHour ?? "") °C"
            self?.maxTemperatureLabel.text = data.temperatureMax
            self?.minTemperatureLabel.text = data.temperatureMin
        }
    }
     
    func setWeatherImage(_ rainStatusCategory: String, _ skyStatusCategory: String) -> UIImage {
        if rainStatusCategory == "0" {
            if let skyStatusCategory = SkyCategory.allCases.first(where: { $0.rawValue == skyStatusCategory }) {
                switch skyStatusCategory {
                case .sunny:
                    return UIImage(systemName: WeatherSystemName.sunMax)!
                case .cloudy:
                    return UIImage(systemName: WeatherSystemName.cloudSun)!
                case .gray:
                    return UIImage(systemName: WeatherSystemName.cloud)!
                }
            }
        } else {
            if let rainStatusCategory = RainStatusCategory.allCases.first(where: { $0.rawValue == rainStatusCategory }) {
                switch rainStatusCategory {
                case .raining:
                    return UIImage(systemName: WeatherSystemName.cloudRain)!
                case .rainingAndSnowing:
                    return UIImage(systemName: WeatherSystemName.cloudSleet)!
                case .snowing:
                    return UIImage(systemName: WeatherSystemName.cloudSnow)!
                case .showering:
                    return UIImage(systemName: WeatherSystemName.cloudHeavyRain)!
                case .noRain:
                    break
                }
            }
        }
        
        return UIImage()
    }
}
