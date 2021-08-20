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
    @State private var recognizedText = ""
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText,
                          onTextChanged: viewModel.getCard(for:))
                    .padding(.bottom, 0.0)

                List(viewModel.cards
                        .filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { card in
                    NavigationLink(destination: CardDetail(card: card)) {
                        CardRow(card: card)
                    }
                }   

//                Text(recognizedText)
//                    .padding()
            }
            .navigationBarTitle("Single Cards")
            .toolbar {
                Button(action: {
                    self.showingScanningView = true

                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                }
            }
            .sheet(isPresented: $showingScanningView) {
                let cameraViewModel = CameraViewModel()
                CameraPreview(recognizedText: self.$recognizedText,
                              session: cameraViewModel.session)
                    .onAppear {
                        cameraViewModel.startCamera()
                    }
            }.onAppear {
//                viewModel.getCards()
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
