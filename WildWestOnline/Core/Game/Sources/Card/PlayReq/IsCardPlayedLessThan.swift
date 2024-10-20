//
//  IsCardPlayedLessThan.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct IsCardPlayedLessThan: PlayReqMatcher {
    let cardName: String
    let playedMaxTimes: ArgNum

    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        let numContext = EffectContext(
            sourceEvent: .nothing,
            sourceActor: ctx.actor,
            sourceCard: ""
        )
        guard let maxNumber = try? playedMaxTimes.resolve(state: state, ctx: numContext) else {
            fatalError("unresolved ArgNum \(playedMaxTimes)")
        }

        guard maxNumber > 0 else {
            return true
        }

        let playedTimes = state.sequence.played[cardName] ?? 0
        return playedTimes < maxNumber
    }
}
