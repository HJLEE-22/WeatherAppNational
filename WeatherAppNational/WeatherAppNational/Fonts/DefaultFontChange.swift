//
//  DefaultFontChange.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/01.
//

import UIKit

struct AppFontName {
    static let regular = "Binggrae"
    static let bold = "Binggrae-Bold"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }

     class func overrideInitialize() {
        if self == UIFont.self {
           let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
           method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)

           let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
           method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)

           let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:)))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
           method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
    }
  }
}

