//
//  ChooseOneElementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension ActionSelector.ChooseOneElement {
    func resolveChoice(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension ActionSelector.ChooseOneElement {
    protocol Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved
        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): TargetResolver(conditions: conditions)
        case .card: CardResolver()
        case .discovered: DiscoveredResolver()
        }
    }

    struct TargetResolver: Resolver {
        let conditions: [ActionSelector.TargetCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved {
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

            return .init(
                chooser: ctx.actor,
                options: result.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct CardResolver: Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved {
            let playerObj = state.players.get(ctx.target)
            let options: [ActionSelector.ChooseOneResolved.Option] =
            playerObj.inPlay.indices.map {
                .init(value: playerObj.inPlay[$0], label: playerObj.inPlay[$0])
            }
            +
            playerObj.hand.indices.map {
                .init(value: playerObj.hand[$0], label: "hiddenHand-\($0)")
            }

            guard options.isNotEmpty else {
                fatalError("No card")
            }

            return .init(
                chooser: ctx.actor,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withCard(selection)]
        }
    }

    struct DiscoveredResolver: Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved {
            .init(
                chooser: ctx.target,
                options: state.discovered.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withCard(selection)]
        }
    }
}
