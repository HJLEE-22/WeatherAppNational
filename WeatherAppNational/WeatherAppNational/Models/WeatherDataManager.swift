//
//  WeatherDataManager.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/13.
//

import UIKit

enum NetworkError:Error {
    case networkingError
    case dataError
    case parseError
}

final class WeatherDataManager {
    
    static let shared = WeatherDataManager()
    private init() {}
    
    typealias NetworkCompletion = (Result<[WeatherItem], NetworkError>)-> Void

    func callWeatherAPI(date: String, time: String, nx: String, ny: String) {
        let serviceKey = "i%2FlgvIb5OpxWS%2FSUbYqKVRUFOAhnyLPnReUncUwXfMAm1M8MflkW6pDo5RG5Gvx8rXyy6cJNJrWjy6q83jBmBw%3D%3D"
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(serviceKey)&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\(date)&base_time=\(time)&nx=\(nx)&ny=\(ny)"
        
        let apiUrl: URL! = URL(string: urlString)
        let apiData = try! Data(contentsOf: apiUrl)
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("Result = \(log)")
        
        do {
            let apiArray = try JSONSerialization.jsonObject(with: apiData) as! NSArray
            
            let body = apiArray["body"] as! NSArray
            let items = body["items"] as? NSArray
            let item = items["item"] as? NSDictionary
            
            for row in item {
                let r = row as! NSArray
                print(r)
//                WeatherDataManager.shared.callWeatherAPI(date: "20221015", time: "0500", nx: "55", ny: "127")
                let weatherItem = WeatherItem()
                weatherItem.fcstTime = r["fcstTime"] as? String
                weatherItem.fcstDate = r["fcstDate"] as? String
                weatherItem.fcstValue = r["fcstValue"] as? String
                weatherItem.category = r["category"] as? String
                weatherItem.baseDate = r["baseDate"] as? String
                weatherItem.baseTime = r["baseTime"] as? String
                weatherItem.nx = (r["nx"] as! NSString).intValue
                weatherItem.ny = (r["ny"] as! NSString).intValue

            }
            
            
            
            
            
        } catch {}
        
        
    }
    
    
    
}


/*

final class WeatherDataManager {
    
    static let shared = WeatherDataManager()
    private init() {}
    
    typealias NetworkCompletion = (Result<[WeatherItem], NetworkError>)-> Void

    
    func fetchWeather(date: String, time: String, nx: String, ny: String, completion: @escaping NetworkCompletion) {
        let serviceKey = "i%2FlgvIb5OpxWS%2FSUbYqKVRUFOAhnyLPnReUncUwXfMAm1M8MflkW6pDo5RG5Gvx8rXyy6cJNJrWjy6q83jBmBw%3D%3D"
        let urlString = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(serviceKey)&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\(date)&base_time=\(time)&nx=\(nx)&ny=\(ny)"
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    
    func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                // completion에 에러타입 전달
                return
            }
            guard let safeData = data else {
                // completion에 에러타입 전달
                return
            }
            if let weather = self.parseJSON(safeData) {
                print("parse 실행")
                completion(.success(weather))
            } else {
                print("parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> [WeatherItem]? {
        do {
            let weatherArray = try JSONDecoder().decode(WeatherResponse.self, from: weatherData)
            return weatherArray.body?.items?.item
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
*/
