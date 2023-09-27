//
//  ActionPlayAbility.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlayAbility: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // save played card
        var state = state
        state.incrementPlayCounter(for: card)

        // queue triggered effect
        state.queueOnPlayEffect(playReq: .onPlayAbility,
                                card: card,
                                player: player,
                                state: state)

        return state
    }
}
