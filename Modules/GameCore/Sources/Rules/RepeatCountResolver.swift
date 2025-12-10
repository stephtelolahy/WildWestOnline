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
        case .receivedDamageAmount: ReceivedDamageAmount()
        case .requiredMisses: RequiredMisses()
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
            let handlLimit = playerObj.health
            let handCount = playerObj.hand.count
            return max(handCount - handlLimit, 0)
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

    struct RequiredMisses: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> Int {
            guard let damageIndex = state.queue.firstIndex(where: {
                $0.triggeredBy.first?.name == .shoot
                && $0.name == .damage
                && $0.targetedPlayer == pendingAction.targetedPlayer
            }) else {
                fatalError("Missing .shoot effect on targetedPlayer")
            }

            let damageAction = state.queue[damageIndex]
            guard let requiredMisses = damageAction.requiredMisses else { fatalError("Missing requiredMisses") }

            return requiredMisses
        }
    }
}
