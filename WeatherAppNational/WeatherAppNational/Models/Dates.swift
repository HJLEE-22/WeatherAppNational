//
//  Date.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/28.
//

import Foundation

public struct DateCalculate {
    
    // struct 변수로 date = Date() 만드니 self.date 로도 인식이 안되서
    // 각 날 마다 date() 객체를 매번 생성해줬는데 옳은 걸까?
    
    // 밑의 formatter로 만든 string들 옵셔널 안해도 괜찮을까?
    static var todayDateString: String {
        let now = Date()
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "ko_KR")
        myFormatter.timeZone = TimeZone(abbreviation: "KST")
        myFormatter.dateFormat = "yyyyMMdd"
        let savedDateString = myFormatter.string(from: now)
        return savedDateString
    }
    
    static var yesterdayDateString: String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let myFormatter = DateFormatter()
            myFormatter.locale = Locale(identifier: "ko_KR")
            myFormatter.timeZone = TimeZone(abbreviation: "KST")
            myFormatter.dateFormat = "yyyyMMdd"
            let savedDateString = myFormatter.string(from: yesterday)
            return savedDateString
        }
    
    static var tomorrowDateString: String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let myFormatter = DateFormatter()
            myFormatter.locale = Locale(identifier: "ko_KR")
            myFormatter.timeZone = TimeZone(abbreviation: "KST")
            myFormatter.dateFormat = "yyyyMMdd"
            let savedDateString = myFormatter.string(from: tomorrow)
            return savedDateString
        }
}

public struct TimeCalculate{
    
    static var nowTimeString: String {
        let now = Date()
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "ko_KR")
        myFormatter.timeZone = TimeZone(abbreviation: "KST")
        myFormatter.dateFormat = "HH00"
        let savedTimeString = myFormatter.string(from: now)
        return savedTimeString
        
    }
    
    
}
