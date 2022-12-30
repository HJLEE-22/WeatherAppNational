//
//  ColorsViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/26.
//

import UIKit

class ColorsViewModel {
    
    // MARK: - Properties
    
    var observer: (any ColorsObserver)?
    
    var todayBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            notify(updateValue: [Day.today: todayBackgroundColorLayer])
        }
    }
    var yesterdayBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            notify(updateValue: [Day.yesterday: yesterdayBackgroundColorLayer])
        }
    }
    var tomorrowBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            notify(updateValue: [Day.tomorrow: tomorrowBackgroundColorLayer])
        }
    }
    
    // MARK: - Life cycle
    
    init(weatherViewModel: WeatherViewModel) {
        bind(weatherViewModel: weatherViewModel)
    }

    
    // MARK: - Helpers
    
    func bind(weatherViewModel: WeatherViewModel?) {
        guard let viewModel = weatherViewModel,
              // viewModel은 받아왔지만, viewModel 안의 today/yesterday/tomorrow WeatherModel들은 생성이 아직 안된 상태
              // 데이터 로드 속도에 따른 듯.
              // 따라서, gaurd문으로 식 종료. todayBackgroundLayer가 호출되지 않음으로 didSet도 움직이지 않아 notify로 동작하는
              // ColorsViewModel의 observer도 동작 안함...
              let todayMax = viewModel.todayWeatherModel.temperatureMax,
              let todayMin = viewModel.todayWeatherModel.temperatureMin,
              let yesterdayMax = viewModel.yesterdayWeatherModel.temperatureMax,
              let yesterdayMin = viewModel.yesterdayWeatherModel.temperatureMin,
              let tomorrowMax = viewModel.tomorrowWeatherModel.temperatureMax,
              let tomorrowMin = viewModel.tomorrowWeatherModel.temperatureMin else { return }

        todayBackgroundColorLayer = setBackgroundColor(maxTemperature: todayMax, minTemperature: todayMin)
        yesterdayBackgroundColorLayer = setBackgroundColor(maxTemperature: yesterdayMax, minTemperature: yesterdayMin)
        tomorrowBackgroundColorLayer = setBackgroundColor(maxTemperature: tomorrowMax, minTemperature: tomorrowMin)
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
}

extension ColorsViewModel: ColorsSubscriber {
    func subscribe(observer: (ColorsObserver)?) {
        self.observer = observer
    }
    
    func unSubscribe(observer: (ColorsObserver)?) {
        self.observer = nil
    }
    
    func notify<T>(updateValue: T) {
        observer?.colorsUpdate(updateValue: updateValue)
    }
}

