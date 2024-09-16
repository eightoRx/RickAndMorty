//
//  Dependencies.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

protocol IDependencies {
    var moduleContainer: IModuleContainer {get}
}


final class Dependencies: IDependencies {
    lazy var moduleContainer: IModuleContainer = ModulContainer(self)
}
