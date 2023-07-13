//
//  PlayerView.swift
//  
//
//  Created by Hugues Telolahy on 09/07/2023.
//

import SwiftUI
import Game

struct PlayerView: View {
    let player: Player

    var body: some View {
        HStack {
            CircleImage(image: player.image)
            Text(player.name)
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .padding()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player("p1")
            .name("bartCassidy")
        Group {
            PlayerView(player: player)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

private extension Player {
    var image: Image {
        Image(name, bundle: Bundle.module)
    }
}
