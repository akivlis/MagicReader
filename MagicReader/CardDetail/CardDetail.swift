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
            Color.black.ignoresSafeArea()
            VStack {
                Image("burgeoning")
                    .resizable()
                    .scaledToFit()

                VStack(alignment: .leading) {
                    Text(card.name)
                        .font(.title)
                        .foregroundColor(.white)

                    HStack {
                        Text("Set")
                        Spacer()
                        Text(card.setName)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Divider()

                    Text("Artist")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(card.artist ?? "")
                }
                .padding()

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
                        imageURL: "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card",
                        colors: ["W"],
                        artist: "Silvi")
        CardDetail(card: card)
    }
}
