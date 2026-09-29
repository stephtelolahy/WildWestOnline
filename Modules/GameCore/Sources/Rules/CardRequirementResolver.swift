//
//  CardRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/05/2026.
//

extension Card.Selector.CardRequirement {
    func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt {
        try resolver.resolve(pendingAction: pendingAction, state: state)
    }
}

private extension Card.Selector.CardRequirement {
    protocol Resolver {
        func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt
    }

    var resolver: Resolver {
        switch self {
        case .fromTarget(let conditions): FromTarget(conditions: conditions)
        case .fromDiscovered: FromDiscovered()
        case .topDiscard: TopDiscard()
        }
    }

    struct FromTarget: Resolver {
        let conditions: [Card.Selector.CardFilter]

        func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            let player = pendingAction.sourcePlayer
            let targetObj = state.players.get(target)

            var options: [Card.Selector.ChoicePrompt.Option] = []

            options += targetObj.inPlay.map {
                .init(id: $0, label: $0)
            }

            options += targetObj.hand.indices.map {
                let value = targetObj.hand[$0]
                let label = player == target ? value : "\(String.choiceHiddenHand)-\($0)"
                return .init(id: value, label: label)
            }

            options = options.filter { conditions.match($0.id, pendingAction: pendingAction, state: state) }

            guard options.isNotEmpty else {
                throw .noChoosableCard(conditions, player: target)
            }

            return Card.Selector.ChoicePrompt(chooser: player, options: options)
        }
    }

    struct FromDiscovered: Resolver {
        func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return Card.Selector.ChoicePrompt(
                chooser: target,
                options: state.discovered.map { .init(id: $0, label: $0) }
            )
        }
    }

    struct TopDiscard: Resolver {
        func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            guard let topDiscard = state.discard.first else {
                throw .insufficientDiscard
            }

            return Card.Selector.ChoicePrompt(
                chooser: target,
                options: [
                    .init(id: topDiscard, label: topDiscard),
                    .init(id: .choicePass, label: .choicePass)
                ]
            )
        }
    }
}
