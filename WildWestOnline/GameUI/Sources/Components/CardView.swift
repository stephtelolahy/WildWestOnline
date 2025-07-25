//
//  CardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/03/2025.
//

import SwiftUI
import GameCore

/// A view that displays a card
struct CardView: View {
    let content: CardContent
    var format: Format = .medium
    var active: Bool = false

    @Environment(\.theme) private var theme

    enum Format {
        case medium
        case large
    }

    var body: some View {
        let uiImage = UIImage(named: cardImageName, in: .module, compatibleWith: nil)
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Text(cardImageName.uppercased())
                    .font(theme.fontTitle)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: cardSize.width, maxHeight: cardSize.height)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(active ? Color.green : Color.gray, lineWidth: active ? 4 : 1)
        )
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
    }

    private var cardImageName: String {
        switch content {
        case .id(let id):
            Card.extractName(from: id)
        case .hidden:
            "card_back"
        }
    }

    private var cardValue: String {
        switch content {
        case .id(let id):
            Card.extractValue(from: id)
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
            CardView(content: .id("bang-A♠️"), format: .large)
            CardView(content: .id("mustang-8♥️"), format: .large, active: true)
            CardView(content: .id("unknown card"), format: .large, active: true)
        }
    }
    .background(.yellow)
}
