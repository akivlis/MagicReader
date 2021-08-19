//
//  Card.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import Foundation
import UIKit

struct Card: Codable, Identifiable {

    var id = UUID()
    let cardId: String
    let name: String
    let type: String
    let text: String?
    let setName: String
    let power: String?
    let imageSet: ImageSet
    let colors: [String]
    var artist: String = ""
    let rarity: Rarity

    enum CodingKeys: String, CodingKey {
        case cardId = "id"
        case name
        case type = "type_line"
        case text
        case setName = "set_name"
        case power
        case imageSet = "image_uris"
        case colors
        case artist
        case rarity
    }
}

struct CardResponse: Codable {
    let cards: [Card]
    let totalCards: Int
    
    enum CodingKeys: String, CodingKey {
        case cards = "data"
        case totalCards = "total_cards"
    }
}

struct ImageSet: Codable {
    var png = ""
    var borderCrop = ""
    var artCrop = ""
    var large = ""
    var normal = ""
    var small = ""

    enum CodingKeys: String, CodingKey {
        case png
        case borderCrop = "border_crop"
        case artCrop = "art_crop"
        case large
        case normal
        case small
    }
}

enum Rarity: String, Codable {
    case common, uncommon, rare, special, mythic, bonus
}


