//
//  CardFilterMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//
extension Card.Selector.CardFilter {
    func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        let cardName = Card.name(of: card)
        switch self {
        case .inHand:
            return state.players.get(pendingAction.requiredTarget).hand.contains(card)

        case .canCounterShot:
            return state.alias(for: cardName, player: pendingAction.sourcePlayer, action: .counterShot, on: .played) != nil
            || state.cards.get(cardName).effects.contains { $0.trigger == .played && $0.action == .counterShot }

        case .named(let name):
            return cardName == name
        }
    }
}
