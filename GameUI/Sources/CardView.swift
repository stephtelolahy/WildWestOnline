//
//  CardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/03/2025.
//

import SwiftUI
import GameFeature

/// A view that displays a card
struct CardView: View {
    let content: CardContent
    var format: Format = .medium
    var disabled: Bool = false

    @Environment(\.theme) private var theme

    enum Format {
        case medium
        case large
    }

    var body: some View {
        Image(cardImageName, bundle: .module)
            .resizable()
            .scaledToFit()
            .background(
                Text(cardImageName.uppercased())
                    .font(theme.fontTitle)
                    .multilineTextAlignment(.center)
            )
            .frame(width: cardSize.width, height: cardSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 2)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text(cardValue)
                            .font(theme.fontHeadline)
                            .foregroundColor(.black)
                            .background(.white)
                            .padding([.leading, .bottom], 8)
                        Spacer()
                    }
                }
            )
            .opacity(disabled ? 0.5 : 1.0)
    }

    private var cardImageName: String {
        switch content {
        case .id(let id):
            Card.name(of: id)

        case .hidden:
            "card_back"
        }
    }

    private var cardValue: String {
        switch content {
        case .id(let id):
            Card.value(of: id)

        case .hidden:
            ""
        }
    }

    private var cardSize: CGSize {
        switch format {
        case .medium:
            CGSize(width: 67, height: 100)

        case .large:
            CGSize(width: 100, height: 150)
        }
    }
}

#Preview {
    ScrollView(.horizontal) {
        HStack {
            CardView(content: .id("bang-A♠️"), format: .large, disabled: true)
            CardView(content: .id("mustang-8♥️"), format: .large)
            CardView(content: .id("unknown card"), format: .large)
        }
    }
    .background(.yellow)
}
