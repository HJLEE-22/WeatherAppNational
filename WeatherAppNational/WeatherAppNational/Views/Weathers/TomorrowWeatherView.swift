//
//  TomorrowWeatherView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//

import UIKit

class TomorrowWeatherView: UIView {
    
    // MARK: - Properties
    
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
    
    func configureUI(_ data: WeatherKitModel) {
        self.weatherImageView.image = UIImage(systemName: data.symbolName ?? "")
        self.mainTemperatureLabel.text = "\(data.temperature ?? "")°"
        self.maxTemperatureLabel.text = data.highTemperature ?? "" + "°"
        self.minTemperatureLabel.text = data.lowTemperature ?? "" + "°"
        self.tomorrowDateLabel.text = DateCalculate.tomorrowDateShortString + "일"
        self.weatherImageView.tintColor = .systemGray3
    }

}
