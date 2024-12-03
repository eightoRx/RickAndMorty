//
//  UIKitPublisher.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 20.11.2024.
//

import Foundation
import Combine
import UIKit

class UIKitPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    
    let control: UIControl
    let event: UIControl.Event
    
    init(control: UIControl, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
        _ = UIKitSubscription(subscriber: subscriber, control: control, event: event)
    }
}
