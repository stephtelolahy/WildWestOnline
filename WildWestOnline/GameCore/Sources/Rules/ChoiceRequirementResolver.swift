//
//  ChoiceRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//
// swiftlint:disable force_unwrapping

extension Card.Selector.ChoiceRequirement {
    func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
        try resolver.resolveOptions(pendingAction, state: state)
    }

    func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
        try resolver.resolveSelection(selection, pendingAction: pendingAction, state: state)
    }
}

private extension Card.Selector.ChoiceRequirement {
    protocol Resolver {
        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt?
        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect]
    }

    var resolver: Resolver {
        switch self {
        case .target(let conditions): Target(conditions: conditions)
        case .targetCard(let conditions): TargetCard(conditions: conditions)
        case .optionalCostCard(let conditions): OptionalCostCard(conditions: conditions)
        case .discoveredCard: DiscoveredCard()
        case .optionalCounterCard(let conditions): OptionalCounterCard(conditions: conditions)
        case .optionalRedirectCard(let conditions): OptionalRedirectCard(conditions: conditions)
        }
    }

    struct Target: Resolver {
        let conditions: [Card.Selector.TargetFilter]

        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let player = pendingAction.sourcePlayer
            let result = state.playOrder
                .starting(with: player)
                .dropFirst()
                .filter { conditions.match($0, pendingAction: pendingAction, state: state) }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            return .init(
                chooser: player,
                options: result.map { .init(id: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct TargetCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let player = pendingAction.sourcePlayer
            let target = pendingAction.targetedPlayer!
            let playerObj = state.players.get(target)
            var options: [Card.Selector.ChoicePrompt.Option] = []
            options += playerObj.inPlay.map {
                .init(id: $0, label: $0)
            }
            options += playerObj.hand.indices.map {
                let value = playerObj.hand[$0]
                let label = player == target ? value : "\(String.choiceHiddenHand)-\($0)"
                return .init(id: value, label: label)
            }
            options = options.filter { conditions.match($0.id, pendingAction: pendingAction, state: state) }

            guard options.isNotEmpty else {
                fatalError("No card matching \(conditions)")
            }

            return .init(
                chooser: player,
                options: options
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct OptionalCostCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let player = pendingAction.sourcePlayer
            let target = pendingAction.targetedPlayer!
            let playerObj = state.players.get(target)
            var options: [Card.Selector.ChoicePrompt.Option] = []
            options += playerObj.inPlay.map {
                .init(id: $0, label: $0)
            }
            options += playerObj.hand.indices.map {
                let value = playerObj.hand[$0]
                let label = player == target ? value : "\(String.choiceHiddenHand)-\($0)"
                return .init(id: value, label: label)
            }
            options = options.filter { conditions.match($0.id, pendingAction: pendingAction, state: state) }

            guard options.isNotEmpty else {
                return nil
            }

            options.append(.init(id: .choicePass, label: .choicePass))

            return .init(
                chooser: player,
                options: options
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            if selection == .choicePass {
                []
            } else {
                [
                    pendingAction,
                    Card.Effect.discardHand(selection, player: pendingAction.targetedPlayer!)
                ]
            }
        }
    }

    struct DiscoveredCard: Resolver {
        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            .init(
                chooser: pendingAction.targetedPlayer!,
                options: state.discovered.map { .init(id: $0, label: $0) }
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            [pendingAction.withCard(selection)]
        }
    }

    struct OptionalCounterCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let target = pendingAction.targetedPlayer!
            let counterCards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChoicePrompt.Option] = counterCards.map { .init(id: $0, label: $0) }
            options.append(.init(id: .choicePass, label: .choicePass))
            return .init(
                chooser: target,
                options: options
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            if selection == .choicePass {
                [pendingAction]
            } else {
                [Card.Effect.discardHand(selection, player: pendingAction.targetedPlayer!)]
            }
        }
    }

    struct OptionalRedirectCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> Card.Selector.ChoicePrompt? {
            let target = pendingAction.targetedPlayer!
            let counterCards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }

            guard counterCards.isNotEmpty else {
                return nil
            }

            var options: [Card.Selector.ChoicePrompt.Option] = counterCards.map { .init(id: $0, label: $0) }
            options.append(.init(id: .choicePass, label: .choicePass))
            return .init(
                chooser: target,
                options: options
            )
        }

        func resolveSelection(_ selection: String, pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [Card.Effect] {
            if selection == .choicePass {
                return [pendingAction]
            } else {
                let reversedAction = pendingAction.copy(
                    withPlayer: pendingAction.targetedPlayer,
                    targetedPlayer: pendingAction.sourcePlayer,
                    selectors: [.chooseOne(.optionalRedirectCard(conditions))] + pendingAction.selectors
                )
                return [
                    Card.Effect.discardHand(selection, player: pendingAction.targetedPlayer!),
                    reversedAction
                ]
            }
        }
    }
}

private extension Array where Element == Card.Selector.TargetFilter {
    func match(_ player: String, pendingAction: Card.Effect, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(player, pendingAction: pendingAction, state: state)
        }
    }
}

private extension Array where Element == Card.Selector.CardFilter {
    func match(_ card: String, pendingAction: Card.Effect, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(card, pendingAction: pendingAction, state: state)
        }
    }
}
