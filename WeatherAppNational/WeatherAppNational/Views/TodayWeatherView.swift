//
//  TodayWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

protocol UpdatingLocationButtonDelegate {
    func updatingLocationButtonTapped()
}

class TodayWeatherView: UIView {
    
    // MARK: - Delegate Property
    
    var buttonDelegate: UpdatingLocationButtonDelegate?
    
    // MARK: - Today's properties
    
    var weatherModel: WeatherModel? {
        didSet {
            if let weatherModel = weatherModel {
                self.configureUI(weatherModel)
            }
        }
    }
    
    // 이미지와 온도 스택
    private lazy var todayWeatherImageView: UIImageView = {
        let image = UIImage(systemName: "sun.max")
        let imageView = UIImageView(image: image)

        return imageView
    }()
    
    private lazy var todayDegreeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 50)
        
        
        return label
    }()
    
    private lazy var imageAndDegreeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [todayWeatherImageView, todayDegreeLabel])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        
        return sv
    }()
    

    
    // 온도 슬라이더 스택
    private lazy var todayDegreeSlider: UISlider = {
        let slider = UISlider()
        
        // 맥스와 미니멈 밸류는 오늘 최고/최저 기온으로 변경할 것
        
        slider.maximumValue = 50
        slider.minimumValue = -50
        slider.thumbTintColor = .clear
//        slider.widthAnchor.constraint(equalToConstant: self.frame.width / 2)
        return slider
    }()
    
    private lazy var maxLabelForSlider: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var minLabelForSlider: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var sliderStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minLabelForSlider, todayDegreeSlider, maxLabelForSlider])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 20
        return sv
    }()
    
    
    // 날씨 설명 스택
    
    private lazy var todayExplanationLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다 -2° 추워요"
        label.textAlignment = .left
        
        return label
    }()
    
    
    //현재습도와 체감기온 스택
    private lazy var nowHumidityTitle: UILabel = {
        let label = UILabel()
        label.text = " 현재습도: "
        return label
    }()
    
    private lazy var nowHumidityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var humadityStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nowHumidityTitle, nowHumidityLabel])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.layer.borderWidth = 1
        sv.layer.cornerRadius = 5
        sv.layer.borderColor = UIColor(white: 1, alpha: 0).cgColor
        sv.backgroundColor = .systemBlue
        
        
        return sv
    }()
    
    
    private lazy var windSpeedTitle: UILabel = {
        let label = UILabel()
        label.text = " 바람속도: "
        
        return label
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        return label
        
    }()
    
    private lazy var feelingStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [windSpeedTitle, windSpeedLabel])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.layer.borderWidth = 1
        sv.layer.cornerRadius = 5
        sv.layer.borderColor = UIColor(white: 1, alpha: 0).cgColor
        sv.backgroundColor = .systemBlue
        return sv
    }()
    
    private lazy var humadityAndTemperatureStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [humadityStackView, feelingStackView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    
    
    // 메인스택
    private lazy var todayStackView: UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [imageAndDegreeStackView, sliderStackView, todayExplanationLabel, humadityAndTemperatureStackView ])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.spacing = 10
        
        return sv
        
    }()
    
    private lazy var currentLocationButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "location"), for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addActionToButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI setup from ViewModel
    
    func setupUI() {
        self.addSubview(todayStackView)
        self.addSubview(currentLocationButton)
        
        todayWeatherImageView.translatesAutoresizingMaskIntoConstraints = false
        todayDegreeLabel.translatesAutoresizingMaskIntoConstraints = false
        imageAndDegreeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        maxLabelForSlider.translatesAutoresizingMaskIntoConstraints = false
        minLabelForSlider.translatesAutoresizingMaskIntoConstraints = false
        todayDegreeSlider.translatesAutoresizingMaskIntoConstraints = false
        sliderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        todayExplanationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nowHumidityTitle.translatesAutoresizingMaskIntoConstraints = false
        nowHumidityLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedTitle.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        humadityAndTemperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        
        todayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            todayStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            todayStackView.topAnchor.constraint(equalTo: self.topAnchor),
            todayStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageAndDegreeStackView.heightAnchor.constraint(equalToConstant: 150),
            imageAndDegreeStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            imageAndDegreeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageAndDegreeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            sliderStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sliderStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            sliderStackView.topAnchor.constraint(equalTo: imageAndDegreeStackView.bottomAnchor, constant: 30),
            sliderStackView.heightAnchor.constraint(equalToConstant: 20),
            
            todayDegreeSlider.heightAnchor.constraint(equalToConstant: 5),
            
            minLabelForSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            minLabelForSlider.widthAnchor.constraint(equalToConstant: 40),
            minLabelForSlider.heightAnchor.constraint(equalToConstant: 40),
            
            maxLabelForSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            maxLabelForSlider.widthAnchor.constraint(equalToConstant: 40),
            maxLabelForSlider.heightAnchor.constraint(equalToConstant: 40),
            
            todayExplanationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            todayExplanationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            humadityAndTemperatureStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            humadityAndTemperatureStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            humadityAndTemperatureStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            
            currentLocationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            currentLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)

        ])
        
    }
    
    func configureUI(_ data: WeatherModel) {
        self.todayWeatherImageView.image = setWeatherImage(data.rainingStatus ?? "", data.skyStatus ?? "")
        self.todayDegreeLabel.text = "\(data.temperaturePerHour ?? "") °C"
        self.maxLabelForSlider.text = data.temperatureMax ?? "" + "°"
        self.minLabelForSlider.text = data.temperatureMin ?? "" + "°"
        self.windSpeedLabel.text = data.windSpeed ?? ""
        self.nowHumidityLabel.text = data.humidityStatus ?? ""
//        self.currentLocationButton.setImage(viewModel.gpsOnButton, for: .normal)
//        print("DEBUG: view model in view exists \(viewModel)")
        addActionToButton()
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
        }
        return UIImage()
    }
    
    func addActionToButton() {
        self.currentLocationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func locationButtonTapped() {
        buttonDelegate?.updatingLocationButtonTapped()
    }
    
}
    
    

