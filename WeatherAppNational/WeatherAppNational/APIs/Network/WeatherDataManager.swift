//
//  WeatherDataManager.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/13.
//

import UIKit
import Alamofire

enum NetworkError:Error {
    case networkingError
    case dataError
    case parseError
}

final class WeatherDataManager {
    
    static let shared = WeatherDataManager()
    private init() {}
    
    private let serviceKey = Bundle.main.nationalWeatherApiKey
    
    typealias NetworkCompletion = (Result<[WeatherItem], NetworkError>)-> Void
    
    func fetchWeather(date: String,
                      time: String,
                      nx: Int,
                      ny: Int,
                      completion: @escaping NetworkCompletion){
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(serviceKey)&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\(date)&base_time=\(time)&nx=\(nx)&ny=\(ny)"
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    private func performRequest(with urlString: String,
                        completion: @escaping NetworkCompletion) {
        AF.request(urlString).validate()

        guard let url = URL(string: urlString) else { return }
        AF.request(url).validate().response { response in
            switch response.result {
            case .success(let data):
                guard let safeData = data else {
                    completion(.failure(.parseError))
                    return }
                if let weather = self.parseJSON(safeData) {
                    completion(.success(weather))
                } else {
                    completion(.failure(.parseError))
                }
            case .failure(let error):
                completion(.failure(.parseError))
            }
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> [WeatherItem]? {
        do {
            let weatherArray = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            return weatherArray.response.body.items.item
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
