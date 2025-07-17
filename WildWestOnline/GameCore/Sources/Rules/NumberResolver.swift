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
        case .fixed(let rawValue): Fixed(rawValue: rawValue)
        case .activePlayerCount: ActivePlayerCount()
        case .playerExcessHandSize: PlayerExcessHandSize()
        case .drawnCardCount: DrawnCardCount()
        case .receivedDamageAmount: ReceivedDamageAmount()
        }
    }

    struct Fixed: Resolver {
        let rawValue: Int

        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            rawValue
        }
    }

    struct ActivePlayerCount: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            state.playOrder.count
        }
    }

    struct PlayerExcessHandSize: Resolver {
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

    struct DrawnCardCount: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            let player = pendingAction.payload.player
            let playerObj = state.players.get(player)
            return playerObj.drawCards
        }
    }

    struct ReceivedDamageAmount: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> Int {
            guard pendingAction.triggeredByName == .damage,
                  let amount = pendingAction.triggeredByPayload?.amount else {
                fatalError("Expected trigger from damage")
            }

            return amount
        }
    }
}
