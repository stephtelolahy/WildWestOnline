//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.Number {
    func resolve(player: String, state: GameFeature.State) -> Int {
        resolver.resolve(player: player, state: state)
    }
}

private extension Card.Selector.Number {
    protocol Resolver {
        func resolve(player: String, state: GameFeature.State) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        case .activePlayers: ActivePlayers()
        case .excessHand: ExcessHand()
        case .drawCards: DrawCards()
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(player: String, state: GameFeature.State) -> Int {
            rawValue
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(player: String, state: GameFeature.State) -> Int {
            state.playOrder.count
        }
    }

    struct ExcessHand: Resolver {
        func resolve(player: String, state: GameFeature.State) -> Int {
            let playerObj = state.players.get(player)
            let handlLimit = if playerObj.handLimit > 0 {
                playerObj.handLimit
            } else {
                playerObj.health
            }

            let handCount = playerObj.hand.count
            return max(handCount - handlLimit, 0)
        }
    }

    struct DrawCards: Resolver {
        func resolve(player: String, state: GameFeature.State) -> Int {
            let playerObj = state.players.get(player)
            return playerObj.drawCards
        }
    }
}
