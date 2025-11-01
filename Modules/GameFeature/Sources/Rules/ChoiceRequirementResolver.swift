//
//  ChoiceRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2024.
//
// swiftlint:disable force_unwrapping

extension Card.Selector.ChoiceRequirement {
    func resolveOptions(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
        try resolver.resolveOptions(self, pendingAction: pendingAction, state: state)
    }

    func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
        try resolver.resolveSelection(selection, pendingAction: pendingAction, state: state)
    }
}

private extension Card.Selector.ChoiceRequirement {
    protocol Resolver {
        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action]
        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action]
    }

    var resolver: Resolver {
        switch self {
        case .targetPlayer(let conditions): TargetPlayer(conditions: conditions)
        case .targetCard(let conditions): TargetCard(conditions: conditions)
        case .costCard(let conditions): CostCard(conditions: conditions)
        case .discoverCard: DiscoverCard()
        case .counterCard(let conditions): CounterCard(conditions: conditions)
        case .redirectCard(let conditions): RedirectCard(conditions: conditions)
        }
    }

    struct TargetPlayer: Resolver {
        let conditions: [Card.Selector.PlayerFilter]

        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            let player = pendingAction.sourcePlayer
            let result = state.playOrder
                .starting(with: player)
                .dropFirst()
                .filter { conditions.match($0, pendingAction: pendingAction, state: state) }

            guard result.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            let prompt = Card.Selector.ChoicePrompt(
                chooser: player,
                options: result.map { .init(id: $0, label: $0) }
            )

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            [pendingAction.withTarget(selection)]
        }
    }

    struct TargetCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
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

            let prompt = Card.Selector.ChoicePrompt(
                chooser: player,
                options: options
            )

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            [pendingAction.withCard(selection)]
        }
    }

    struct CostCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
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
                return []
            }

            options.append(.init(id: .choicePass, label: .choicePass))

            let prompt = Card.Selector.ChoicePrompt(
                chooser: player,
                options: options
            )

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            if selection == .choicePass {
                []
            } else {
                [
                    .discardHand(selection, player: pendingAction.targetedPlayer!),
                    pendingAction
                ]
            }
        }
    }

    struct DiscoverCard: Resolver {
        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            let prompt = Card.Selector.ChoicePrompt(
                chooser: pendingAction.targetedPlayer!,
                options: state.discovered.map { .init(id: $0, label: $0) }
            )

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            [pendingAction.withCard(selection)]
        }
    }

    struct CounterCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            let target = pendingAction.targetedPlayer!
            let counterCards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }

            guard counterCards.isNotEmpty else {
                return [pendingAction]
            }

            let options: [Card.Selector.ChoicePrompt.Option] = counterCards.map { .init(id: $0, label: $0) }
                + [.init(id: .choicePass, label: .choicePass)]
            let prompt = Card.Selector.ChoicePrompt(chooser: target, options: options)

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            if selection == .choicePass {
                [pendingAction]
            } else {
                [.discardHand(selection, player: pendingAction.targetedPlayer!)]
            }
        }
    }

    struct RedirectCard: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolveOptions(_ requirement: Card.Selector.ChoiceRequirement, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            let target = pendingAction.targetedPlayer!
            let redirectCards = state.players.get(target).hand.filter {
                conditions.match($0, pendingAction: pendingAction, state: state)
            }

            guard redirectCards.isNotEmpty else {
                return [pendingAction]
            }

            let options: [Card.Selector.ChoicePrompt.Option] = redirectCards.map { .init(id: $0, label: $0) }
                + [.init(id: .choicePass, label: .choicePass)]
            let prompt = Card.Selector.ChoicePrompt(chooser: target, options: options)

            return [pendingAction.withChoice(requirement, prompt: prompt)]
        }

        func resolveSelection(_ selection: String, pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [GameFeature.Action] {
            if selection == .choicePass {
                return [pendingAction]
            } else {
                let reversedAction = pendingAction.copy(
                    withPlayer: pendingAction.targetedPlayer,
                    targetedPlayer: pendingAction.sourcePlayer,
                    selectors: [.chooseOne(.redirectCard(conditions))] + pendingAction.selectors
                )
                return [
                    .discardHand(selection, player: pendingAction.targetedPlayer!),
                    reversedAction
                ]
            }
        }
    }
}

private extension Array where Element == Card.Selector.PlayerFilter {
    func match(_ player: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(player, pendingAction: pendingAction, state: state)
        }
    }
}

private extension Array where Element == Card.Selector.CardFilter {
    func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        allSatisfy {
            $0.match(card, pendingAction: pendingAction, state: state)
        }
    }
}

private extension GameFeature.Action {
    func withChoice(
        _ requirement: Card.Selector.ChoiceRequirement,
        prompt: Card.Selector.ChoicePrompt
    ) -> Self {
        var copy = self
        copy.selectors.insert(.chooseOne(requirement, prompt: prompt), at: 0)
        return copy
    }
}
