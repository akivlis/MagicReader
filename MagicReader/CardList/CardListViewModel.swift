//
//  CardListViewModel.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import Foundation
import Combine

class CardListViewModel: ObservableObject {

    enum HTTPError: LocalizedError {
        case statusCode
    }

    @Published var cards: [Card] = []
    var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?

    init(cards: [Card] = []) {
        self.cards = cards

        getCards()
    }

    func getCards() {
        print("❤️ getting ALL")

        let cardsURLString =  Endpoint.searchCard + "abol" // default search here
        let url = URL(string: cardsURLString)!
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

    func getCard(for searchedName: String) {
        print("❤️ getting cards for: \(searchedName)")
        let cardsURLString =  Endpoint.searchCard  + "\(searchedName)"
        let url = URL(string: cardsURLString)!

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
}

private extension CardListViewModel {

    func fetchCards(from url: URL) -> AnyPublisher<[Card], Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CardResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .map { $0.cards }
            .replaceError(with: [Card]())
            .eraseToAnyPublisher()
    }
}
