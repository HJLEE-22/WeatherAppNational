
//
//  TouchableOpacityImageView.swift
//  WeatherAppNational
//
//  Created by 이형주 on 2022/12/16.
//

import UIKit

class TouchableOpacityImageView: UIImageView {
    
    var isEffectSet: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            super.point(inside: point, with: event)

            /// x: 10, y: 15 만큼 영역 증가
            /// dx: x축이 dx만큼 증가 (음수여야 증가)
            let touchArea = bounds.insetBy(dx: -10, dy: -10)
            return touchArea.contains(point)
    }
    
    func setOpaqueTapGestureRecognizer(setEffect: Bool? = true, onTapped: @escaping () -> Void) {
        let gesture = OpacityTapGestureRecognizer(target: self, action: #selector(blur(gesture:)))
        gesture.onTapped = onTapped
        if let setEffect = setEffect { isEffectSet = setEffect }
        addGestureRecognizer(gesture)
    }
    
    @objc private func blur(gesture: OpacityTapGestureRecognizer) {
        if gesture.onTapped != nil, alpha == 1 {
            if isEffectSet {
                alpha = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in self?.alpha = 1.0 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { gesture.onTapped!() }
        }
    }
}
