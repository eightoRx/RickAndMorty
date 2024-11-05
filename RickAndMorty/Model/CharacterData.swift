//
//  Character.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 04.10.2024.
//

import Foundation

struct CharacterResponse: Codable, Hashable {
    let info: Info
    let results: [Character]
}

struct Character: Codable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
}

// MARK: - Result

enum Gender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
    case another
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
        case "Female": self = .female
        case "Male": self = .male
        case "unknown": self = .unknown
        default: self = .another
        }
    }
}

// MARK: - Location
struct Location: Codable, Hashable {
    let name: String
    let url: String
}

enum Species: String, Codable, Hashable {
    case alien = "Alien"
    case human = "Human"
    case unknow
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
        case "Alien": self = .alien
        case "Human": self = .human
        default: self = .unknow
        }
    }
}

enum Status: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
