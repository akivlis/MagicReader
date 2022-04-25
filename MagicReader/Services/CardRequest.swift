//
//  CardRequest.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 28.01.22.
//

import Foundation
import Combine
import CombineMoya
import Moya

enum CardRequest {
    case randomCard
    case card(named: String, fuzzy: Bool)
    case searchCards(named: String, unique: Bool)
}

extension CardRequest: TargetType, Equatable {

    var baseURL: URL {
        return URL(string: Endpoint.basicURL + "/cards")!
    }

    var path: String {
        switch self {
        case .randomCard:
            return "random"
        case .card:
            return "named"
        case .searchCards:
            return "search"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .randomCard:
            return .requestPlain
        case let .card(name, fuzzy):
            let urlParameters: [String: Any] = [
                fuzzy ? "fuzzy" : "exact" : name
            ]
            return .requestParameters(parameters: urlParameters, encoding: URLEncoding.default)
        case let .searchCards(name, unique):
            let params: [String: Any] = [
                "q": name,
                "unique": unique ? "prints" : "cards"
            ]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        [
            "Content-type": "application/json",
        ]
    }

}

