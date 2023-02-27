//
//  Date.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/28.
//

import Foundation

public struct DateCalculate {

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
    
    static var yesterdayDateShortString: String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let myFormatter = DateFormatter()
            myFormatter.locale = Locale(identifier: "ko_KR")
            myFormatter.timeZone = TimeZone(abbreviation: "KST")
            myFormatter.dateFormat = "dd"
            let savedDateString = myFormatter.string(from: yesterday)
            return savedDateString
        }
    
    static var tomorrowDateShortString: String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let myFormatter = DateFormatter()
            myFormatter.locale = Locale(identifier: "ko_KR")
            myFormatter.timeZone = TimeZone(abbreviation: "KST")
            myFormatter.dateFormat = "dd"
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
    
    static var nowTimeWithMinString: String {
        let now = Date()
        let myFormatter = DateFormatter()
        myFormatter.locale = Locale(identifier: "ko_KR")
        myFormatter.timeZone = TimeZone(abbreviation: "KST")
        myFormatter.dateFormat = "HH:mm:ss"
        let savedTimeString = myFormatter.string(from: now)
        return savedTimeString
    }
}
