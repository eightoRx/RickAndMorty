//
//  UIKitSubscription.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 20.11.2024.
//

import Foundation
import Combine
import UIKit

class UIKitSubscription<SubType: Subscriber>: Subscription where SubType.Input == UIControl {
    private var subscriber: SubType? = nil
    private let control: UIControl
    
    init(subscriber: SubType?, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        
        self.control.addTarget(self, action: #selector(reactToEvent), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() { subscriber = nil }
    
    @objc func reactToEvent() {
        _ = subscriber?.receive(control)
    }
}
