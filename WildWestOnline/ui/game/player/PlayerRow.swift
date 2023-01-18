//
//  PlayerView.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//

import SwiftUI

struct PlayerRow: View {
    let player: PlayerRow.Data
    
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

struct PlayerRow_Previews: PreviewProvider {
    static var previews: some View {
        let playerId = Sample.game.playOrder[0]
        let player = Sample.game.player(playerId)
        Group {
            PlayerRow(player: .init(player: player))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
