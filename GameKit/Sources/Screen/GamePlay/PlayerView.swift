//
//  PlayerView.swift
//  
//
//  Created by Hugues Telolahy on 09/07/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import SwiftUI

struct PlayerView: View {
    let player: Player

    var body: some View {
        HStack {
            CircleImage(image: player.image)
            Text(player.figure)
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .padding()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player.makeBuilder().withId("bartCassidy").build()
        Group {
            PlayerView(player: player)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

private extension Player {
    var image: Image {
        Image(figure, bundle: Bundle.module)
    }
}
