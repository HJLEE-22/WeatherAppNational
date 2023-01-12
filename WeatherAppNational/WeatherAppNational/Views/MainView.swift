//
//  MainView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/17.
//
import UIKit

class MainView: UIView {
    
    
    // MARK: - Properties
 
    lazy var todayWeatherView: TodayWeatherView =  {
        let view = TodayWeatherView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "blue")?.cgColor
        view.layer.cornerRadius = 10
        
        view.clipsToBounds = true
        return view
    }()
    
    lazy var yesterdayWeatherView: YesterdayWeatherView =  {
        let view = YesterdayWeatherView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "black")?.cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var tomorrowdayWeatherView: TomorrowWeatherView =  {
        let view = TomorrowWeatherView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "black")?.cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var otherWeathersStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [yesterdayWeatherView, tomorrowdayWeatherView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
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
    
//    override func layoutIfNeeded() {
//        setupBackgroundLayer()
//    }
//    override func setNeedsLayout() {
//        setupBackgroundLayer()
//    }

    
    // MARK: - Helpers
    
//    func setupBackgroundLayer() {
//        DispatchQueue.main.async {
//            if let backgroundGradientLayer = self.todayWeatherView.backgroundGradientLayer {
//                if self.bounds != CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0) {
//                    print("DEBUG: frame:\(self.todayWeatherView.frame)")
//                    print("DEBUG: bounds:\(self.todayWeatherView.bounds)")
////                    backgroundGradientLayer.frame = CGRect(x: 10, y: 10, width: 300, height: 300)
//                    backgroundGradientLayer.frame = self.todayWeatherView.bounds
//                    print("DEBUG: backgroundGrdientFrame:\(backgroundGradientLayer.frame)")
//                    self.layer.addSublayer(backgroundGradientLayer)
//                    self.layer.borderWidth = 0
//                    self.setupUI()
//                }
//            }
//        }
//    }
    
    func setupUI() {
        self.addSubview(todayWeatherView)
        self.addSubview(otherWeathersStackView)

        todayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        yesterdayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        tomorrowdayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        otherWeathersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayWeatherView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            todayWeatherView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            todayWeatherView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
//            todayWeatherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -350),
            todayWeatherView.heightAnchor.constraint(equalToConstant: 300),
            
            otherWeathersStackView.topAnchor.constraint(equalTo: todayWeatherView.bottomAnchor, constant: 10),
            otherWeathersStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            otherWeathersStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            otherWeathersStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
        ])
    }
    

    
    
    
    
}
