//
//  ChooseOneItemResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension ActionSelector.ChooseOneDetails.Item {
    func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension ActionSelector.ChooseOneDetails.Item {
    protocol Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String]
        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): TargetResolver(conditions: conditions)
        case .card: CardResolver()
        }
    }

    struct TargetResolver: Resolver {
        let conditions: [ActionSelector.TargetCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            let result = state.playOrder.starting(with: ctx.actor)
                .filter { player in
                    conditions.allSatisfy { condition in
                        condition.match(player, state: state, ctx: ctx)
                    }
                }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            return result
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct CardResolver: Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            let playerObj = state.players.get(ctx.actor)
            let result: [String] = playerObj.hand + playerObj.inPlay
            guard result.isNotEmpty else {
                fatalError("No card")
            }

            return result
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withCard(selection)]
        }
    }
}
