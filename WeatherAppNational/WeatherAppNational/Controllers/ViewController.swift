//
//  ViewController.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    var weatherArray: [WeatherItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherDataManager.shared.fetchWeather(date: "20221024", time: "0500", nx: "55", ny: "127") { result in
            print(#function)
            switch result {
            case .success(let weathers):
                self.weatherArray = weathers
                print(self.weatherArray)
                DispatchQueue.main.async {
//                    self.label.text = self.weatherArray[1].fcstValue
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

