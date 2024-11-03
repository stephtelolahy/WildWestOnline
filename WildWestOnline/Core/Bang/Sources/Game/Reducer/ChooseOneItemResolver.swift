//
//  ChooseOneItemResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension ActionSelector.ChooseOneDetails.Item {
    func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [ActionSelector.ChooseOneDetails.Option] {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension ActionSelector.ChooseOneDetails.Item {
    protocol Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [ActionSelector.ChooseOneDetails.Option]
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

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [ActionSelector.ChooseOneDetails.Option] {
            let result = state.playOrder
                .starting(with: ctx.actor)
                .dropFirst()
                .filter { player in
                    conditions.allSatisfy { condition in
                        condition.match(player, state: state, ctx: ctx)
                    }
                }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            return result.map { .init(value: $0, label: $0) }
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct CardResolver: Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [ActionSelector.ChooseOneDetails.Option] {
            let playerObj = state.players.get(ctx.target)
            let result: [ActionSelector.ChooseOneDetails.Option] =
            playerObj.hand.indices.map {
                .init(value: playerObj.hand[$0], label: "hiddenHand-\($0)")
            }
            +
            playerObj.inPlay.indices.map {
                .init(value: playerObj.inPlay[$0], label: playerObj.inPlay[$0])
            }

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
