//
//  PlayerView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//
import SwiftUI

// Displays a player's information including figure image, name, role, health, hand count, and in-play cards.
struct PlayerView: View {
    var player: GameView.ViewState.PlayerItem

    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: 4) {
            // Figure image
            Image(player.imageName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.primary, lineWidth: 1))

            // Name and role
            Text(player.displayName.uppercased())
                .font(theme.fontHeadline)

            // Health display with hearts
            HStack(spacing: 2) {
                ForEach(0..<player.health, id: \.self) { _ in
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(theme.fontHeadline)
                }

                // Hand count
                Text("[]\(player.handCount)")
                    .font(theme.fontHeadline)
            }

            // In-play cards (displayed as a compact label)
            if !player.inPlay.isEmpty {
                HStack(spacing: 2) {
                    ForEach(player.inPlay, id: \.self) { card in
                        Text(card.prefix(2).uppercased())
                            .font(theme.fontHeadline)
                            .padding(4)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(6)
        .cornerRadius(8)
        .opacity(player.isEliminated ? 0.3 : 1)
        .foregroundStyle(player.foregroundColor)
    }
}

private extension GameView.ViewState.PlayerItem {
    var foregroundColor: Color {
        if isTargeted {
            Color(.systemRed)
        } else {
            Color.primary
        }
    }
}

#Preview {
    PlayerView(
        player: .init(
            id: "p1",
            imageName: "willyTheKid",
            displayName: "willyTheKid",
            health: 2,
            maxHealth: 4,
            handCount: 5,
            inPlay: ["scope", "jail"],
            isTurn: false,
            isTargeted: false,
            isEliminated: false,
            role: nil,
            userPhotoUrl: nil
        )
    )
}
