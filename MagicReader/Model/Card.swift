//
//  Card.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

struct Card: Codable, Identifiable {

    var id = UUID()
    let cardId: String
    let name: String
    let type: String
    let text: String?
    let setName: String
    let power: String?
    let imageSet: ImageSet?
    let colors: [String]?
    var artist: String = ""
    let rarity: Rarity
    let prices : PriceSet
    let isReserved: Bool
    let printsSearchURI: String?
//    let legalities: [String: Legality] = [:]

    var detailImageURL: URL? {
        URL(string: self.imageSet?.borderCrop ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case cardId = "id"
        case name 
        case type = "type_line"
        case text = "oracle_text"
        case setName = "set_name"
        case power
        case imageSet = "image_uris"
        case colors
        case artist
        case rarity
        case prices
        case isReserved = "reserved"
        case printsSearchURI = "prints_search_uri"
//        case legalities
    }
}

struct CardResponse: Codable {
    let cards: [Card]?
    let totalCards: Int?
    
    enum CodingKeys: String, CodingKey {
        case cards = "data"
        case totalCards = "total_cards"
    }
}

struct ImageSet: Codable {
    var png: String? = ""
    var borderCrop: String? = ""
    var artCrop: String? = ""
    var large: String? = ""
    var normal: String? = ""
    var small: String? = ""

    enum CodingKeys: String, CodingKey {
        case png
        case borderCrop = "border_crop"
        case artCrop = "art_crop"
        case large
        case normal
        case small
    }
}

struct PriceSet: Codable {
    var usd: String? = ""
    var usdFoil: String? = ""
    var euro: String? = ""
    var euroFoil: String? = ""
    var tix: String? = ""

    enum CodingKeys: String, CodingKey {
        case usd
        case usdFoil = "usd_foil"
        case euro = "eur"
        case tix
        case euroFoil = "eur_foil"
    }
}

enum Rarity: String, Codable {
    case common, uncommon, rare, special, mythic, bonus
}

enum Legality: String, Codable {
    case legal, notLegal, restricted, banned

    enum CodingKeys: String, CodingKey {
        case legal
        case notLegal = "not_legal"
        case restricted
        case banned
    }
}


