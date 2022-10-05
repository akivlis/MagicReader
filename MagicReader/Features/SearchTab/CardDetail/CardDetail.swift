//
//  CardDetail.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import SwiftUI

struct CardDetail: View {
    var card: Card

    var body: some View {
        ZStack {
            Color(.secondarySystemBackground).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {

                GeometryReader { geometry in
                    AsyncImage(url: card.detailImageURLs?.first) { image in
                        image
                            .resizable()
                            .cornerRadius(10)
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .if(card.foil) { $0.overlay {
                                Image("foil-overlay-2")
                                    .resizable()
                                    .cornerRadius(10)
                                    .scaledToFit()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                            }
                    } placeholder: {
                        ProgressView()
                            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)

                    }
                }
                .frame(height: 400)
                .cornerRadius(10)

                VStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.name)
                            .font(.title.bold())
                            .foregroundColor(.primary)
                            .padding(.bottom)

                        Text(card.type)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("Illustrated by \( card.artist)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom)

                        Divider()
                            .padding(.bottom)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Set")
                                Spacer()
                                Text(card.setName)
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)


                            HStack {
                                Text("Rarity")
                                Spacer()
                                Text(card.rarity.rawValue)
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)

                            HStack {
                                Text("Reserved List:")
                                Spacer()
                                Text(card.isReserved ? "✔️" : "❌")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                        }

                        Divider()
                            .padding(.top)

                        Group {
                            VStack(alignment: .leading, spacing: 6.0) {
                                HStack {
                                    Text("Price")
                                    Spacer()
                                    Text(card.prices.euro == nil ? "-" : (card.prices.euro! + "€"))
                                }
                                .font(.headline)
                                .foregroundColor(.primary)

                                HStack {
                                    Text("Euro foil")
                                    Spacer()
                                    Text(card.prices.euroFoil == nil ? "-" : (card.prices.euroFoil! + "€"))
                                }
                                .font(.headline)
                                .foregroundColor(.primary)

                                NavigationLink(destination: PrintListView(viewModel: PrintListViewModel(printURLString: card.printsSearchURI ?? ""))) {
                                    Text("Show all prints")
                                }
                            }
                            .padding(.top)

                        }
                    }
                    .padding(.top)

                }
                .padding(.all)

                Spacer()
            }
        }
    }
}


struct CardDetail_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(cardId: "123",
                        name: "Archangel Avacyn",
                        type: "Legendary Creature — Angel",
                        text: "Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.",
                        setName: "Adventures in the Forgotten Realms",
                        power: "4",
                        imageSet: ImageSet(borderCrop: "https://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card"),
                        cardFaces: nil,
                        colors: ["W"],
                        artist: "Silvi",
                        rarity: .common,
                        prices: PriceSet(),
                        isReserved: false,
                        printsSearchURI: nil
                        //                        legalities: ["standard" : .legal]
        )
        CardDetail(card: card)
    }
}
