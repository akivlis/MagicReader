//
//  CardRow.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import SwiftUI

struct CardRow: View {
    var card: Card

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.headline)
                    .foregroundColor(.blue)
                Text(card.type)
                    .font(.subheadline)
                Text(card.setName)
                    .font(.subheadline)
            }
        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(cardId: "123",
                        name: "Archangel Avacyn",
                        type: "Legendary Creature — Angel",
                        text: "Archangel Avacyn enters the battlefield, creatures you control gain indestructible until end of turn.",
                        setName: "Adventures in the Forgotten Realms",
                        power: "4",
                        imageURL: "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=409741&type=card",
                        colors: ["W"])
        CardRow(card: card)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
