//
//  OpacityTapGestureRecognizer.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/16.
//

import UIKit

class OpacityTapGestureRecognizer: UITapGestureRecognizer {
    var onTapped: (() -> Void)?
    var opTappedPosition: ((CGPoint) -> Void)?
}

class OpacityLongPressGestureRecognizer: UILongPressGestureRecognizer {
    var onTapped: (() -> Void)?
}
