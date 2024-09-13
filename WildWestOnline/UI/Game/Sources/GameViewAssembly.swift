//
//  GameViewAssembly.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 13/09/2024.
//

import SwiftUI
import AppCore
import NavigationCore
import Redux

public enum GameViewAssembly {
    public static func buildGameView(_ store: Store<AppState, Any>) -> some View {
        GameView {
            store.projection(
                using: GameViewConnector(controlledPlayerId: store.state.game!.round.startOrder.first!)
            )
        }
    }
}
