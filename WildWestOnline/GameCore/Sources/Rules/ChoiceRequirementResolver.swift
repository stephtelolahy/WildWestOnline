//
//  ChoiceRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//

extension Card.Selector.ChoiceRequirement {
    func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
        try resolver.resolveOptions(state, ctx: ctx)
    }

    func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
        try resolver.resolveSelection(selection, state: state, pendingAction: pendingAction)
    }
}

private extension Card.Selector.ChoiceRequirement {
    protocol Resolver {
        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt?
        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): Target(conditions: conditions)
        case .targetCard(let conditions): TargetCard(conditions: conditions)
        case .discoveredCard: DiscoveredCard()
        case .optionalCounterCard(let conditions): OptionalCounterCard(conditions: conditions)
        case .optionalRedirectCard(let conditions): OptionalRedirectCard(conditions: conditions)
        }
    }

    struct Target: Resolver {
        let conditions: [Card.Selector.TargetFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let result = state.playOrder
                .starting(with: ctx.player)
                .dropFirst()
                .filter { conditions.match($0, state: state, ctx: ctx) }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            return .init(
                chooser: ctx.player,
                options: result.map { .init(id: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct TargetCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let playerObj = state.players.get(ctx.target!)
            var options: [Card.Selector.ChoicePrompt.Option] = []
            options += playerObj.inPlay.map {
                .init(id: $0, label: $0)
            }
            options += playerObj.hand.indices.map {
                let value = playerObj.hand[$0]
                let label = ctx.player == ctx.target ? value : "\(String.choiceHiddenHand)-\($0)"
                return .init(id: value, label: label)
            }
            options = options.filter { conditions.match($0.id, state: state, ctx: ctx) }

            guard options.isNotEmpty else {
                fatalError("No card matching \(conditions)")
            }

            return .init(
                chooser: ctx.player,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct DiscoveredCard: Resolver {
        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            .init(
                chooser: ctx.target!,
                options: state.discovered.map { .init(id: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct OptionalCounterCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let counterCards = state.players.get(ctx.target!).hand.filter {
                conditions.match($0, state: state, ctx: ctx)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChoicePrompt.Option] = counterCards.map { .init(id: $0, label: $0) }
            options.append(.init(id: .choicePass, label: .choicePass))
            return .init(
                chooser: ctx.target!,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
            if selection == .choicePass {
                [pendingAction]
            } else {
                [Card.Effect.discardHand(selection, player: pendingAction.payload.target!)]
            }
        }
    }

    struct OptionalRedirectCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let counterCards = state.players.get(ctx.target!).hand.filter {
                conditions.match($0, state: state, ctx: ctx)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChoicePrompt.Option] = counterCards.map { .init(id: $0, label: $0) }
            options.append(.init(id: .choicePass, label: .choicePass))
            return .init(
                chooser: ctx.target!,
                options: options
            )
        }

        func resolveSelection(_ selection: String, state: GameFeature.State, pendingAction: Card.Effect) throws(Card.PlayError) -> [Card.Effect] {
            if selection == .choicePass {
                return [pendingAction]
            } else {
                let reversedAction = pendingAction.copy(
                    withPlayer: pendingAction.payload.target!,
                    target: pendingAction.payload.player,
                    selectors: [.chooseOne(.optionalRedirectCard(conditions))] + pendingAction.selectors
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
