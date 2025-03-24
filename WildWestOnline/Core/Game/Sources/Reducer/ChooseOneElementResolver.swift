//
//  ChooseOneElementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension Card.Selector.ChooseOneElement {
    func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension Card.Selector.ChooseOneElement {
    protocol Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved?
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
        let conditions: [Card.Selector.TargetCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
            let result = state.playOrder
                .starting(with: ctx.player)
                .dropFirst()
                .filter { conditions.match($0, state: state, ctx: ctx) }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            return .init(
                chooser: ctx.player,
                options: result.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct CardResolver: Resolver {
        let conditions: [Card.Selector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
            let playerObj = state.players.get(ctx.target!)
            var options: [Card.Selector.ChooseOneResolved.Option] = []
            options += playerObj.inPlay.map {
                .init(value: $0, label: $0)
            }
            options += playerObj.hand.indices.map {
                let value = playerObj.hand[$0]
                let label = ctx.player == ctx.target ? value : "\(String.hiddenHand)-\($0)"
                return .init(value: value, label: label)
            }
            options = options.filter { conditions.match($0.value, state: state, ctx: ctx) }

            guard options.isNotEmpty else {
                fatalError("No card matching \(conditions)")
            }

            return .init(
                chooser: ctx.player,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            var pendingAction = pendingAction
            NonStandardLogic.resolveCardSelection(selection, state: state, pendingAction: &pendingAction)
            return [pendingAction.withCard(selection)]
        }
    }

    struct DiscoveredResolver: Resolver {
        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
            .init(
                chooser: ctx.target!,
                options: state.discovered.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            [pendingAction.withCard(selection)]
        }
    }

    struct EventuallyCounterCardResolver: Resolver {
        let conditions: [Card.Selector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
            let counterCards = state.players.get(ctx.target!).hand.filter {
                conditions.match($0, state: state, ctx: ctx)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChooseOneResolved.Option] = counterCards.map { .init(value: $0, label: $0) }
            options.append(.init(value: .pass, label: .pass))
            return .init(
                chooser: ctx.target!,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            if selection == .pass {
                [pendingAction]
            } else {
                [GameAction.discardHand(selection, player: pendingAction.payload.target!)]
            }
        }
    }

    struct EventuallyReverseCardResolver: Resolver {
        let conditions: [Card.Selector.CardCondition]

        func resolveOptions(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> Card.Selector.ChooseOneResolved? {
            let counterCards = state.players.get(ctx.target!).hand.filter {
                conditions.match($0, state: state, ctx: ctx)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChooseOneResolved.Option] = counterCards.map { .init(value: $0, label: $0) }
            options.append(.init(value: .pass, label: .pass))
            return .init(
                chooser: ctx.target!,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameState, pendingAction: GameAction) throws(GameError) -> [GameAction] {
            if selection == .pass {
                return [pendingAction]
            } else {
                let reversedAction = pendingAction.copy(
                    withPlayer: pendingAction.payload.target!,
                    target: pendingAction.payload.player,
                    selectors: [.chooseOne(.eventuallyReverseCard(conditions))] + pendingAction.selectors
                )
                return [
                    GameAction.discardHand(selection, player: pendingAction.payload.target!),
                    reversedAction
                ]
            }
        }
    }
}

private extension Array where Element == Card.Selector.TargetCondition {
    func match(_ player: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        allSatisfy {
            $0.match(player, state: state, ctx: ctx)
        }
    }
}

private extension Array where Element == Card.Selector.CardCondition {
    func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        allSatisfy {
            $0.match(card, state: state, ctx: ctx)
        }
    }
}
