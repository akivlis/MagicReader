//
//  Card.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import Foundation

struct Card: Codable, Identifiable {

    var id = UUID()
    let cardId: String
    let name: String
    let type: String
    let text: String?
    let setName: String
    let power: String?
    let imageURL: String?
    let colors: [String]
    var artist: String? = ""

    enum CodingKeys: String, CodingKey {
        case cardId = "id"
        case name
        case type
        case text
        case setName
        case power
        case imageURL = "imageUrl"
        case colors
        case artist
    }
}

struct CardResponse: Codable {
    let cards: [Card]
}



