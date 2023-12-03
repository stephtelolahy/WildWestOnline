//
//  PlayerView.swift
//
//
//  Created by Hugues Telolahy on 09/07/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import Inventory
import SwiftUI

struct PlayerView: View {
    let player: Player

    var body: some View {
        HStack {
            CircleImage(image: player.image)
            Text("\(player.figure)\n[]\(player.hand.count)")
            Spacer()
            ForEach((0..<player.health), id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    Group {
        PlayerView(
            player: Player.makeBuilder()
                .withFigure(.bartCassidy)
                .withHand(["c1", "c2"])
                .withHealth(2)
                .build()
        )
    }
    .previewLayout(.fixed(width: 300, height: 70))
}

extension Player {
    var image: Image {
        Image(figure, bundle: Bundle.module)
    }
}
