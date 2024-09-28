//
//  StateConditionMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

protocol StateConditionMatcher {
    func match(state: GameState) -> Bool
}

public extension TriggeredAbility.Selector.StateCondition {
    enum Error: Swift.Error, Equatable {
        case noReq(TriggeredAbility.Selector.StateCondition)
    }

    func resolve(state: GameState) throws {
        let matched = matcher.match(state: state)
        guard matched else {
            throw Error.noReq(self)
        }
    }

    private var matcher: StateConditionMatcher {
        switch self {
        case .playersAtLeast(let minCount):
            PlayersAtLeast(minCount: minCount)
        case .limitPerTurn(let int):
            fatalError()
        case .draw(let string):
            fatalError()
        case .actorTurn:
            fatalError()
        case .discardedCardsNotAce:
            fatalError()
        case .hasNoBlueCardsInPlay:
            fatalError()
        case .targetHealthIs1:
            fatalError()
        case .not(let self):
            fatalError()
        }
    }
}

struct PlayersAtLeast: StateConditionMatcher {
    let minCount: Int

    func match(state: GameState) -> Bool {
        state.playOrder.count >= minCount
    }
}
