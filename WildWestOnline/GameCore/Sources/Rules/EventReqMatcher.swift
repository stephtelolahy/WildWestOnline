//
//  EventReqMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 06/04/2025.
//

extension Card.EventReq {
    func match(event: Card.Effect, player: String, state: GameFeature.State) -> Bool {
        event.name == actionName
        && event.payload.target == player
        && playConditions.allSatisfy {
            $0.match(.init(player: player), state: state)
        }
    }
}
