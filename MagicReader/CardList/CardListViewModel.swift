//
//  CardListViewModel.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import Foundation
import Combine

class CardListViewModel: ObservableObject {

    enum Constants {
        static let defaultURL = "https://api.magicthegathering.io/v1"
    }

    enum HTTPError: LocalizedError {
        case statusCode
    }

    @Published var cards: [Card] = []
    var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?

    init(cards: [Card] = []) {
        self.cards = cards
    }

    func getCards() {
        let cardsURLString =  Constants.defaultURL + "/cards"
        let url = URL(string: cardsURLString)!
        fetchCards(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { cards in
                print("cards: \(cards)")
                self.cards = cards
            })
            .store(in: &cancellables)
    }

    func getCard(for searchedName: String) {
        let cardsURLString =  Constants.defaultURL + "/cards?name=\(searchedName)"
        let url = URL(string: cardsURLString)!

        fetchCards(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { cards in
                print("cards: \(cards)")
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
