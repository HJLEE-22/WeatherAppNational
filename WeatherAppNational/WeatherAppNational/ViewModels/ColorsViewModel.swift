//
//  ColorsViewModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/26.
//

import UIKit

class ColorsViewModel {
    
    // MARK: - Properties
    
    var colorsObserver: (any ColorsObserver)?
    
    var backgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            notify(updateValue: backgroundColorLayer)
        }
    }

    // MARK: - Life cycle
    
    init(weatherModel: WeatherModel?) {
        bind(weatherModel: weatherModel)
    }

    // MARK: - Helpers
    
    func bind(weatherModel: WeatherModel?) {
        guard let weatherModel,
// 왜 bind할 때 colorsObserver가 계속 nil이 되지?
              let maxTemperature = weatherModel.temperatureMax,
              let minTemperature = weatherModel.temperatureMin else { return }
              
        self.backgroundColorLayer = setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
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
        self.colorsObserver = observer
    }
    
    func unSubscribe(observer: (ColorsObserver)?) {
        self.colorsObserver = nil
    }
    
    func notify<T>(updateValue: T) {
        colorsObserver?.colorsUpdate(updateValue: updateValue)
    }
}

