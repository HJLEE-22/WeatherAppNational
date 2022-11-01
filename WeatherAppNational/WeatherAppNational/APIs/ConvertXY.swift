//
//  ConvertXY.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/10/31.
//

import Foundation


public let TO_GRID: Int  = 0
public let TO_GPS: Int = 1

public class ConvertGPS {
    
    static func convertGRIDtoGPS(mode: Int, lat_X: Double, lng_Y: Double) -> LatXLngY {
        
        let RE = 6371.00877 // 지구 반경(km)
        let GRID = 5.0 // 격자 간격(km)
        let SLAT1 = 30.0 // 투영 위도1(degree)
        let SLAT2 = 60.0 // 투영 위도2(degree)
        let OLON = 126.0 // 기준점 경도(degree)
        let OLAT = 38.0 // 기준점 위도(degree)
        let XO:Double = 43 // 기준점 X좌표(GRID)
        let YO:Double = 136 // 기1준점 Y좌표(GRID)
        
        // LCC DFS 좌표변환 ( code : "TO_GRID"(위경도->좌표, lat_X:위도,  lng_Y:경도), "TO_GPS"(좌표->위경도,  lat_X:x, lng_Y:y) )
        
        let DEGRAD = Double.pi / 180.0
        let RADDEG = 180.0 / Double.pi
        
        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD
        
        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        var rs = LatXLngY(lat: 0, lng: 0, x: 0, y: 0)
        
            if mode == TO_GRID {
                rs.lat = lat_X
                rs.lng = lng_Y
                var ra = tan(Double.pi * 0.25 + (lat_X) * DEGRAD * 0.5)
                ra = re * sf / pow(ra, sn)
                var theta = lng_Y * DEGRAD - olon
                if theta > Double.pi {
                    theta -= 2.0 * Double.pi
                }
                if theta < -Double.pi {
                    theta += 2.0 * Double.pi
                }
        
                theta *= sn
                rs.x = Int(floor(ra * sin(theta) + XO + 0.5))
                rs.y = Int(floor(ro - ra * cos(theta) + YO + 0.5))
            } else {
                rs.x = Int(lat_X)
                rs.y = Int(lng_Y)
                let xn = lat_X - XO
                let yn = ro - lng_Y + YO
                var ra = sqrt(xn * xn + yn * yn)
                if (sn < 0.0) {
                    ra = -ra
                }
                var alat = pow((re * sf / ra), (1.0 / sn))
                alat = 2.0 * atan(alat) - Double.pi * 0.5
         
                var theta = 0.0
                if (abs(xn) <= 0.0) {
                    theta = 0.0
                } else {
                    if (abs(yn) <= 0.0) {
                        theta = Double.pi * 0.5
                        if (xn < 0.0) {
                            theta = -theta
                        }
                    } else {
                        theta = atan2(xn, yn)
                    }
                }
                let alon = theta / sn + olon
                rs.lat = alat * RADDEG
                rs.lng = alon * RADDEG
            }
        return rs
    }
}

struct LatXLngY {
    public var lat: Double
    public var lng: Double
    
    public var x: Int
    public var y: Int
}

struct LocationService{
    static var shared = LocationService()
    var longitude: Double = 0
    var latitude: Double = 0
}


/*
class ConvertXY {
    fileprivate var x: Float = 0.0, y: Float = 0.0
    fileprivate var map: lamc_parameter = lamc_parameter()
    
    final func convertMap(lon: Double, lat: Double) -> (mapX: Int, mapY: Int) {
        var PI: Double, DEGRAD: Double
        var re: Double, olon: Double, olat: Double, sn: Double, sf: Double, ro: Double
        var slat1: Double, slat2: Double, ra: Double, theta: Double
        
        PI = asin(1.0) * 2.0
        DEGRAD = PI / 180.0
        
        re = Double(self.map.Re / self.map.grid)
        slat1 = Double(self.map.slat1) * DEGRAD
        slat2 = Double(self.map.slat2) * DEGRAD
        olon = Double(self.map.olon) * DEGRAD
        olat = Double(self.map.olat) * DEGRAD
        
        sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        sf = tan(PI * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        ro = tan(PI * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        
        ra = tan(PI * 0.25 + lat * DEGRAD * 0.5)
        ra = re * sf / pow(ra, sn)
        theta = lon * DEGRAD - olon
        
        if theta > PI { theta -= 2.0 * PI }
        if theta < -PI { theta += 2.0 * PI}
        theta *= sn
        
        self.x = Float(ra * sin(theta)) + self.map.xo
        self.y = Float(ro - ra * cos(theta)) + self.map.yo
//        guard !(x.isNaN || x.isInfinite) else { return (mapX: 1, mapY: 2)}
//        guard !(y.isNaN || y.isInfinite) else { return (mapX: 3, mapY: 4)}
        guard self.x.isFinite || self.y.isFinite else { return (mapX: 1, mapY: 2)}
        return (mapX: Int(self.x + 1.5), mapY: Int(self.y + 1.5))
    }
}

*/
