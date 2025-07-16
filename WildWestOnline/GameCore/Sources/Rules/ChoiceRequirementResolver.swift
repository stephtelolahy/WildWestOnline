//
//  ChoiceRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension Card.Selector.ChoiceRequirement {
    func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension Card.Selector.ChoiceRequirement {
    protocol Resolver {
        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved?
        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect]
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
        let conditions: [Card.Selector.TargetFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
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

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct CardResolver: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
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

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct DiscoveredResolver: Resolver {
        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
            .init(
                chooser: ctx.target!,
                options: state.discovered.map { .init(value: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct EventuallyCounterCardResolver: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
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

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
            if selection == .pass {
                [pendingAction]
            } else {
                [Card.Effect.discardHand(selection, player: pendingAction.payload.target!)]
            }
        }
    }

    struct EventuallyReverseCardResolver: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> Card.Selector.ChooseOneResolved? {
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

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.Failure) -> [Card.Effect] {
            if selection == .pass {
                return [pendingAction]
            } else {
                let reversedAction = pendingAction.copy(
                    withPlayer: pendingAction.payload.target!,
                    target: pendingAction.payload.player,
                    selectors: [.chooseOne(.eventuallyReverseCard(conditions))] + pendingAction.selectors
                )
                return [
                    Card.Effect.discardHand(selection, player: pendingAction.payload.target!),
                    reversedAction
                ]
            }
        }
    }
}

private extension Array where Element == Card.Selector.TargetFilter {
    func match(_ player: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
        allSatisfy {
            $0.match(player, state: state, ctx: ctx)
        }
    }
}

private extension Array where Element == Card.Selector.CardFilter {
    func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
        allSatisfy {
            $0.match(card, state: state, ctx: ctx)
        }
    }
}
