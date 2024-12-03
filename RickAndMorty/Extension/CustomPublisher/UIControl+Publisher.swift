//
//  UIControl+Publisher.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 20.11.2024.
//

import Foundation
import UIKit
import Combine

extension UIControl {
    func uiPublisher(event: Event) -> UIKitPublisher {
        UIKitPublisher(control: self, event: event)
    }
}
