//
//  TomorrowWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

class TomorrowWeatherView: UIView {
    
    // MARK: - Properties
    
//    var weatherModel: WeatherModel? {
//        didSet {
//            if let weatherModel = weatherModel {
//                self.configureUI(weatherModel)
//            }
//        }
//    }
    
    var weatherKitModel: WeatherKitModel? {
        didSet {
            if let weatherKitModel {
                DispatchQueue.main.async {
                    self.configureUI(weatherKitModel)
                }
            }
        }
    }
    
    var backgroundGradientLayer: CAGradientLayer? {
        didSet {
            self.layoutIfNeeded()
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
        let sv = UIStackView(arrangedSubviews: [tomorrowTitleLabel, tomorrowDateLabel, mainTemperatureLabel, tempLabelStackView, weatherImageView])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.setupBackgroundLayer()
        self.setSymbolImageSize()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.setupBackgroundLayer()
//    }
    
//    override func setNeedsLayout() {
//        super.setNeedsLayout()
//        self.setupBackgroundLayer()
//    }
    
    // MARK: - UI setup
    
    func setupBackgroundLayer() {
        DispatchQueue.main.async {
            if let backgroundGradientLayer = self.backgroundGradientLayer {
                if self.bounds != CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0) {
                    print("DEBUG: frame:\(self.frame)")
                    print("DEBUG: bounds:\(self.bounds)")
                    backgroundGradientLayer.frame = self.bounds
                    print("DEBUG: backgroundGrdientFrame:\(backgroundGradientLayer.frame)")
                    self.layer.addSublayer(backgroundGradientLayer)
                    self.setupUI()
                    self.layer.borderWidth = 0
                }
            }
        }
    }
    
    func setupUI() {
        
        self.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
 
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        
            weatherImageView.widthAnchor.constraint(equalToConstant: 130),
            weatherImageView.heightAnchor.constraint(equalToConstant: 130),

        ])
    }
    

    
    func setSymbolImageSize(){
        DispatchQueue.main.async {
            if self.frame.height <= 250 {
                self.weatherImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
                self.weatherImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            }
        }
    }
    
    // MARK: - Helpers
    /*
    func configureUI(_ data: WeatherModel) {
//        self.weatherImageView.image = setWeatherImage(data.rainingStatus ?? "", data.skyStatus ?? "")
        self.setWeatherImageView(data.rainingStatus ?? "", data.skyStatus ?? "")

        self.mainTemperatureLabel.text = "\(data.temperaturePerHour ?? "")°"
        self.maxTemperatureLabel.text = data.temperatureMax ?? "" + "°"
        self.minTemperatureLabel.text = data.temperatureMin ?? "" + "°"
//        self.currentLocationButton.setImage(viewModel.gpsOnButton, for: .normal)
//        print("DEBUG: view model in view exists \(viewModel)")
        self.tomorrowDateLabel.text = DateCalculate.tomorrowDateShortString + "일"
    }
    */
    func configureUI(_ data: WeatherKitModel) {
        self.weatherImageView.image = UIImage(systemName: data.symbolName ?? "")
        self.mainTemperatureLabel.text = "\(data.temperature ?? "")°"
        self.maxTemperatureLabel.text = data.highTemperature ?? "" + "°"
        self.minTemperatureLabel.text = data.lowTemperature ?? "" + "°"
        self.tomorrowDateLabel.text = DateCalculate.tomorrowDateShortString + "일"
        self.weatherImageView.tintColor = .systemGray3
    }
/*
    func setWeatherImageView(_ rainStatusCategory: String, _ skyCategory: String){
        if rainStatusCategory == "0" {
            if let skyStatusCategory = SkyCategory.allCases.first(where: {$0.rawValue == skyCategory}) {
                switch skyStatusCategory {
                case .sunny :
                    guard let image = UIImage(systemName: WeatherSystemName.sunMax) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .cloudy :
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSun) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .gray :
                    guard let image = UIImage(systemName: WeatherSystemName.cloud) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                }
            }
        } else {
            if let rainStatusCategory = RainStatusCategory.allCases.first(where: {$0.rawValue == rainStatusCategory}) {
                switch rainStatusCategory {
                case .raining:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudRain) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .rainingAndSnowing:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSleet) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .snowing:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSnow) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .showering:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudHeavyRain) else { return }
                    self.weatherImageView.image = image
                    weatherImageView.tintColor = .systemGray3
                case .noRain:
                    break
                }
            }
        }
    }
 */
}
