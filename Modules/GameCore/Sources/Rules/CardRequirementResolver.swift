//
//  CardRequirementResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/05/2026.
//

extension Card.Selector.CardRequirement {
    func resolve(pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> Card.Selector.ChoicePrompt {
        let target = pendingAction.requiredTarget
        switch self {
        case .fromTarget(let conditions):
            let player = pendingAction.sourcePlayer
            let targetObj = state.players.get(target)
            let inPlayOptions: [Card.Selector.ChoicePrompt.Option] = targetObj.inPlay.map { .init(id: $0, label: $0) }
            let handOptions: [Card.Selector.ChoicePrompt.Option] = targetObj.hand.enumerated().map { index, card in
                .init(id: card, label: player == target ? card : "\(String.choiceHiddenHand)-\(index)")
            }
            let options = (inPlayOptions + handOptions).filter { conditions.match($0.id, pendingAction: pendingAction, state: state) }
            guard options.isNotEmpty else {
                throw .noChoosableCard(conditions, player: target)
            }

            return .init(chooser: player, options: options)

        case .fromDiscovered:
            return .init(chooser: target, options: state.discovered.map { .init(id: $0, label: $0) })

        case .topDiscard:
            guard let topDiscard = state.discard.first else {
                throw .insufficientDiscard
            }

            return .init(chooser: target, choices: [topDiscard])
        }
    }
}

extension Card.Selector.ChoicePrompt {
    /// Prompt where each choice is its own label, followed by a pass option
    init(chooser: String, choices: [String]) {
        self.init(chooser: chooser, options: (choices + [.choicePass]).map { .init(id: $0, label: $0) })
    }
}
