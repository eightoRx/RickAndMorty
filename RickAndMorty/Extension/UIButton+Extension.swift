//
//  UIButton+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 26.09.2024.
//

import UIKit
import Combine

extension UIButton {
    func addLeftImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset).isActive = true
    }
}

// MARK: filter button animation
extension UIButton{
    func makeSystem() {
        self.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        self.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) { self.alpha = 0.55 }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) { self.alpha = 1 }
    }
}

// MARK: heart button animation
extension UIButton {
    func setCustomAnimate(_ image: UIImage?, animated: Bool = false, reversed: Bool = false, color: UIColor) {
        guard animated else {
            setImage(image, for: .normal)
            return
        }
        
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
        
        
        var values: [CATransform3D] = []
        var keyTimes: [Float] = []
        
        if !reversed {
            values.append(CATransform3DMakeScale(0.0, 0.0, 0.0))
        } else {
            values.append(CATransform3DMakeScale(1.0, 1.0, 1.0))
        }
        keyTimes.append(0.0)
        
        if !reversed {
            values.append(CATransform3DMakeScale(1.35, 1.35, 1.35))
        } else {
            values.append(CATransform3DMakeScale(0.65, 0.65, 0.65))
        }
        keyTimes.append(0.5)
        
        if !reversed {
            values.append(CATransform3DMakeScale(1.0, 1.0, 1.0))
        } else {
            values.append(CATransform3DMakeScale(0.0001, 0.0001, 0.0001))
        }
        keyTimes.append(1.0)
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = values.map({ NSValue(caTransform3D: $0) })
        animation.keyTimes = keyTimes.map({ NSNumber(value: $0 as Float) })
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        imageView?.layer.add(animation, forKey: "animateContents")
        
        setImage(templateImage, for: .normal)
    }
}
