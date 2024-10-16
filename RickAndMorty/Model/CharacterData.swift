//
//  Character.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 04.10.2024.
//

import Foundation


// MARK: - Character
struct Character1: Codable, Hashable {

//    let id: Int
    let gender: String
    let status: String
    let specie: String
    let type: String
    let origin: String
    let location: String
//    let image: String
    //    let episode: [String]
    //    let url: String
    //    let created: String
}


// -----------------------------------------------------------------------------
// MARK: - Character

struct CharacterResponse: Codable, Hashable {
    let info: Info
    let results: [Character]
}

struct Character: Codable, Hashable {
    let id: Int // id character
    let name: String // name character
    let status: Status // Alive Dead or unknown
    let species: Species // human or alien
    let type: String // Type
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
}

// MARK: - Location
struct Location: Codable, Hashable {
    let name: String
    let url: String
}

enum Species: String, Codable, Hashable {
    case alien = "Alien"
    case human = "Human"
}

enum Status: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
