//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Number {
    func resolve(_ state: GameState) -> Int {
        resolver.resolve(state)
    }
}

private extension ActionSelector.Number {
    protocol Resolver {
        func resolve(_ state: GameState) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        case .activePlayers: ActivePlayers()
        case .excessHand: ExcessHand()
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(_ state: GameState) -> Int {
            rawValue
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ state: GameState) -> Int {
            state.playOrder.count
        }
    }

    struct ExcessHand: Resolver {
        func resolve(_ state: GameState) -> Int {
            // TODO: pass argument actor
            let actor = "p1"
            let playerObj = state.players.get(actor)
            let handlLimit = if playerObj.handLimit > 0 {
                playerObj.handLimit
            } else {
                playerObj.health
            } 
            let handCount = playerObj.hand.count
            return max(handCount - handlLimit, 0)
        }
    }
}
