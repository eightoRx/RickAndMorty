//
//  UIView+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 26.09.2024.
//

import UIKit

extension UIView {
    func dropShadow(radius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float? = 0.4) {
        guard let opacity else { return }
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
    }
}
