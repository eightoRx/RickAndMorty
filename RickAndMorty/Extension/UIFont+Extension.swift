//
//  UIFont+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 24.09.2024.
//

import UIKit

extension UIFont {
    static func getCustomFont(type: FontType, size: CGFloat) -> UIFont {
        .init(name: type.rawValue, size: size)!
        // Change
    }
}


