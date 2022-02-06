//
//  CardGridItem.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 06.02.22.
//

import SwiftUI

struct CardGridItem: View {

    var card: Card

    var body: some View {
        VStack {
            VStack(alignment: .center) {
                    AsyncImage(url: URL(string: card.imageSet?.small ?? "")) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)

                        case .failure(_):
                            Color.gray.opacity(0.1)
                        @unknown default:
                            Image(systemName: "exclamationmark.icloud")
                        }
                    }
                    .frame(width: 150, height: 230)

                VStack(alignment: .center, spacing: 6) {
                    Text(card.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(card.setName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text((card.prices.euro ?? "") + "€")
                        .font(.caption)
                }
            }
        }
    }
}

struct CardGridItem_Previews: PreviewProvider {
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
                        prices: PriceSet(euro: "5"),
                        reserved: false)
        CardGridItem(card: card)
            .previewLayout(.sizeThatFits)
    }
}
