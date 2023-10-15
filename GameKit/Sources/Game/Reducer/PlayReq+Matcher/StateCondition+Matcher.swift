//
//  SateCondition+Matcher.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

extension SateCondition {
    func match(state: GameState, ctx: PlayReqContext) throws {
        let matched = matcher().match(state: state, ctx: ctx)
        guard matched else {
            throw GameError.noReq(self)
        }
    }
}

private extension SateCondition {
    func matcher() -> PlayReqMatcher {
        switch self {
        case let .isPlayersAtLeast(minCount):
            IsPlayersAtLeast(minCount: minCount)
        case let .isCardPlayedLessThan(cardName, playedMaxTimes):
            IsCardPlayedLessThan(cardName: cardName, playedMaxTimes: playedMaxTimes)
        case .isYourTurn:
            IsCurrentTurn()
        case .isOutOfTurn:
            IsOutOfTurn()
        }
    }
}
