//
//  GameViewModel.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Combine
import GameCore

extension GameView {
    class ViewModel: ObservableObject {
        @Published var message: String = "Your turn"
        @Published var players: [PlayerRow.Data] = []
        
        init(ctx: Game) {
            players = ctx.playOrder.map { PlayerRow.Data(player: ctx.player($0)) }
        }
    }
}
