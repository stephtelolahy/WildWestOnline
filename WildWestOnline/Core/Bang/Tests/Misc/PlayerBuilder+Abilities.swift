//
//  PlayerBuilder+Abilities.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 10/11/2024.
//
import Bang

extension Player.Builder {
    func withDefaultAbilities() -> Self {
        self.withAbilities([
            .defaultEndTurn,
            .defaultDiscardExcessHandOnTurnEnded,
            .defaultStartTurnNextOnTurnEnded
        ])
    }
}
