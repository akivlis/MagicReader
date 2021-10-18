//
//  CardListView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import SwiftUI

struct CardListView: View {

    @ObservedObject var viewModel : CardListViewModel

    @State private var searchText = ""
    @State private var showingScanningView = false
    @State private var showingCardDetail = false
    @State private var recognizedText = ""
    @State private var inputImage: UIImage?
    @State private var recognizedCard: Card?

    let cameraViewModel = CameraViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText,
                          onTextChanged: viewModel.searchCards(for:))
                    .padding(.bottom, 0.0)

                List(viewModel.cards
                        .filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { card in
                    NavigationLink(destination: CardDetail(card: card)) {
                        CardRow(card: card)
                    }
                }
                        .edgesIgnoringSafeArea(.bottom)

                Text(recognizedText)
                    .padding()
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
//                        showingCardDetail = true
//                        showingScanningView = false
                        recognizedCard = card
                        print(card)
                    })
                })
                Text(recognizedText)
            })
            .onAppear {
                cameraViewModel.startCamera()
            }
            .onDisappear {
                cameraViewModel.stopCamera()
            }
            .sheet(isPresented: $showingCardDetail) {
                if let card = recognizedCard {
                    CardDetail(card: card)
                }
            }
            .onAppear {
                //                viewModel.getCards()
            }
//            .onReceive(viewModel.fetchedCard, perform: { _ in
//                self.showingScanningView = false
//            self.showingcardDetal = true
//            })
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
                 prices: PriceSet()),
            Card(cardId: "123",
                 name: "Ancestor's Chosen",
                 type: "Creature — Human Cleric",
                 text: "Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.",
                 setName: "Tenth Edition",
                 power: "4",
                 imageSet: ImageSet(borderCrop: "https://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card"),
                 colors: ["W"],
                 rarity: .common,
                 prices: PriceSet(euro: "5 euro"))
        ]
        let view = CardListView(viewModel: CardListViewModel(cards: cards))
        return view
    }
}
