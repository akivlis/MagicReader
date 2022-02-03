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

    var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?

    private let cardProvider: MoyaProvider<CardRequest>

    init(cards: [Card] = [], cardProvider: MoyaProvider<CardRequest> = MoyaProvider<CardRequest>()) {
        self.cards = cards
        self.cardProvider = cardProvider

        getRandomCard()
    }

    func getRandomCard() {
        print("❤️ getting Random card")
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
                print("card: \(card)")
                self.cards = [card]
            })
            .store(in: &cancellables)
    }

    func searchCards(for searchedName: String) {
        print("❤️ getting cards for: \(searchedName)")
        let cardsURLString =  Endpoint.searchCard  + "\(searchedName)"
        guard let url = URL(string: cardsURLString) else { return }

        // todo: stop query if another query starts
        fetchCards(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                }
            }, receiveValue: { cards in
                print("cards: \(cards.count)")
                self.cards = cards
            })
            .store(in: &cancellables)
    }

    func getCard(for recognizedName: String, setName: String, onCardFetched: @escaping (Card) -> ()) {
        guard recognizedName.count > 9 else { return }
        print("❤️ fetch cards for: \(recognizedName)")
        let name = recognizedName.filter {!$0.isWhitespace}.lowercased()

//        let url = Endpoint.searchCard  + "\(name)+s%3A\(setName)"
        let url = Endpoint.searchCard  + "\(name)"

        print("url: \(url)")
        guard let url = URL(string: url) else { return }

        fetchCards(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                }
            }, receiveValue: { cards in
                print("cards: \(cards.count)")

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

    func fetchCards(from url: URL) -> AnyPublisher<[Card], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CardResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .compactMap { $0.cards }
            .eraseToAnyPublisher()
    }
}
