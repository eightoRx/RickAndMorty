//
//  AlertsBuilder.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 02.10.2024.
//

import UIKit

protocol IAlertsBuilder {
     func buildOkAlert(with title: String, message: String, completion: @escaping () -> Void) -> UIViewController
}

struct AlertsBuilder: IAlertsBuilder {
    
     func buildOkAlert(with title: String, message: String = "", completion: @escaping () -> Void) -> UIViewController {
         
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
         
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
         alertController.view.tintColor = UIColor.red
         
        return alertController
    }
}
