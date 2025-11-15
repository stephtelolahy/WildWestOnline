//
//  AIStrategy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public struct AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action? {
        guard !actions.isEmpty else {
            return nil
        }

        var bestAction: GameFeature.Action?
        var bestScore: Int = .min

        for action in actions.shuffled() {
            let score = evaluate(action, state: state)
            if score > bestScore {
                bestScore = score
                bestAction = action
            }
        }

        return bestAction
    }

    public func evaluate(_ action: GameFeature.Action, state: GameFeature.State) -> Int {
        switch action.name {
        case .preparePlay:
            let cardName = Card.name(of: action.playedCard)
            let cardObj = state.cards.get(cardName)

            guard let mainEffect = cardObj.mainEffect() else {
                fatalError("Missing main effect for card \(cardName)")
            }

            let actionValue: [Card.ActionName: Int] = [
                .shoot: 3,
                .damage: 3,
                .handicap: 3,
                .discardHand: 1,
                .discardInPlay: 1,
                .stealHand: 1,
                .stealInPlay: 1,
                .endTurn: -1,
            ]
            return actionValue[mainEffect] ?? 0

        case .choose:
            guard let selection = action.chosenOption else {
                fatalError("Missing selection for action choose")
            }

            return selection == .choicePass ? -1 : 0

        default:
            fatalError("Unexpected action \(action.name)")
        }
    }
}

private extension Card {
    func mainEffect() -> Card.ActionName? {
        if let playEffect = effects.first(where: { $0.trigger == .cardPlayed }) {
            return playEffect.action
        }
        if let preparePlayEffect = effects.first(where: { $0.trigger == .cardPrePlayed }) {
            return preparePlayEffect.action
        }
        return nil
    }
}
