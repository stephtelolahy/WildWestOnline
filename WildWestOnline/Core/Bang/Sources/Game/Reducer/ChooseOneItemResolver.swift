//
//  ChooseOneItemResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension ActionSelector.ChooseOneDetails.Item {
    func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
        try resolver.resolve(pendingAction, state)
    }
}

private extension ActionSelector.ChooseOneDetails.Item {
    protocol Resolver {
        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): ChooseTarget(conditions: conditions)
        case .card: ChooseCard()
        }
    }

    struct ChooseTarget: Resolver {
        let conditions: [ActionSelector.TargetCondition]

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let possibleTargets = state.playOrder.starting(with: pendingAction.payload.actor)
                .filter { player in
                    conditions.allSatisfy { condition in
                        condition.match(player, state: state, ctx: pendingAction.payload)
                    }
                }

            guard possibleTargets.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            guard possibleTargets.count == 1 else {
                fatalError("Unimplemented choice")
            }

            let result = pendingAction.withTarget(possibleTargets[0])
            return [result]
        }
    }

    struct ChooseCard: Resolver {
        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let playerObj = state.players.get(pendingAction.payload.actor)
            let possibleCards: [String] = playerObj.hand + playerObj.inPlay
            guard possibleCards.isNotEmpty else {
                fatalError("No card")
            }

            guard possibleCards.count == 1 else {
                fatalError("Unimplemented choice")
            }

            var result = pendingAction
            result.payload.card = possibleCards[0]
            return [result]
        }
    }
}
