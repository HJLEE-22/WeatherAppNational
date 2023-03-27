//
//  Colors.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/11/30.
//

import UIKit

public enum ColorsByTemperature {
    
    static let colorFor0 = "Lightaqua0"
    static let colorFor03 = "Lightblue03"
    static let colorFor06 = "Greentoblue06"
    static let colorFor09 = "Yellowgreen09"
    static let colorFor12 = "Turquias12"
    static let colorFor15 = "Lawngreen15"
    static let colorFor18 = "Lightyellow18"
    static let colorFor21 = "Redyellow21"
    static let colorFor24 = "Lightsalmon24"
    static let colorFor27 = "Coral27"
    static let colorFor30 = "Tomato30"
    static let colorFor33 = "Orangered33"
    static let colorFor36 = "Red36"
    static let colorFor39 = "Darkred39"
    static let colorForMinus5 = "Aquacyan-5"
    static let colorForMinus10 = "Deepskyblue-10"
    static let colorForMinus15 = "Dodgerblue-15"
    static let colorForMinus20 = "Lightpurple-20"
    static let colorForMinus25 = "Purple-25"
    static let colorForMinus30 = "Royalblue-30"
    static let colorForMinus35 = "Blue-35"
    static let colorForMinus40 = "Navy-40"
}

public struct ColorForDarkMode {
    static func getSystemGrayColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .light {
                    return .systemGray
                } else {
                    return .white
                }
            }
        } else {
            return .systemGray
        }
    }

    static func getSystemGray5Color() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .light {
                    return .systemGray5
                } else {
                    return .lightGray
                }
            }
        } else {
            return .systemGray5
        }
    }
    
    static func getNavigationItemColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .light {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            return .black
        }
    }
    
    static func getBackgroundColor() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor{ (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .light {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .white
        }
    }
}
