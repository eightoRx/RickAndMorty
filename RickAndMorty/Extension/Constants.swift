//
//  Constants.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.09.2024.
//

import UIKit

enum API {
    static let baseURL = "https://rickandmortyapi.com/api/"
    static let episode = "episode/?page="
    static let character = "character/"
}


enum UserDefaultsKeys {
    static let myCharacter = "MyCharacter"
    static let favourite = "Favourite"
}


enum ImageName {
    static let logoImage = "logo"
    static let loadImage = "load"
    static let characterImage = "rick"
    static let playImage = "play"
    static let heartButton = "heart"
    static let backButtonNavigation = "BackButton"
    static let navigationLogo = "NavigationLogo"
    static let cameraIcon = "CameraIcon"
    static let characterIcon = "CharacterIcon"
    static let redHeartButton = "redHeart"
}

enum SystemImageName {
    static let emptyHeart = "heart"
    static let fillHeart = "heart.fill"
    static let emptyHouse = "house"
    static let fillHouse = "house.fill"
    static let playSeries = "play.tv"
}

enum Constants {
    static let characterNameLabel = "Rick Sanchez"
    static let nameSeries = "Pilot"
    static let numberSeries = "S01E01"
    static let tableViewHeaderLabel = "Informations"
    static let titleAlertLoad = "Загрузите изображение"
    static let titleAlertCamera = "Камера"
    static let titleAlertGallery = "Галерея"
    static let titleAlertCancel = "Отмена"
    static let titleAccessCamera = "Разрешить доступ к камере?"
    static let titleDescriptionAccessCamera = "Это необходимо, чтобы сканировать штрихкоды, номер карты и использовать другие возможности"
    static let titleAccessPhoto = "Разрешить доступ к \"Фото\"?"
    static let titleDescriptionAccessPhoto = "Это необходимо для добавления ваших фотографий"
    static let titleAlertAccess = "Разрешить"
    static let titleAlertPhotoAndCameraCancel = "Отменить"
}


enum CoreDataConstant {
    static let episodeContainerName = "EpisodeContainer"
    static let episodeEntityName = "EpisodeEntity"
}
