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
    
    lazy var emptyBottonStackView: UIStackView = {
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
    
    
    // MARK: - Helpers
    
    
    func setupUI() {
        self.addSubview(todayWeatherView)
//        self.addSubview(yesterdayWeatherView)
//        self.addSubview(tomorrowdayWeatherView)
        self.addSubview(emptyBottonStackView)
        
        todayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        yesterdayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        tomorrowdayWeatherView.translatesAutoresizingMaskIntoConstraints = false
        emptyBottonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayWeatherView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            todayWeatherView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            todayWeatherView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
//            todayWeatherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -350),
            todayWeatherView.heightAnchor.constraint(equalToConstant: 300),
            
            emptyBottonStackView.topAnchor.constraint(equalTo: todayWeatherView.bottomAnchor, constant: 10),
            emptyBottonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            emptyBottonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            emptyBottonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            /*
             
             

            yesterdayWeatherView.topAnchor.constraint(equalTo: todayWeatherView.bottomAnchor, constant: 10),
            yesterdayWeatherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            yesterdayWeatherView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
//            yesterdayWeatherView.trailingAnchor.constraint(equalTo: tomorrowdayWeatherView.leadingAnchor, constant: 20),
            yesterdayWeatherView.widthAnchor.constraint(equalToConstant: 150),
            
            tomorrowdayWeatherView.topAnchor.constraint(equalTo: todayWeatherView.bottomAnchor, constant: 10),
            tomorrowdayWeatherView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            tomorrowdayWeatherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            tomorrowdayWeatherView.widthAnchor.constraint(equalToConstant: 150)

             */
        ])
    

            
        
    }
    
    
    
    
    
    
}
