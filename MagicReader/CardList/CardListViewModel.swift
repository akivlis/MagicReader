//
//  CardListViewModel.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import Foundation
import Combine
import SwiftUI
import Moya
import CombineMoya

class CardListViewModel: ObservableObject {

    enum HTTPError: LocalizedError {
        case statusCode
    }

    @Published var cards: [Card] = []
    @Published var recognizedCard: Card?
    @Published var searchText: String = String()

    var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    private let cardProvider: MoyaProvider<CardRequest>

    init(cards: [Card] = [], cardProvider: MoyaProvider<CardRequest> = MoyaProvider<CardRequest>()) {
        self.cards = cards
        self.cardProvider = cardProvider

        setupBinding()

        getRandomCard()
    }

    func getRandomCard() {
        cardProvider
            .requestPublisher(.randomCard, callbackQueue: .main)
            .map(Card.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                }
            }, receiveValue: { card in
                self.cards = [card]
            })
            .store(in: &cancellables)
    }

    func searchCards(for searchedName: String) {
        print("❤️ getting cards for: \(searchedName)")

        cardProvider
            .requestPublisher(.searchCards(named: searchedName, unique: true), callbackQueue: .main)
            .map(CardResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                }
            }, receiveValue: { cardResponse in
                guard let cards = cardResponse.cards else {
                    print("❗️ no cards downloaded for: \(searchedName)")
                    return
                }
                print("cards: \(cards.count)")
                self.cards = cards
            })
            .store(in: &cancellables)
    }

    // move this to its own tab
    func getCard(for recognizedName: String, setName: String, onCardFetched: @escaping (Card) -> ()) {
        guard recognizedName.count > 9 else { return }
        print("❤️ fetch cards for: \(recognizedName)")
        let name = recognizedName.filter {!$0.isWhitespace}.lowercased()

        cardProvider
            .requestPublisher(.searchCards(named: name, unique: true), callbackQueue: .main)
            .map(CardResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                }
            }, receiveValue: { cardResponse in
                guard let cards = cardResponse.cards else {
                    print("no cards downloaded")
                    return
                }

                cards.forEach { card in
                    print("🚀 card: \(card.name) \(card.setName), \(card.type)")
                }
                guard let fetchedCard = cards.first else { return }
                onCardFetched(fetchedCard)
            })
            .store(in: &cancellables)
    }
}

private extension CardListViewModel {

    func setupBinding() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { (string) -> String? in
                if string.count < 1 {
//                    self.cards = []
                    return nil
                }
                return string
            }
            .compactMap{ $0 }
            .sink { (_) in
            } receiveValue: { [weak self] searchText in
                print("🔎 searched for: \(searchText)")
                self?.searchCards(for: searchText)
            }
            .store(in: &cancellables)
    }
}
