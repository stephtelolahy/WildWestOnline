//
//  Matcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

extension TriggeredAbility.Selector.StateCondition {
    func resolve(state: GameState) throws {
        guard matcher.match(state: state) else {
            throw Error.noReq(self)
        }
    }
}

public extension TriggeredAbility.Selector.StateCondition {
    enum Error: Swift.Error, Equatable {
        case noReq(TriggeredAbility.Selector.StateCondition)
    }
}

private extension TriggeredAbility.Selector.StateCondition {
    protocol Matcher {
        func match(state: GameState) -> Bool
    }

    var matcher: Matcher {
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

    struct PlayersAtLeast: Matcher {
        let minCount: Int

        func match(state: GameState) -> Bool {
            state.playOrder.count >= minCount
        }
    }
}
