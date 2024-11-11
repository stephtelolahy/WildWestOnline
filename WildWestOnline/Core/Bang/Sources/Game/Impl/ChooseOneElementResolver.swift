//
//  ChooseOneElementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension ActionSelector.ChooseOneElement {
    func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension ActionSelector.ChooseOneElement {
    protocol Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved?
        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): TargetResolver(conditions: conditions)
        case .card(let conditions): CardResolver(conditions: conditions)
        case .discovered: DiscoveredResolver()
        case .eventuallyCounterCard(let conditions): EventuallyCounterCardResolver(conditions: conditions)
        case .eventuallyReverseCard(let conditions): EventuallyReverseCardResolver(conditions: conditions)
        }
    }

    struct TargetResolver: Resolver {
        let conditions: [ActionSelector.TargetCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
            let result = state.playOrder
                .starting(with: ctx.actor)
                .dropFirst()
                .filter { conditions.match($0, state: state, ctx: ctx) }

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
        let conditions: [ActionSelector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
            let playerObj = state.players.get(ctx.target)
            let options: [ActionSelector.ChooseOneResolved.Option] =
            playerObj.inPlay.map { .init(value: $0, label: $0) } +
            playerObj.hand.indices.map {
                let value = playerObj.hand[$0]
                let label = ctx.actor == ctx.target ? value : "\(String.hiddenHand)-\($0)"
                return .init(value: value, label: label)
            }
            .filter { conditions.match($0.value, state: state, ctx: ctx) }

            guard options.isNotEmpty else {
                fatalError("No card matching \(conditions)")
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
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
            .init(
                chooser: ctx.target,
                options: state.discovered.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withCard(selection)]
        }
    }

    struct EventuallyCounterCardResolver: Resolver {
        let conditions: [ActionSelector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
            let counterCards = state.players.get(ctx.target).hand.filter { card in
                conditions.allSatisfy { condition in
                    condition.match(card, state: state, ctx: ctx)
                }
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [ActionSelector.ChooseOneResolved.Option] = counterCards.map { .init(value: $0, label: $0) }
            options.append(.init(value: .pass, label: .pass))
            return .init(
                chooser: ctx.target,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            if selection == .pass {
                [pendingAction]
            } else {
                [GameAction.discard(selection, player: pendingAction.payload.target)]
            }
        }
    }

    struct EventuallyReverseCardResolver: Resolver {
        let conditions: [ActionSelector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> ActionSelector.ChooseOneResolved? {
            let counterCards = state.players.get(ctx.target).hand.filter { card in
                conditions.allSatisfy { condition in
                    condition.match(card, state: state, ctx: ctx)
                }
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [ActionSelector.ChooseOneResolved.Option] = counterCards.map { .init(value: $0, label: $0) }
            options.append(.init(value: .pass, label: .pass))
            return .init(
                chooser: ctx.target,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            if selection == .pass {
                return [pendingAction]
            } else {
                var reversedAction = pendingAction
                let actor = pendingAction.payload.actor
                reversedAction.payload.actor = pendingAction.payload.target
                reversedAction.payload.target = actor
                reversedAction.payload.selectors.insert(.chooseOne(.eventuallyReverseCard(conditions)), at: 0)
                return [
                    GameAction.discard(selection, player: pendingAction.payload.target),
                    reversedAction
                ]
            }
        }
    }
}

private extension Array where Element == ActionSelector.TargetCondition {
    func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        allSatisfy {
            $0.match(player, state: state, ctx: ctx)
        }
    }
}

private extension Array where Element == ActionSelector.CardCondition {
    func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        allSatisfy {
            $0.match(card, state: state, ctx: ctx)
        }
    }
}
