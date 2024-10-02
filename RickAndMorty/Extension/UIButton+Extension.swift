//
//  UIButton+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 26.09.2024.
//

import UIKit

extension UIButton {
    func addLeftImage(image: UIImage, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset).isActive = true
    }
}

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
