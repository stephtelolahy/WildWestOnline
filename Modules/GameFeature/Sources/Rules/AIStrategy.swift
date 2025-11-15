// swiftlint:disable force_unwrapping
//
//  AIStrategy.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

public protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action
}

public struct RandomStrategy: AIStrategy {
    public func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action {
        actions.randomElement()!
    }
}

public struct AgressiveStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameFeature.Action], state: GameFeature.State) -> GameFeature.Action {
        actions
            .shuffled()
            .min { evaluate($0, state: state) > evaluate($1, state: state) }!
    }

    private func evaluate(_ action: GameFeature.Action, state: GameFeature.State) -> Int {
        switch action.name {
        case .preparePlay:
            let cardName = Card.name(of: action.playedCard)
            let cardObj = state.cards.get(cardName)
            if let mainEffect = cardObj.mainEffect() {
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
            }

            return 0

        case .choose:
            guard let selection = action.chosenOption else {
                fatalError("Missing selection for choose action")
            }

            if selection == .choicePass {
                return -1
            } else {
                return 0
            }

        default:
            fatalError("Unexpected action \(action.name)")
        }
    }
}

private extension Card {
    func mainEffect() -> Card.ActionName? {
        if let preparePlayEffect = effects.first(where: { $0.trigger == .cardPrePlayed }) {
            if let playEffect = effects.first(where: { $0.trigger == .cardPlayed }) {
                return playEffect.action
            }
            return preparePlayEffect.action
        }
        return nil
    }
}
