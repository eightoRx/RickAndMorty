//
//  Theme.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 24.09.2024.
//

import UIKit

extension UIColor {
    static let theme = ColorTheme()
}
extension UIFont {
    static let theme = FontTheme()
}

struct ColorTheme {
    let episodeCellBackgroundBottom = UIColor(named: "EpisodeBackgroundBottomCell")
    let episodeTextColor = UIColor(named: "EpisodeTextColor")
    let episodeGrayTextColor = UIColor(named: "EpisodeGrayTextColor")
    let episodeFilterColor = UIColor(named: "FilterColor")
    let episodeFilterTitleColor = UIColor(named: "FilterTitleColor")
    let episodeFilterIconColor = UIColor(named: "FilterIconColor")
    let characterDetailNameColor = UIColor(named: "CharacterDetailName")
    let characterDetailSeparatorCell = UIColor(named: "SeparatorCell")
    let headerLabel = UIColor(named: "HeaderLabelColor")
    let titleCell = UIColor(named: "TitleCell")
    let borderCharacterAvatar = UIColor(named: "BorderCharacterAvatar")
}


struct FontTheme {
    let episode = EpisodeFont()
    let characterDetail = CharacterDetailFont()
    let favourite = FavouriteFont()
}


enum FontType: String {
    case robotoMedium = "Roboto-Medium"
    case robotoRegular = "Roboto-Regular"
    case robotoLight = "Roboto-Light"
    case karlaMedium = "Karla-Medium"
    case karlaSemiBold = "Karla-SemiBold"
    case karlaBold = "Karla-Bold"
    case karlaExtraBold = "Karla-ExtraBold"
}


extension FontTheme {
    struct EpisodeFont {
        let characterNameFont = UIFont.getCustomFont(type: .robotoMedium, size: 20)
        let bottomLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}

extension FontTheme {
    struct CharacterDetailFont {
        let characterIconFont = UIFont.getCustomFont(type: .robotoRegular, size: 32)
    }
}

extension FontTheme {
    struct FavouriteFont {
        let navigationLabel = UIFont.getCustomFont(type: .karlaBold, size: 24)
    }
}

