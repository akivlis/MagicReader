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
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                GeometryReader { geometry in

                AsyncImage(url: URL(string: (card.imageSet?.small ?? card.cardFaces?.first?.imageSet?.small) ?? "")) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)

                        case .failure(_):
                            Color.gray.opacity(0.1)
                        @unknown default:
                            Image(systemName: "exclamationmark.icloud")
                        }
                    }
                }
                .frame(height: 230)

                VStack(alignment: .leading, spacing: 6) {
                    Text(card.name)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(card.setName)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text((card.prices.euro ?? (card.prices.euroFoil ?? "")) + "€")
                        .font(.caption)
                        .frame(alignment: .leading)
                }
                .padding(.horizontal)
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
                        cardFaces: nil,
                        colors: ["W"],
                        rarity: .common,
                        prices: PriceSet(euro: "5"),
                        isReserved: false,
                        printsSearchURI: nil
//                        legalities: ["standard" : .legal]
        )
        CardGridItem(card: card)
            .previewLayout(.sizeThatFits)
    }
}
