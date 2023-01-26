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
    
    var todayBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            colorsNotify(updateValue: [Day.today: todayBackgroundColorLayer])
        }
    }
    var yesterdayBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            colorsNotify(updateValue: [Day.yesterday: yesterdayBackgroundColorLayer])
        }
    }
    var tomorrowBackgroundColorLayer: CAGradientLayer = CAGradientLayer() {
        didSet {
            colorsNotify(updateValue: [Day.tomorrow: tomorrowBackgroundColorLayer])
        }
    }

    // MARK: - Life cycle
    
//    init(weatherModel: [Day:WeatherModel?]) {
//        bind(weatherModel: weatherModel)
//    }
    
    init(weatherKitModel: [Day:WeatherKitModel?]) {
        bind(weatherModel: weatherKitModel)
    }

    // MARK: - Helpers
    /*
    func bind(weatherModel: [Day:WeatherModel?]) {
        // 대박!! 여기 비동기처리함으로서 드디어 notify와 연결됐다ㅜㅜ
        // 그런데 왜 여기를 비동기처리해줘야되지...? 안해줘도 값 오는데...
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .today,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.temperatureMax,
                  let minTemperature = model.temperatureMin else { return }
            self.todayBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
        
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .yesterday,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.temperatureMax,
                  let minTemperature = model.temperatureMin else { return }
            self.yesterdayBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
        
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .tomorrow,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.temperatureMax,
                  let minTemperature = model.temperatureMin else { return }
            self.tomorrowBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
    }
    */
    
    func bind(weatherModel: [Day:WeatherKitModel?]) {
        // 대박!! 여기 비동기처리함으로서 드디어 notify와 연결됐다ㅜㅜ
        // 그런데 왜 여기를 비동기처리해줘야되지...? 안해줘도 값 오는데...
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .today,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.highTemperature,
                  let minTemperature = model.lowTemperature else { return }
            self.todayBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
        
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .yesterday,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.highTemperature,
                  let minTemperature = model.lowTemperature else { return }
            self.yesterdayBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
        
        DispatchQueue.global().async { [weak self] in
            guard weatherModel.first?.key == .tomorrow,
                  let self,
                  let model = weatherModel.first?.value,
                  let maxTemperature = model.highTemperature,
                  let minTemperature = model.lowTemperature else { return }
            self.tomorrowBackgroundColorLayer = self.setBackgroundColor(maxTemperature: maxTemperature, minTemperature: minTemperature)
        }
    }
    
    func setBackgroundColor(maxTemperature: String, minTemperature: String) -> CAGradientLayer {
        let maxColor = switchColorsForBackground(temperature: Int((maxTemperature as NSString).intValue))?.cgColor
        let minColor = switchColorsForBackground(temperature: Int((minTemperature as NSString).intValue))?.cgColor
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
    func colorsSubscribe(observer: (ColorsObserver)?) {
        self.colorsObserver = observer
    }
    
    func colorsUnsubscribe(observer: (ColorsObserver)?) {
        self.colorsObserver = nil
    }
    
    func colorsNotify<T>(updateValue: T) {
        colorsObserver?.colorsUpdate(updateValue: updateValue)
    }
}

