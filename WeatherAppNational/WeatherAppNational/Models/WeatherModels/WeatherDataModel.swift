//
//  WeatherDataModel.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/12.
//

import UIKit

struct WeatherData: Codable {
    let response: WeatherResponse
}

struct WeatherResponse: Codable {
    let header: WeatherHeader
    let body: WeatherBody
}

struct WeatherHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct WeatherBody: Codable {
    let dataType: String
    let items: WeatherItems
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct WeatherItems: Codable {
    let item: [WeatherItem]
}


struct WeatherItem: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}




/*
 // 기상청 api를 통해 받아오는 데이터 예시
 "baseDate": "20221012",
 "baseTime": "0500",
 "category": "TMP",
 "fcstDate": "20221012",
 "fcstTime": "0600",
 "fcstValue": "6",
 "nx": 55,
 "ny": 127
 */
