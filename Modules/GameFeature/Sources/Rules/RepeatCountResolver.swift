//
//  RepeatCountResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.RepeatCount {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.RepeatCount {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .fixed(let rawValue): Fixed(rawValue: rawValue)
        case .activePlayerCount: ActivePlayerCount()
        case .playerExcessHandSize: PlayerExcessHandSize()
        case .cardsPerDraw: CardsPerDraw()
        case .cardsPerTurn: CardsPerTurn()
        case .receivedDamageAmount: ReceivedDamageAmount()
        }
    }

    struct Fixed: Resolver {
        let rawValue: Int

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            rawValue
        }
    }

    struct ActivePlayerCount: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            state.playOrder.count
        }
    }

    struct PlayerExcessHandSize: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            let player = pendingAction.sourcePlayer
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

    struct CardsPerDraw: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            let player = pendingAction.sourcePlayer
            let playerObj = state.players.get(player)
            return playerObj.cardsPerDraw
        }
    }

    struct CardsPerTurn: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            let player = pendingAction.sourcePlayer
            let playerObj = state.players.get(player)
            return playerObj.cardsPerTurn + (pendingAction.contextCardsPerTurn ?? 0)
        }
    }

    struct ReceivedDamageAmount: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage,
                  let amount = parentAction.amount else {
                fatalError("Expected trigger from damage")
            }

            return amount
        }
    }
}
