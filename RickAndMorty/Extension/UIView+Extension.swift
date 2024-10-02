//
//  UIView+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 26.09.2024.
//

import UIKit

extension UIView {
     func dropShadow(radius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, color: UIColor) {
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowOpacity = 0.4
        layer.shadowColor = color.cgColor
    }
}
