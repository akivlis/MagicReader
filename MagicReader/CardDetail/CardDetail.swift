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
            Color.black
            ScrollView {
                VStack {

                    AsyncImage(url: card.detailImageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 500)
                    .padding(.horizontal)
                    .cornerRadius(12)

                    VStack(alignment: .leading) {
                        Text(card.name)
                            .font(.title)
                            .foregroundColor(.white)

                        HStack {
                            Text("SET")
                            Spacer()
                            Text(card.setName)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        HStack {
                            Text("ARTIST")
                            Spacer()
                            Text(card.artist)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        HStack {
                            Text("RARITY")
                            Spacer()
                            Text(card.rarity.rawValue)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        HStack {
                            Text("Reserved List:")
                            Spacer()
                            Text(card.reserved ? "✅" : "❌")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        Divider()

                        HStack {
                            Text("Price")
                            Spacer()
                            Text((card.prices.euro ?? "") + "€")
                        }
                        .font(.headline)
                        .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    Spacer()
                }

            }.onAppear {
                print("Downloading image: \(card.detailImageURL)")
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
                        colors: ["W"],
                        artist: "Silvi",
                        rarity: .common,
                        prices: PriceSet(),
                        reserved: false)
        CardDetail(card: card)
    }
}
