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

    enum CardListState {
        case idle
        case loading
        case loaded([Card])
        case failed(String)
    }

    @Published var cards: [Card] = []
    @Published var recognizedCard: Card?
    @Published var searchText: String = String()
    @Published private(set) var state = CardListState.idle

    var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    private let cardProvider: MoyaProvider<CardRequest>

    init(cards: [Card] = [], cardProvider: MoyaProvider<CardRequest> = MoyaProvider<CardRequest>()) {
        self.cards = cards
        self.cardProvider = cardProvider

        setupBinding()
    }

    func getRandomCard() {
        cardProvider
            .requestPublisher(.randomCard, callbackQueue: .main)
            .map(Card.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                    self?.state = .failed(error.localizedDescription)
                }
            }, receiveValue: { [weak self] card in
                self?.state = .loaded([card])
            })
            .store(in: &cancellables)
    }

    func searchCards(for searchedName: String) {
        state = .loading

        cardProvider
            .requestPublisher(.searchCards(named: searchedName, unique: true), callbackQueue: .main)
            .map(CardResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("😈" + String(describing: error))
                    self?.state = .failed(error.localizedDescription)
                }
            }, receiveValue: { [weak self] cardResponse in
                guard let self = self,
                      let cards = cardResponse.cards
                else {
                    print("❗️ no cards downloaded for: \(searchedName)")
                    return
                }
                print("cards: \(cards.count)")
                self.state = .loaded(cards)
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
                    // uncomment if want to remove search result if search text is empty
                     self.cards = []
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
