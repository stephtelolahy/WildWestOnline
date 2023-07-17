//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 17/04/2023.
//

struct IsTimesPerTurn: PlayReqMatcherProtocol {
    let maxTimes: Int

    func match(state: GameState, ctx: EffectContext) -> Bool {
        // No limit
        guard maxTimes > 0 else {
            return false
        }

        let cardName = ctx.get(.card).extractName()
        let playedTimes = state.playCounter[cardName] ?? 0
        return playedTimes < maxTimes
    }
}
