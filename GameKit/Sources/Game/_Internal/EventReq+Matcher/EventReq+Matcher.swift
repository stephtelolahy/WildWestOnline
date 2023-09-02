//
//  EventReq+Matcher.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 01/06/2023.
//

extension EventReq {
    func match(state: GameState, ctx: EffectContext) throws -> Bool {
        matcher().match(state: state, ctx: ctx)
    }
}

protocol EventReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool
}

private extension EventReq {
    func matcher() -> EventReqMatcherProtocol {
        switch self {
        case .onSetTurn:
            OnSetTurn()
        case .onLooseLastHealth:
            OnLooseLastHealth()
        case .onEliminated:
            OnEliminated()
        case .onPlay:
            EventReqNeverMatch()
        case .onForceDiscardHandNamed(let cardName):
            OnForceDiscardHandNamed(cardName: cardName)
        case .onDiscarded:
            OnDiscarded()
        default:
            fatalError("No matcher found for \(self)")
        }
    }
}

private struct EventReqNeverMatch: EventReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        false
    }
}
