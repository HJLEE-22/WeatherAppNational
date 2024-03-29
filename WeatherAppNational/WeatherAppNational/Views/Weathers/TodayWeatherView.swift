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

final class TodayWeatherView: UIView {
    
    // MARK: - Delegate Property
    
    var buttonDelegate: UpdatingLocationButtonDelegate?
    
    // MARK: - Today's properties
    
    // MARK:  Models
    
    var weatherKitModel: WeatherKitModel?
    
    var backgroundGradientLayer: CAGradientLayer? {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var yesterdayDegree: String? {
        didSet {
            if let yesterdayDegree,
               let weatherKitModel {
                DispatchQueue.main.async {
                    self.configureUIByData(weatherKitModel)
                }
            }
        }
    }
    // MARK:  Properties for UI
    
    var imageViewforTouch: TouchableOpacityView = {
        let view = TouchableOpacityView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var todayWeatherImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var todayDegreeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 60)
        return label
    }()
    
    private lazy var imageAndDegreeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [todayWeatherImageView, todayDegreeLabel])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var todayDegreeSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .clear
        slider.isUserInteractionEnabled = false
        slider.tintColor = .systemGray2
        return slider
    }()
    
    private lazy var maxLabelForSlider: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var minLabelForSlider: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var sliderStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minLabelForSlider, todayDegreeSlider, maxLabelForSlider])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    lazy var todayExplanationLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nowHumidityTitle: UILabel = {
        let label = UILabel()
        label.text = " 습도: "
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
        sv.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return sv
    }()
    
    private lazy var windSpeedTitle: UILabel = {
        let label = UILabel()
        label.text = " 풍속: "
        return label
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        return label
        
    }()
    
    private lazy var WindSpeedStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [windSpeedTitle, windSpeedLabel])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.layer.borderWidth = 1
        sv.layer.cornerRadius = 5
        sv.layer.borderColor = UIColor(white: 1, alpha: 0).cgColor
        sv.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return sv
    }()
    
    private lazy var humadityAndWindSpeedStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [humadityStackView, WindSpeedStackView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    private lazy var todayStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageAndDegreeStackView, sliderStackView, todayExplanationLabel, humadityAndWindSpeedStackView ])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    private lazy var updateLocationButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: SystemIconNames.update), for: .normal)
        btn.tintColor = .systemGray2
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        LoadingIndicator.showLoading()
        self.addActionToButton()
        DispatchQueue.main.async { [weak self] in
            self?.setupUIOnlyForButton()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.setNeedsLayout()
        self.setupBackgroundLayer()
        self.setupTodayExplanationSize()
    }
    
    // MARK: - UI setup
    
    
    private func setupBackgroundLayer() {
        DispatchQueue.main.async { [weak self] in
            if let backgroundGradientLayer = self?.backgroundGradientLayer {
                if self?.bounds != CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0) {
                    guard let self else { return }
                    backgroundGradientLayer.frame = self.bounds
                    self.layer.addSublayer(backgroundGradientLayer)
                    self.setupUI()
                }
            }
        }
    }
    
    private func setupTodayExplanationSize() {
        DispatchQueue.main.async {
            if self.frame.width < 330 {
                self.todayExplanationLabel.font = .systemFont(ofSize: 15)
                self.todayExplanationLabel.textAlignment = .center
            }
        }
    }
    
    private func setupUI() {
        self.addSubview(todayStackView)
        self.addSubview(updateLocationButton)
        self.addSubview(imageViewforTouch)
        
        imageViewforTouch.translatesAutoresizingMaskIntoConstraints = false
        
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
        humadityAndWindSpeedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        todayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        updateLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageViewforTouch.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewforTouch.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewforTouch.topAnchor.constraint(equalTo: self.updateLocationButton.bottomAnchor, constant: 10),
            imageViewforTouch.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
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
            sliderStackView.heightAnchor.constraint(equalToConstant: 20),
            
            todayDegreeSlider.heightAnchor.constraint(equalToConstant: 5),
            
            minLabelForSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            minLabelForSlider.widthAnchor.constraint(equalToConstant: 60),
            minLabelForSlider.heightAnchor.constraint(equalToConstant: 40),
            
            maxLabelForSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            maxLabelForSlider.widthAnchor.constraint(equalToConstant: 60),
            maxLabelForSlider.heightAnchor.constraint(equalToConstant: 40),
            
            todayExplanationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            todayExplanationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            humadityAndWindSpeedStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            humadityAndWindSpeedStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            humadityAndWindSpeedStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            
            updateLocationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            updateLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupUIOnlyForButton() {
        self.addSubview(updateLocationButton)
        updateLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateLocationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            updateLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureUIByData(_ data: WeatherKitModel) {
        if let symbolName = data.symbolName {
            self.todayWeatherImageView.image = UIImage(systemName: symbolName)
            self.setWeatherImageColor(data.symbolName)
        } else {
            self.setWeatherImage(data.rainingStatus ?? "", data.skyStatus ?? "")
        }
        self.todayDegreeLabel.text = "\(data.temperature ?? "")°"
        self.maxLabelForSlider.text = "\(data.highTemperature ?? "")°"
        self.minLabelForSlider.text = "\(data.lowTemperature ?? "")°"
        self.todayDegreeSlider.maximumValue = (data.highTemperature as? NSString ?? "0" ).floatValue
        self.todayDegreeSlider.minimumValue = (data.lowTemperature as? NSString ?? "0" ).floatValue
        self.todayDegreeSlider.value = (data.temperature as? NSString ?? "0" ).floatValue
        self.windSpeedLabel.text = data.windSpeed ?? ""
        if (Float(data.humidity ?? "0") ?? 0) < 1 {
            self.nowHumidityLabel.text = String(Int((Float(data.humidity ?? "0") ?? 0) * 100)) + " %"
        } else {
            self.nowHumidityLabel.text = String(Int(Float(data.humidity ?? "0") ?? 0)) + " %"
        }
        self.todayExplanationLabel.text = self.calculateDegreeExplanation(data)
        self.addActionToButton()
    }
    
    private func calculateDegreeExplanation(_ data: WeatherKitModel) -> String {
        
        guard let yesterdayDegreeString = yesterdayDegree,
              let todayDegreeString = data.temperature else { return "" }
        let todayDegree = (todayDegreeString as NSString).intValue
        let yesterdayDegree = (yesterdayDegreeString as NSString).intValue
        
        switch todayDegree {
        case ..<15:
            if todayDegree > yesterdayDegree {
                return "오늘이 어제보다 \(todayDegree - yesterdayDegree)° 더 따뜻합니다."
            } else if todayDegree < yesterdayDegree {
                return "오늘이 어제보다 \(yesterdayDegree - todayDegree)° 더 춥습니다."
            } else {
                return "오늘은 어제 날씨와 비슷합니다."
            }
        case 15...:
            if todayDegree > yesterdayDegree {
                return "오늘이 어제보다 \(todayDegree - yesterdayDegree)° 더 덥습니다."
            } else if todayDegree < yesterdayDegree {
                return "오늘이 어제보다 \(yesterdayDegree - todayDegree)° 더 시원합니다."
            } else {
                return "오늘은 어제 날씨와 비슷합니다."
            }
        default:
            break
        }
        return ""
    }
    
    private func setWeatherImageColor(_ symbolName: String?) {
        
        guard let symbolName else { return }
        if symbolName.contains("sun") && symbolName.contains("cloud") {
            todayWeatherImageView.tintColor = .systemOrange
        } else if symbolName.contains("cloud") && symbolName.contains("rain") {
            todayWeatherImageView.tintColor = .systemMint
        } else if symbolName.contains("cloud") && symbolName.contains("snow") {
            todayWeatherImageView.tintColor = .systemCyan
        } else if symbolName.contains("rain") {
            todayWeatherImageView.tintColor = .systemBlue
        } else if symbolName.contains("snow") {
            todayWeatherImageView.tintColor = .white
        } else if symbolName.contains("cloud") {
            todayWeatherImageView.tintColor = .systemGray2
        } else if symbolName.contains("sun") {
            todayWeatherImageView.tintColor = .systemRed
        } else {
            todayWeatherImageView.tintColor = .systemGray2
        }
    }
    
    func setWeatherImage(_ rainStatusCategory: String, _ skyCategory: String){
        if rainStatusCategory == "0" {
            if let skyStatusCategory = SkyCategory.allCases.first(where: {$0.rawValue == skyCategory}) {
                switch skyStatusCategory {
                case .sunny :
                    guard let image = UIImage(systemName: WeatherSystemName.sunMax) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemRed
                case .cloudy :
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSun) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemOrange
                case .gray :
                    guard let image = UIImage(systemName: WeatherSystemName.cloud) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemGray
                }
            }
        } else {
            if let rainStatusCategory = RainStatusCategory.allCases.first(where: {$0.rawValue == rainStatusCategory}) {
                switch rainStatusCategory {
                case .raining:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudRain) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemGray3
                case .rainingAndSnowing:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSleet) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemGray2
                case .snowing:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudSnow) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .white
                case .showering:
                    guard let image = UIImage(systemName: WeatherSystemName.cloudHeavyRain) else { return }
                    self.todayWeatherImageView.image = image
                    todayWeatherImageView.tintColor = .systemBlue
                case .noRain:
                    break
                }
            }
        }
    }
    
    private func addActionToButton() {
        self.updateLocationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func locationButtonTapped() {
        buttonDelegate?.updatingLocationButtonTapped()

    }
    
}



