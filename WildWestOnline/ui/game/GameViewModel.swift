//
//  GameViewModel.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Combine
import Bang

extension GameView {
    class ViewModel: ObservableObject {
        @Published var message: String = "Your turn"
        @Published var players: [PlayerView.ViewModel] = []
        
        init(ctx: Game) {
            players = ctx.players.map({ PlayerView.ViewModel(id: $0.key, name: $0.value.name) })
        }
    }
}
