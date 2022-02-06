//
//  CardListView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import SwiftUI

struct CardListView: View {

    @ObservedObject var viewModel : CardListViewModel

    @State private var showingScanningView = false
    @State private var showingCardDetail = false
    @State private var recognizedText = ""
    @State private var inputImage: UIImage?
    @State private var recognizedCard: Card?

    let cameraViewModel = CameraViewModel()

    var items: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()

                VStack {
                    SearchBar(text: $viewModel.searchText)
                        .padding([ .horizontal, .top ], 12)

                    switch viewModel.state {
                    case .idle:
                        Color.clear.onAppear(perform: viewModel.getRandomCard)

                    case .loading:
                        Spacer()
                        ProgressView()
                        Spacer()
                    case let .loaded(cards):
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: items, spacing: 10) {
                                ForEach(cards, id: \.id) { card in
                                    NavigationLink(destination: CardDetail(card: card)) {
                                        CardGridItem(card: card)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    case let .failed(errorMessage):
                        Text(errorMessage)
                    }

                }
                .navigationBarTitle("Single Cards")
                .toolbar {
                    Button(action: {
                        self.showingScanningView = true

                    }) {
                        Image(systemName: "camera.viewfinder")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    }
                }
                .sheet(isPresented: $showingScanningView,
                       onDismiss: { self.showingScanningView = false },
                       content: {

                    CameraPreview(recognizedText: self.$recognizedText,
                                  session: cameraViewModel.session,
                                  onTextDetected: { name, setName in
                        viewModel.getCard(for: name, setName: setName, onCardFetched: { card in
                            showingScanningView = false
                            recognizedCard = card
                            print(card)
                            showingCardDetail = true
                        })
                    })
                    Text(recognizedText)
                })
                .sheet(isPresented: $showingCardDetail) {
                    if let card = recognizedCard {
                        CardDetail(card: card)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let cards = [
            Card(cardId: "123",
                 name: "Archangel Avacyn",
                 type: "Legendary Creature — Angel",
                 text: "Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.",
                 setName: "Adventures in the Forgotten Realms",
                 power: "4",
                 imageSet: ImageSet(borderCrop: "https://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card"),
                 colors: ["W"],
                 rarity: .common,
                 prices: PriceSet(),
                 reserved: false),
            Card(cardId: "123",
                 name: "Ancestor's Chosen",
                 type: "Creature — Human Cleric",
                 text: "Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.",
                 setName: "Tenth Edition",
                 power: "4",
                 imageSet: ImageSet(borderCrop: "https://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card"),
                 colors: ["W"],
                 rarity: .common,
                 prices: PriceSet(euro: "5 euro"),
                 reserved: false)
        ]
        let view = CardListView(viewModel: CardListViewModel(cards: cards))
        return view
    }
}
