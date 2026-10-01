//
//  CardTargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.CardTarget {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
        switch self {
        case .source:
            return [pendingAction.sourceCard]

        case .equippedWeapon:
            return state.players.get(pendingAction.requiredTarget).inPlay.filter { state.isWeapon($0) }

        case .lastDrawn:
            let target = pendingAction.requiredTarget
            guard let card = state.players.get(target).hand.last else { fatalError("Missing last card in hand of player \(target)") }
            return [card]

        case .trigger:
            return pendingAction.triggeredBy.first?.targetedCard.map { [$0] }

        case .every(let group):
            return group.resolve(pendingAction, state: state)
        }
    }
}

private extension GameFeature.State {
    func isWeapon(_ card: String) -> Bool {
        cards.get(Card.name(of: card)).effects.contains { $0.trigger == .equiped && $0.action == .setWeapon }
    }
}
