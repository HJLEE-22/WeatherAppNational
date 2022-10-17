//
//  WeatherData.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//

import UIKit

struct WeatherResponse: Codable {
    let header: WeatherHeader?
    let body: WeatherBody?
}

struct WeatherHeader: Codable {
    let resultCode: String?
    let resultMsg: String?
}

struct WeatherBody: Codable {
    let dataType: String?
    let items: WeatherData?
    let pageNo: Int?
    let numOfRows: Int?
    let totalCount: Int?
}

struct WeatherData: Codable {
    let item: [WeatherItem]?
}


struct WeatherItem: Codable {
    let baseDate: String?
    let baseTime: String?
    let category: String?
    let fcstDate: String?
    let fcstTime: String?
    let fcstValue: String?
    let nx: Int?
    let ny: Int?
}




/*
 "baseDate": "20221012",
 "baseTime": "0500",
 "category": "TMP",
 "fcstDate": "20221012",
 "fcstTime": "0600",
 "fcstValue": "6",
 "nx": 55,
 "ny": 127
 
 
 */
