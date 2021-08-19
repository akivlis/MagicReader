//
//  Endpoint.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 19.08.21.
//

import Foundation

enum Endpoint {

    static let basicURL = "https://api.scryfall.com"

    static let randomCard = basicURL + "/cards/random"

    static let searchCard = basicURL + "/cards/search?q="
}
