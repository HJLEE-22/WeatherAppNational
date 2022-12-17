//
//  TomorrowWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

class TomorrowWeatherView: UIView {
    
    // MARK: - Properties
    
    var weatherModel: WeatherModel? {
        didSet {
            if let weatherModel = weatherModel {
                self.configureUI(weatherModel)
            }
        }
    }
    
    private lazy var tomorrowTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "내일"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private lazy var tomorrowDateLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var dayLabelStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tomorrowTitleLabel, tomorrowDateLabel])
        sv.axis = .vertical
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
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    private lazy var emptyView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var mainStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dayLabelStackView, mainTemperatureLabel, tempLabelStackView, weatherImageView])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
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
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
        
            weatherImageView.widthAnchor.constraint(equalToConstant: 130),
            weatherImageView.heightAnchor.constraint(equalToConstant: 130),

        ])
        
        
    }
    
    // MARK: - Helpers
    
    func configureUI(_ data: WeatherModel) {
        self.weatherImageView.image = setWeatherImage(data.rainingStatus ?? "", data.skyStatus ?? "")
        self.mainTemperatureLabel.text = "\(data.temperaturePerHour ?? "")°C"
        self.maxTemperatureLabel.text = data.temperatureMax ?? "" + "°"
        self.minTemperatureLabel.text = data.temperatureMin ?? "" + "°"
//        self.currentLocationButton.setImage(viewModel.gpsOnButton, for: .normal)
//        print("DEBUG: view model in view exists \(viewModel)")
        self.tomorrowDateLabel.text = DateCalculate.tomorrowDateShortString + "일"
    }

    func setWeatherImage(_ rainStatusCategory: String, _ skyCategory: String) -> UIImage {
        
        if rainStatusCategory == "0" {
            if let skyStatusCategory = SkyCategory.allCases.first(where: {$0.rawValue == skyCategory}) {
                switch skyStatusCategory {
                case .sunny :
                    return UIImage(systemName: WeatherSystemName.sunMax)!
                case .cloudy :
                    return UIImage(systemName: WeatherSystemName.cloudSun)!
                case .gray :
                    return UIImage(systemName: WeatherSystemName.cloud)!
                }
            }
        } else {
                if let rainStatusCategory = RainStatusCategory.allCases.first(where: {$0.rawValue == rainStatusCategory}) {
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
