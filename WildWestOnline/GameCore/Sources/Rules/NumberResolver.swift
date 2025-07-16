//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.Number {
    func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.Number {
    protocol Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        case .activePlayers: ActivePlayers()
        case .excessHand: ExcessHand()
        case .drawCards: DrawCards()
        case .damage: Damage()
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            rawValue
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            state.playOrder.count
        }
    }

    struct ExcessHand: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            let player = pendingAction.payload.player
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
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            let player = pendingAction.payload.player
            let playerObj = state.players.get(player)
            return playerObj.drawCards
        }
    }

    struct Damage: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            guard pendingAction.triggeredByName == .damage,
                  let damage = pendingAction.triggeredByPayload?.amount else {
                fatalError("Expecting damage event as triggering action")
            }

            return damage
        }
    }
}
