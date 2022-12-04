//
//  TodayWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

protocol TempDiffrenceDelegate: AnyObject {
    func fetchYesterdayTemp() -> String
}

protocol UpdatingLocationButtonDelegate {
    func updatingLocationButtonTapped()
}

class TodayWeatherView: UIView {
    
    // MARK: - Delegate Property
    
    var buttonDelegate: UpdatingLocationButtonDelegate?
    
    var timeDifferenceDelegate: TempDiffrenceDelegate?
    
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
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var todayDegreeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 80)
        
        
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
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    private lazy var maxLabelForSlider: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var minLabelForSlider: UILabel = {
        let label = UILabel()
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
//        setupDelegate()
        addActionToButton()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupDelegate() {
//        var delegate: TempDiffrenceDelegate?
//    }
    
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
            minLabelForSlider.widthAnchor.constraint(equalToConstant: 50),
            minLabelForSlider.heightAnchor.constraint(equalToConstant: 40),
            
            maxLabelForSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            maxLabelForSlider.widthAnchor.constraint(equalToConstant: 50),
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
        self.todayDegreeLabel.text = "\(data.temperaturePerHour ?? "")°"
//        var temMax = String(format: "%d", data.temperatureMax ?? "")
//        print("DEBUG: temMax: \(temMax)")
//        print("DEBUG: temperatureMax : \(data.temperatureMax)")
        self.maxLabelForSlider.text = "\(data.temperatureMax ?? "")°"
        self.minLabelForSlider.text = "\(data.temperatureMin ?? "")°"
        self.todayDegreeSlider.value = (data.temperaturePerHour as? NSString ?? "0" ).floatValue
        self.windSpeedLabel.text = data.windSpeed ?? ""
        self.nowHumidityLabel.text = data.humidityStatus ?? ""
        self.todayExplanationLabel.text = self.timeDifferenceDelegate?.fetchYesterdayTemp()
        print("DEBUG: fetching yesterday temp \(self.timeDifferenceDelegate?.fetchYesterdayTemp())")
        
        var gradientByTemperature = self.setBackgroundColor(maxTemperature: data.temperatureMax ?? "0", minTemperature: data.temperatureMin ?? "0")
        self.layer.addSublayer(gradientByTemperature)
        gradientByTemperature.frame = self.bounds
        
        
//        self.currentLocationButton.setImage(viewModel.gpsOnButton, for: .normal)
//        print("DEBUG: view model in view exists \(viewModel)")
        addActionToButton()
    }

//    func setTodayExplanationLabel() -> String {
//
//        
//    }

//    var todayDegreenMessage: NSAttributedString {
//        let todayDegree =
//        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
//            attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
//            attributedText.append(NSAttributedString(string: "  2m", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
//            return attributedText
//        }
    
    
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
    
    func setBackgroundColor(maxTemperature: String, minTemperature: String) -> CAGradientLayer {
        let maxColor = switchColorsForBackground(temperature: Int((maxTemperature as NSString).intValue))
        let minColor = switchColorsForBackground(temperature: Int((minTemperature as NSString).intValue))
        let gradient = CAGradientLayer()
        gradient.colors = [maxColor, minColor]
        gradient.locations = [0, 1]
        return gradient
    }
            
    func switchColorsForBackground(temperature: Int) -> UIColor? {
        var choosenColor: UIColor?
        switch temperature {
        case 39...:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor39)
        case 36..<39:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor36)
        case 33..<36:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor33)
        case 30..<33:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor30)
        case 27..<30:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor27)
        case 24..<27:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor24)
        case 21..<24:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor21)
        case 18..<21:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor18)
        case 15..<18:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor15)
        case 12..<15:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor12)
        case 9..<12:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor09)
        case 6..<9:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor06)
        case 3..<6:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor03)
        case 0..<3:
            choosenColor = UIColor(named: ColorsByTemperature.colorFor0)
        case -5..<0:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus5)
        case -10 ..< -5:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus10)
        case -15 ..< -10:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus15)
        case -20 ..< -15:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus20)
        case -25 ..< -20:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus25)
        case -30 ..< -25:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus30)
        case -35 ..< -30:
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus35)
        case -40 ..< -35 :
            choosenColor = UIColor(named: ColorsByTemperature.colorForMinus40)
        default :
            choosenColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
        return choosenColor
    }
                

    
    
    func addActionToButton() {
        self.currentLocationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func locationButtonTapped() {
        buttonDelegate?.updatingLocationButtonTapped()
    }
    
}
    
    

