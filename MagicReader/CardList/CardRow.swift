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
            HStack {
                    AsyncImage(url: URL(string: card.imageSet?.small ?? "")) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()

                        case .failure(_):
                            Color.gray.opacity(0.1)
                        @unknown default:
                            Image(systemName: "exclamationmark.icloud")
                        }
                    }
                    .frame(width: 60, height: 70)

                VStack(alignment: .leading, spacing: 6) {
                    Text(card.name)
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text(card.setName)
                        .font(.subheadline)
                    Text((card.prices.euro ?? "") + "€")
                        .font(.caption)
                }

                Spacer()
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
                        imageSet: ImageSet(png: "https://c1.scryfall.com/file/scryfall-cards/border_crop/front/6/d/6da045f8-6278-4c84-9d39-025adf0789c1.jpg?1562404626"),
                        colors: ["W"],
                        rarity: .common,
                        prices: PriceSet(euro: "5"))
        CardRow(card: card)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
