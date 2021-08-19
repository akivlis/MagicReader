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
//            Color.black.ignoresSafeArea()
            ScrollView {
            VStack {
                AsyncImage(url: URL(string: card.imageSet.png),
                           transaction: Transaction(animation: .spring())) { phase in
                    switch phase {
                    case .empty:
                            Color.gray.opacity(0.1)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure(_):
                        ZStack {
                            Color.gray.opacity(0.1)
                            Text("No image for this card")
                        }
                    @unknown default:
                        Image(systemName: "exclamationmark.icloud")
                    }
                }
                .frame(width: 400, height: 500)
                .padding(.horizontal)
                .cornerRadius(5)

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

                    Divider()

                    Text("Price")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("here comes price")
                }
                .padding()

                Spacer()
            }
            }.onAppear {
                print("Downloading image: \(card.imageSet.borderCrop)")
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
                        rarity: .common)
        CardDetail(card: card)
    }
}
